const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { execFileSync } = require('node:child_process');
const { UI, parseDiff, selectPlan, changedFiles, inventory, withInventory, buildArguments, verifyResults, execute } = require('./ios-test-plan.cjs');
const change = (path, status = 'M') => ({ path, status });
const plan = (...files) => selectPlan('pull_request', files.map(f => typeof f === 'string' ? change(f) : f));
const flow = ['ExecutionUITests', 'WeekPlanUITests', 'RecordsUITests'];

for (const [file, expected] of [
  ['Hanju/Features/Settings/SettingsView.swift', ['NotificationUITests', 'RecordsUITests']],
  ['Hanju/Features/Today/TodayView.swift', flow],
  ['Hanju/Features/Week/PlanWriter.swift', flow],
  ['Hanju/Features/Execution/ExecutionWriter.swift', flow],
  ['Hanju/Features/Records/RecordsView.swift', ['RecordsUITests']],
  ['Hanju/Features/Records/WeeklyMemoCoordinator.swift', flow],
  ['Hanju/Features/Library/RoutineWriter.swift', ['RoutineLibraryUITests', ...flow]]
]) test(`dependency mapping: ${file}`, () => {
  assert.equal(plan(file).mode, 'related');
  assert.deepEqual(plan(file).targets.slice(1).sort(), expected.map(s => `HanjuUITests/${s}`).sort());
  assert.equal(plan(file).targets[0], 'HanjuTests');
});

test('mixed paths union suites once; full dominates related/docs', () => {
  const p = plan('docs/a.md', 'Hanju/Features/Records/RecordsView.swift', 'Hanju/Features/Settings/SettingsView.swift', 'Hanju/Features/Settings/SettingsView.swift');
  assert.deepEqual(p.targets, ['HanjuTests', 'HanjuUITests/RecordsUITests', 'HanjuUITests/NotificationUITests']);
  assert.equal(plan('docs/a.md', 'Hanju/Features/Records/RecordsView.swift', 'Hanju/Models/LocalDate.swift').mode, 'full');
});

for (const file of ['Hanju/App/AppTabs.swift', 'Hanju/Models/LocalDate.swift', 'Hanju/Persistence/PersistenceStore.swift', 'Hanju/Design/DesignTokens.swift', 'Hanju/Assets.xcassets/Contents.json', 'Hanju.xcodeproj/project.pbxproj', 'Hanju/Services/Notifications/NotificationPlan.swift', 'Hanju/Features/NewFeature/View.swift', 'HanjuUITests/NewUITests.swift', 'HanjuTests/NewTests.swift', 'Package.swift', 'Package.resolved', 'new-build-script.sh', 'design/tokens.json']) {
  test(`shared/unknown/dependency fallback: ${file}`, () => assert.equal(plan(file).mode, 'full'));
}

for (const name of UI) test(`existing UI test selects its class: ${name}`, () => {
  assert.deepEqual(plan(`HanjuUITests/${name}.swift`).targets, ['HanjuTests', `HanjuUITests/${name}`]);
});

test('known unit and the three CI inputs build app + all units without UI', () => {
  for (const file of ['HanjuTests/ExecutionTests.swift', '.github/workflows/ios.yml', '.github/scripts/ios-test-plan.cjs', '.github/scripts/ios-test-plan.test.cjs']) {
    assert.deepEqual(plan(file).targets, ['HanjuTests']);
  }
});

test('docs/Graphify-only skip is explicit; removed docs remain non-native', () => {
  const p = plan('docs/product-plan.md', 'design/04-screens.md', 'graphify-out/graph.json', change('docs/old.md', 'D'));
  assert.equal(p.mode, 'none'); assert.deepEqual(p.targets, []);
});

test('native deletion/rename/type change cannot narrow', () => {
  for (const status of ['D', 'T']) assert.equal(plan(change('Hanju/Features/Records/RecordsView.swift', status)).mode, 'full');
  const renamed = parseDiff('D\0Hanju/Features/Records/RecordsView.swift\0A\0docs/moved.swift\0');
  assert.equal(selectPlan('pull_request', renamed).mode, 'full');
  assert.equal(plan(change('HanjuUITests/RecordsUITests.swift', 'D')).mode, 'full');
});

test('NUL parser preserves spaces; rejects truncation/unknown status/path metadata', () => {
  assert.deepEqual(parseDiff('M\0docs/a file.md\0A\0Hanju/Features/Week/New.swift\0'), [change('docs/a file.md'), change('Hanju/Features/Week/New.swift', 'A')]);
  for (const text of ['M\0docs/a', 'M\0', 'R100\0old\0new\0', 'X\0docs/a\0', 'M\0../docs/a\0', 'M\0/absolute\0']) assert.throws(() => parseDiff(text));
  assert.equal(plan({ path: 'docs/a', status: 'unknown' }).mode, 'full');
  assert.equal(selectPlan('pull_request', null).mode, 'full');
  assert.equal(selectPlan('pull_request', []).mode, 'full');
});

test('large file lists have no API pagination cap and retain final native path', () => {
  const docs = Array.from({ length: 3500 }, (_, i) => change(`docs/${i}.md`));
  assert.equal(selectPlan('pull_request', docs).mode, 'none');
  assert.equal(selectPlan('pull_request', [...docs, change('Hanju/Models/LocalDate.swift')]).mode, 'full');
});

test('main native/CI/unknown full; main docs skip; manual always full', () => {
  for (const file of ['Hanju/Features/Records/RecordsView.swift', '.github/workflows/ios.yml', 'new-build-file']) assert.equal(selectPlan('push', [change(file)]).mode, 'full');
  assert.equal(selectPlan('push', [change('graphify-out/graph.json')]).mode, 'none');
  assert.equal(selectPlan('workflow_dispatch', [change('docs/a.md')]).mode, 'full');
});

test('invalid/missing SHAs and failed Git lookup are not a docs-only diff', () => {
  assert.throws(() => changedFiles('push', '0'.repeat(40), 'a'.repeat(40)));
  assert.throws(() => changedFiles('pull_request', '--output=evil', 'a'.repeat(40)));
  assert.throws(() => changedFiles('push', 'a'.repeat(40), 'b'.repeat(40), () => ({ status: 128 })));
  assert.throws(() => changedFiles('push', 'a'.repeat(40), 'b'.repeat(40), () => ({ error: new Error('maxBuffer') })));
});

test('real Git diff uses PR merge base, push range, and rename old/new via D+A', () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'hanju-ci-plan-'));
  const env = { ...process.env, GIT_CONFIG_GLOBAL: '/dev/null', GIT_AUTHOR_NAME: 'CI Fixture', GIT_AUTHOR_EMAIL: 'fixture@example.invalid', GIT_COMMITTER_NAME: 'CI Fixture', GIT_COMMITTER_EMAIL: 'fixture@example.invalid' };
  const git = (...args) => execFileSync('git', args, { cwd: dir, env, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
  const spawn = (command, args, options) => require('node:child_process').spawnSync(command, args, { ...options, cwd: dir, env });
  try {
    git('init', '-b', 'main'); fs.writeFileSync(path.join(dir, 'base'), 'base'); git('add', '.'); git('commit', '-m', 'fixture base');
    const base = git('rev-parse', 'HEAD'); git('checkout', '-b', 'feature');
    fs.mkdirSync(path.join(dir, 'Hanju/Features/Records'), { recursive: true });
    fs.writeFileSync(path.join(dir, 'Hanju/Features/Records/RecordsView.swift'), 'view'); git('add', '.'); git('commit', '-m', 'fixture view');
    const head = git('rev-parse', 'HEAD'); git('checkout', 'main');
    fs.writeFileSync(path.join(dir, 'unrelated-main-file'), 'main'); git('add', '.'); git('commit', '-m', 'fixture main advances');
    assert.deepEqual(changedFiles('pull_request', git('rev-parse', 'HEAD'), head, spawn), [change('Hanju/Features/Records/RecordsView.swift', 'A')]);
    assert.deepEqual(changedFiles('push', base, git('rev-parse', 'HEAD'), spawn), [change('unrelated-main-file', 'A')]);
    git('checkout', 'feature'); fs.renameSync(path.join(dir, 'Hanju/Features/Records/RecordsView.swift'), path.join(dir, 'renamed.swift'));
    git('add', '-A'); git('commit', '-m', 'fixture rename');
    const files = changedFiles('push', head, git('rev-parse', 'HEAD'), spawn);
    assert.deepEqual(files.map(f => f.status).sort(), ['A', 'D']);
    assert.equal(selectPlan('pull_request', files).mode, 'full');
  } finally { fs.rmSync(dir, { recursive: true, force: true }); }
});

test('real XCTest inventory backs every fixed UI class; inventory drift falls back', () => {
  const suites = inventory();
  for (const name of UI) assert.ok(suites.includes(`HanjuUITests/${name}`));
  const selected = withInventory(plan('Hanju/Features/Records/RecordsView.swift'), suites);
  assert.ok(selected.expectedSuites.includes('HanjuTests/ExecutionTests'));
  assert.ok(selected.expectedSuites.includes('HanjuUITests/RecordsUITests'));
  assert.ok(!selected.expectedSuites.includes('HanjuUITests/ExecutionUITests'));
  assert.equal(withInventory(selected, [...suites, 'HanjuUITests/NewUITests']).mode, 'full');
  assert.equal(withInventory(selected, suites.filter(s => !s.endsWith('/RecordsUITests'))).mode, 'full');
});

test('fixed argv rejects empty/arbitrary targets and preserves xcode failure status', () => {
  const p = plan('Hanju/Features/Records/RecordsView.swift');
  assert.ok(buildArguments(p, 'sim').includes('-only-testing:HanjuTests'));
  assert.ok(!buildArguments(selectPlan('workflow_dispatch'), 'sim').some(a => a.startsWith('-only-testing:')));
  for (const targets of [[], ['HanjuUITests/RecordsUITests'], ['HanjuTests', '; touch /tmp/evil'], ['HanjuTests', 'HanjuTests']]) assert.throws(() => buildArguments({ mode: 'related', targets }, 'sim'));
  assert.throws(() => buildArguments({ mode: 'none', targets: [] }, 'sim'));
  assert.equal(execute(p, 'sim', (command, args) => { assert.equal(command, 'xcodebuild'); assert.ok(args.includes('-only-testing:HanjuUITests/RecordsUITests')); return { status: 65 }; }), 65);
  assert.equal(execute(p, 'sim', () => ({ status: null, signal: 'SIGTERM' })), 1);
});

test('xcresult requires actual executed cases for every expected suite', () => {
  const p = { expectedSuites: ['HanjuTests/ExecutionTests', 'HanjuUITests/RecordsUITests'] };
  const bundle = (name, type, suite, result) => ({ name, nodeType: type, children: [{ name: suite, nodeType: 'Test Suite', children: [{ name: 'testExample()', nodeType: 'Test Case', result }] }] });
  const report = { testNodes: [bundle('HanjuTests', 'Unit test bundle', 'ExecutionTests', 'Passed'), bundle('HanjuUITests', 'UI test bundle', 'RecordsUITests', 'Passed')] };
  assert.deepEqual(verifyResults(p, report), p.expectedSuites);
  assert.throws(() => verifyResults(p, { testNodes: [report.testNodes[0]] }), /RecordsUITests/);
  report.testNodes[1].children[0].children[0].result = 'Skipped';
  assert.throws(() => verifyResults(p, report), /unexecuted/);
  assert.throws(() => verifyResults(p, {}));
  assert.throws(() => verifyResults({ expectedSuites: [] }, report));
});

test('workflow wrapper records SHA/mode and falls back on missing comparison data', async () => {
  const { run } = require('./ios-test-plan.cjs');
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'hanju-ci-wrapper-'));
  const previous = process.cwd(), oldSha = process.env.CHECKOUT_SHA;
  const outputs = {}, warnings = [];
  const summary = { addHeading() { return this; }, addTable() { return this; }, async write() {} };
  try {
    for (const [target, names] of [['HanjuTests', ['UnitTests']], ['HanjuUITests', UI]]) {
      fs.mkdirSync(path.join(dir, target));
      for (const name of names) fs.writeFileSync(path.join(dir, target, `${name}.swift`), `final class ${name}: XCTestCase {}`);
    }
    process.chdir(dir); process.env.CHECKOUT_SHA = 'a'.repeat(40);
    const result = await run({ context: { eventName: 'pull_request', payload: { pull_request: { base: { sha: null }, head: { sha: 'b'.repeat(40) } } }, repo: { owner: 'fixture', repo: 'repo' }, serverUrl: 'https://github.com', runId: 123 },
      core: { setOutput(k, v) { outputs[k] = v; }, warning(m) { warnings.push(m); }, info() {}, summary } });
    assert.equal(result.mode, 'full'); assert.equal(outputs.native, true); assert.equal(warnings.length, 1);
    const stored = JSON.parse(fs.readFileSync('build/ios-test-plan.json'));
    assert.equal(stored.checkoutSha, 'a'.repeat(40)); assert.equal(stored.prHeadSha, 'b'.repeat(40));
    assert.equal(stored.runUrl, 'https://github.com/fixture/repo/actions/runs/123');
    assert.ok(stored.expectedSuites.includes('HanjuTests/UnitTests'));
  } finally {
    process.chdir(previous);
    if (oldSha === undefined) delete process.env.CHECKOUT_SHA; else process.env.CHECKOUT_SHA = oldSha;
    fs.rmSync(dir, { recursive: true, force: true });
  }
});
