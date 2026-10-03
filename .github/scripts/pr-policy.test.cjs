const { test } = require('node:test');
const assert = require('node:assert/strict');
const { validate } = require('./pr-policy.cjs');

const fixture = () => ({
  pr: { head: { ref: 'codex/ci/3-ai-review' }, title: 'ci(tooling): PR 검사 (#3)', body: 'Closes #3', commits: 1 },
  commits: [{ commit: { message: 'ci(tooling): PR 검사 (#3)\n\n검증 근거' } }],
  issue: { number: 3, state: 'closed' },
});
test('closed source issue can be referenced for a graph follow-up', () => {
  const f = fixture(); f.pr.body = 'Refs #3'; assert.equal(validate(f.pr, f.commits, f.issue), 3);
});
for (const [name, mutate] of [
  ['direct main branch', f => { f.pr.head.ref = 'main'; }],
  ['title issue mismatch', f => { f.pr.title = 'ci(tooling): PR 검사 (#4)'; }],
  ['commit issue mismatch', f => { f.commits[0].commit.message = 'ci(tooling): PR 검사 (#4)'; }],
  ['missing issue link', f => { f.pr.body = 'Refs #30'; }],
  ['PR number used as issue', f => { f.issue.pull_request = {}; }],
  ['incomplete commit pagination', f => { f.pr.commits = 2; }],
  ['long title', f => { f.pr.title = `ci(tooling): ${'가'.repeat(100)} (#3)`; }],
  ['WIP commit', f => { f.commits[0].commit.message = 'WIP'; }],
]) {
  test(`reject ${name}`, () => { const f = fixture(); mutate(f); assert.throws(() => validate(f.pr, f.commits, f.issue)); });
}
