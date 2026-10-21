const fs = require('node:fs');
const { spawnSync } = require('node:child_process');

const UI = ['RoutineLibraryUITests', 'WeekPlanUITests', 'ExecutionUITests', 'RecordsUITests', 'NotificationUITests'];
const FULL = ['HanjuTests', 'HanjuUITests'];
const CI = new Set(['.github/workflows/ios.yml', '.github/scripts/ios-test-plan.cjs', '.github/scripts/ios-test-plan.test.cjs']);
const UNIT_FILES = new Set(['ExecutionMigrationTests', 'ExecutionTests', 'NotificationTests', 'RecordsMigrationTests', 'RecordsTests', 'RoutineLibraryTests', 'RoutinePersistenceTests', 'SchemaMigrationTests', 'WeekPlanTests', 'WeeklyMemoCoordinatorTests'].map(name => `HanjuTests/${name}.swift`));
const FLOW = ['ExecutionUITests', 'WeekPlanUITests', 'RecordsUITests'];
const AREAS = {
  'Hanju/Features/Settings/': ['NotificationUITests', 'RecordsUITests'],
  'Hanju/Features/Today/': FLOW, 'Hanju/Features/Week/': FLOW, 'Hanju/Features/Execution/': FLOW,
  'Hanju/Features/Records/': FLOW,
  'Hanju/Features/Library/': ['RoutineLibraryUITests', ...FLOW]
};
const full = reason => ({ mode: 'full', reason, targets: [...FULL] });
const nonNative = name => /^(docs\/|design\/(?!tokens\.json$)|graphify-out\/|\.agents\/|\.githooks\/|\.github\/(ISSUE_TEMPLATE\/|copilot-instructions\.md$|pull_request_template\.md$))/.test(name)
  || /^(AGENTS|CONTRIBUTING|DEVELOPMENT_HANDOFF|README)\.md$/.test(name)
  || ['.gitignore', '.github/workflows/pr-policy.yml', '.github/scripts/pr-policy.cjs', '.github/scripts/pr-policy.test.cjs', '.github/scripts/test_commit_msg.py'].includes(name);
const validPath = name => typeof name === 'string' && name.length > 0 && !name.startsWith('/') && !/[\x00-\x1f\\]/.test(name) && !name.split('/').some(part => ['..', '.', ''].includes(part));

function parseDiff(text) {
  if (typeof text !== 'string' || (text && !text.endsWith('\0'))) throw new Error('Truncated NUL-delimited diff.');
  const fields = text ? text.slice(0, -1).split('\0') : [];
  if (fields.length % 2) throw new Error('Incomplete diff status/path pair.');
  const files = [];
  for (let i = 0; i < fields.length; i += 2) {
    if (!/^[AMDT]$/.test(fields[i]) || !validPath(fields[i + 1])) throw new Error('Unknown diff status or invalid path.');
    files.push({ status: fields[i], path: fields[i + 1] });
  }
  return files;
}

function selectPlan(eventName, files) {
  if (!['pull_request', 'push'].includes(eventName)) return full('Manual or unrecognized event: full scheme regression.');
  if (!Array.isArray(files) || !files.length || files.some(f => !f || !/^[AMDT]$/.test(f.status) || !validPath(f.path))) return full('Changed-file data unavailable, empty, or invalid.');
  const selected = new Set();
  let native = false;
  for (const { path, status } of files) {
    if (nonNative(path)) continue;
    native = true;
    if (eventName === 'push') return full('Main native/CI/unknown change: full scheme regression.');
    if (status === 'D' || status === 'T') return full('Native deletion, rename, or type change.');
    if (CI.has(path) || UNIT_FILES.has(path)) continue;
    const ui = /^HanjuUITests\/([^/]+)\.swift$/.exec(path)?.[1];
    if (UI.includes(ui)) { selected.add(ui); continue; }
    if (path === 'Hanju/Features/Records/RecordsView.swift') { selected.add('RecordsUITests'); continue; }
    const area = Object.keys(AREAS).find(prefix => path.startsWith(prefix) && path.endsWith('.swift'));
    if (!area) return full('Shared, dependency, or unclassified native input.');
    for (const target of AREAS[area]) selected.add(target);
  }
  if (!native) return { mode: 'none', reason: 'Documentation/Graphify/tooling-only change: native validation not required.', targets: [] };
  return { mode: 'related', reason: selected.size ? 'All unit tests plus affected UI suites.' : 'All unit tests and app build; no affected UI suite.',
    targets: ['HanjuTests', ...UI.filter(name => selected.has(name)).map(name => `HanjuUITests/${name}`)] };
}

function changedFiles(eventName, base, head, spawn = spawnSync) {
  if (![base, head].every(sha => typeof sha === 'string' && /^[a-f0-9]{40}$/i.test(sha) && !/^0+$/.test(sha))) throw new Error('Missing/invalid comparison SHA.');
  const range = `${base}${eventName === 'pull_request' ? '...' : '..'}${head}`;
  const result = spawn('git', ['diff', '--no-renames', '--name-status', '-z', range, '--'], { encoding: 'utf8', maxBuffer: 32 * 1024 * 1024 });
  if (result.error || result.status !== 0) throw new Error('Git diff unavailable; full regression required.');
  return parseDiff(result.stdout);
}

function inventory() {
  const suites = [];
  for (const target of FULL) {
    for (const file of fs.readdirSync(target, { recursive: true }).filter(name => name.endsWith('.swift'))) {
      const source = fs.readFileSync(`${target}/${file}`, 'utf8');
      for (const match of source.matchAll(/\bclass\s+(\w+)\s*:\s*XCTestCase\b/g)) suites.push(`${target}/${match[1]}`);
    }
    if (!suites.some(name => name.startsWith(`${target}/`))) throw new Error(`No XCTest suites found in ${target}.`);
  }
  return [...new Set(suites)].sort();
}

function withInventory(plan, suites) {
  if (plan.mode === 'none') return { ...plan, expectedSuites: [] };
  const actualUI = suites.filter(s => s.startsWith('HanjuUITests/'));
  if (UI.some(name => !actualUI.includes(`HanjuUITests/${name}`)) || actualUI.some(s => !UI.includes(s.split('/')[1]))) plan = full('UI suite inventory changed; update the dependency map before narrowing.');
  return { ...plan, expectedSuites: suites.filter(s => plan.mode === 'full' || s.startsWith('HanjuTests/') || plan.targets.includes(s)) };
}

function buildArguments(plan, simulator) {
  if (!plan || !['full', 'related'].includes(plan.mode) || !Array.isArray(plan.targets) || !simulator) throw new Error('Native plan and simulator are required.');
  const allowed = new Set(['HanjuTests', ...UI.map(name => `HanjuUITests/${name}`)]);
  if (plan.mode === 'full' ? JSON.stringify(plan.targets) !== JSON.stringify(FULL)
      : plan.targets[0] !== 'HanjuTests' || new Set(plan.targets).size !== plan.targets.length || plan.targets.some(t => !allowed.has(t))) throw new Error('Invalid or empty test selection.');
  return ['test', '-project', 'Hanju.xcodeproj', '-scheme', 'Hanju', '-destination', `platform=iOS Simulator,id=${simulator}`,
    '-derivedDataPath', 'DerivedData', '-resultBundlePath', 'build/TestResults.xcresult', 'CODE_SIGNING_ALLOWED=NO',
    ...(plan.mode === 'full' ? [] : plan.targets.map(target => `-only-testing:${target}`))];
}

function verifyResults(plan, report) {
  if (!Array.isArray(report?.testNodes) || !Array.isArray(plan.expectedSuites) || !plan.expectedSuites.length) throw new Error('Missing xcresult test tree or expected suite inventory.');
  const executed = new Set();
  function visit(node, target, suite) {
    if (['Unit test bundle', 'UI test bundle'].includes(node.nodeType)) target = node.name;
    if (node.nodeType === 'Test Suite') suite = node.name;
    if (node.nodeType === 'Test Case' && ['Passed', 'Failed', 'Expected Failure'].includes(node.result)) executed.add(`${target}/${suite}`);
    for (const child of node.children || []) visit(child, target, suite);
  }
  for (const node of report.testNodes) visit(node);
  const missing = plan.expectedSuites.filter(suite => !executed.has(suite));
  if (missing.length) throw new Error(`Selected suites absent or entirely unexecuted: ${missing.join(', ')}`);
  return [...executed].sort();
}

function execute(plan, simulator, spawn = spawnSync) {
  const result = spawn('xcodebuild', buildArguments(plan, simulator), { stdio: 'inherit' });
  if (result.error) throw result.error;
  return Number.isInteger(result.status) ? result.status : 1;
}

async function run({ context, core }) {
  const event = context.eventName;
  let files;
  try {
    if (['pull_request', 'push'].includes(event)) files = changedFiles(event,
      event === 'pull_request' ? context.payload.pull_request.base.sha : context.payload.before,
      event === 'pull_request' ? context.payload.pull_request.head.sha : context.sha);
  } catch (error) { core.warning(error.message); }
  const checkoutSha = process.env.CHECKOUT_SHA;
  if (!/^[a-f0-9]{40}$/i.test(checkoutSha || '')) throw new Error('Checkout SHA was not recorded.');
  const plan = { ...withInventory(selectPlan(event, files), inventory()), event, checkoutSha,
    prHeadSha: context.payload.pull_request?.head.sha || null,
    comparisonBaseSha: event === 'pull_request' ? context.payload.pull_request.base.sha : context.payload.before || null,
    runUrl: `${context.serverUrl}/${context.repo.owner}/${context.repo.repo}/actions/runs/${context.runId}` };
  fs.mkdirSync('build', { recursive: true });
  fs.writeFileSync('build/ios-test-plan.json', JSON.stringify(plan, null, 2));
  core.setOutput('native', plan.mode !== 'none');
  core.info(JSON.stringify(plan));
  await core.summary.addHeading('iOS test selection').addTable([
    [{ data: 'Field', header: true }, { data: 'Value', header: true }],
    ['Event', event], ['Mode', plan.mode], ['Reason', plan.reason],
    ['PR head SHA', context.payload.pull_request?.head.sha || 'Not a PR'],
    ['Checkout SHA', plan.checkoutSha], ['Targets', plan.targets.join(', ') || 'Native not required'],
    ['Expected suites', plan.expectedSuites.join(', ') || 'None'],
    ['Run', plan.runUrl]
  ]).write();
  return plan;
}

module.exports = { UI, AREAS, parseDiff, selectPlan, changedFiles, inventory, withInventory, buildArguments, verifyResults, execute, run };
if (require.main === module) {
  const [command, file] = process.argv.slice(2);
  if (process.argv.length !== 4 || !['execute', 'verify'].includes(command)) throw new Error('Usage: ios-test-plan.cjs execute|verify <plan.json>');
  const plan = JSON.parse(fs.readFileSync(file, 'utf8'));
  if (command === 'execute') process.exitCode = execute(plan, process.env.SIMULATOR_ID);
  else {
    const result = spawnSync('xcrun', ['xcresulttool', 'get', 'test-results', 'tests', '--path', 'build/TestResults.xcresult'], { encoding: 'utf8', maxBuffer: 32 * 1024 * 1024 });
    if (result.error || result.status !== 0) throw new Error('Unable to inspect xcresult test tree.');
    fs.writeFileSync('build/executed-tests.json', result.stdout);
    console.log('Executed suites:', verifyResults(plan, JSON.parse(result.stdout)).join(', '));
  }
}
