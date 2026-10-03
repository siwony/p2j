const types = '(?:feat|fix|refactor|test|docs|chore|build|ci|perf|revert)';
const branchPattern = new RegExp(`^codex/${types}/([1-9][0-9]*)-[a-z0-9]+(?:-[a-z0-9]+)*$`);
const titlePattern = new RegExp(`^${types}\\([a-z][a-z0-9-]*\\): (\\S(?:.*\\S)?) \\(#([1-9][0-9]*)\\)$`);

function validate(pr, commits, issue) {
  const match = branchPattern.exec(pr.head.ref);
  if (!match) throw new Error('브랜치는 codex/<type>/<issue>-<description> 형식이어야 합니다.');
  const number = Number(match[1]);
  for (const title of [pr.title, ...commits.map(c => c.commit.message.split('\n')[0])]) {
    const subject = titlePattern.exec(title);
    if (!subject || subject[2] !== match[1] || [...title].length > 100) {
      throw new Error(`PR 제목과 모든 커밋은 같은 이슈 #${number}를 포함하는 Conventional Commit이어야 합니다: ${title}`);
    }
  }
  if (!issue || issue.number !== number || issue.pull_request) {
    throw new Error(`#${number}는 이 저장소의 실제 이슈여야 합니다.`);
  }
  if (!new RegExp(`\\b(?:Closes|Fixes|Resolves|Refs)\\s+#${number}\\b`, 'i').test(pr.body || '')) {
    throw new Error(`PR 본문에 Closes #${number} 또는 Refs #${number}를 작성하세요.`);
  }
  if (!commits.length || commits.length !== pr.commits || commits.length >= 250) {
    throw new Error('전체 새 커밋을 검증하지 못했습니다. PR은 250개 미만 커밋으로 나누세요.');
  }
  return number;
}

async function run({ github, context, core }) {
  const params = { ...context.repo, pull_number: context.payload.pull_request.number };
  const { data: pr } = await github.rest.pulls.get(params);
  if (pr.head.sha !== context.payload.pull_request.head.sha) {
    throw new Error('PR이 변경되었습니다. 최신 push의 검사를 확인하세요.');
  }
  const match = branchPattern.exec(pr.head.ref);
  if (!match) throw new Error('브랜치 형식이 올바르지 않습니다.');
  const { data: issue } = await github.rest.issues.get({ ...context.repo, issue_number: Number(match[1]) });
  const commits = await github.paginate(github.rest.pulls.listCommits, { ...params, per_page: 100 });
  const number = validate(pr, commits, issue);
  core.info(`실제 이슈 #${number}, PR 제목, ${commits.length}개 커밋 검증 완료`);
}

module.exports = { validate, run };
