> 분석 기준: main `ba92e7e95dd8f3c3435b7cc4fcbd7b307797cffe` · 이슈 #16 · PR #17 병합 후 고정 snapshot.
> 현재 Codex 세션의 의미 추출과 한국어 라벨을 사용했다. 모델·토큰·비용은 알 수 없음.
> 네이티브 기반의 구현과 후속 기능 계약을 구분한다. 그래프 생성은 전체 MVP 또는 인수 완료를 뜻하지 않는다.

# Graph Report - ptoj  (2026-10-04)

## Corpus Check
- 51 source files; only 4 changed/new files re-extracted or semantically refreshed.

## Summary
- 268 nodes · 519 edges · 12 communities (10 shown, 2 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 46 edges (avg confidence: 0.96)
- Token cost: 알 수 없음 input · 알 수 없음 output

## Graph Freshness
- Built from commit: `ba92e7e9`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- main 병합 뒤에만 현재 AI 세션으로 갱신한다. source_commit 이후 변경은 원문 diff로 확인한다.

## Community Hubs (Navigation)
- 루틴 저장과 동작 검증
- 기술 채택과 디자인 기준
- 루틴 화면과 초안 보호
- 제품 정책과 기능 인수
- 프로젝트와 빌드 테스트 구성
- 화면 명세와 후속 실행
- 커밋 규칙과 리베이스 검증
- 독립 리뷰와 PR 정책
- 실제 깃과 훅 회귀테스트
- 루틴 영속 모델과 스키마
- 네이티브 시맨틱 색상
- 후속 데이터와 시스템 연동

## God Nodes (most connected - your core abstractions)
1. `한 주 iPhone MVP` - 23 edges
2. `CommitMessageHookTests` - 17 edges
3. `Hanju 네이티브 프로젝트` - 14 edges
4. `RoutineTemplate` - 12 edges
5. `RoutineDraft` - 10 edges
6. `RoutineEditorSheet` - 10 edges
7. `DesignTokens` - 9 edges
8. `LibraryView` - 8 edges
9. `RoutinePersistenceTests` - 7 edges
10. `Tab` - 7 edges

## Surprising Connections (you probably didn't know these)
- `iOS 17 Swift 6 기반 채택` --implements--> `HanjuApp`  [EXTRACTED]
  docs/adr/0001-native-ios-foundation.md → Hanju/App/HanjuApp.swift
- `RoutineTemplate` --implements--> `RoutineTemplate`  [EXTRACTED]
  design/04-screens.md → Hanju/Models/HanjuSchemaV1.swift
- `V1 저장소와 오류 복구` --implements--> `PersistenceStore`  [EXTRACTED]
  docs/adr/0001-native-ios-foundation.md → Hanju/Persistence/PersistenceStore.swift
- `AC-02 다음 주 계획` --conceptually_related_to--> `Week 이번 주 화면`  [INFERRED]
  docs/product-plan.md → design/04-screens.md
- `PR 정책과 main 보호` --implements--> `validate()`  [EXTRACTED]
  docs/development/review-workflow.md → .github/scripts/pr-policy.cjs

## Import Cycles

아래는 참조 사용 위치를 정의 파일로 취급한 도구의 파일 투영 결과가 포함될 수 있다. 외부 모듈·제네릭 타입의 source_file은 사용 근거이며 실제 코드 순환을 의미하지 않는다.
- 1-file cycle: `.github/scripts/pr-policy.test.cjs -> .github/scripts/pr-policy.test.cjs`
- 1-file cycle: `.githooks/commit-msg -> .githooks/commit-msg`

## Communities (12 total, 2 thin omitted)

### Community 0 - "루틴 저장과 동작 검증"
Cohesion: 0.07
Nodes (30): App, 초안 보존과 저장 결과, AC-12 탐색과 입력 취소, HanjuApp, .body, RoutineDraft, .hasChanges, Bool (+22 more)

### Community 1 - "기술 채택과 디자인 기준"
Cohesion: 0.12
Nodes (21): 에이전트 파일 소유권, 독립 리뷰와 통합, 정돈한 생활의 페이지, 차분한 숲빛 강조색, 처음부터 접근성 지원, 의미 있는 대비 기준, 한국어 시스템 서체, 디자인 프리뷰의 검증 경계 (+13 more)

### Community 2 - "루틴 화면과 초안 보호"
Cohesion: 0.08
Nodes (27): Actions, 변경 초안 swipe 확인 미완료, 이름 등록 기반의 구현 경계, 순차 기능 이슈와 의존성, 기반 네이티브 검증 기록, AppTabs, .body, String (+19 more)

### Community 3 - "제품 정책과 기능 인수"
Cohesion: 0.13
Nodes (26): 중요 기술 결정 ADR, WeekMemo 입력, Records 기록 화면, Settings 설정 화면, AC-02 다음 주 계획, AC-03 주중 조정과 쉬기, AC-05 직접 완료와 수정, AC-06 알림 (+18 more)

### Community 4 - "프로젝트와 빌드 테스트 구성"
Cohesion: 0.17
Nodes (10): 공유 scheme과 로컬 테스트, Foundation, iOS 빌드와 테스트 CI, Hanju, Hanju 네이티브 프로젝트, Hanju 공유 실행 테스트 scheme, Observation, SwiftData (+2 more)

### Community 5 - "화면 명세와 후속 실행"
Cohesion: 0.14
Nodes (20): ActiveRoutinePanel, CalendarSyncState, 실제 공유 UI 추출, WeekDaySelector, CalendarSheet 반영 상태, Routine Editor 편집 시트, Execution, Routine Library 루틴함 (+12 more)

### Community 6 - "커밋 규칙과 리베이스 검증"
Cohesion: 0.13
Nodes (15): 이슈 연결 Git 규칙, 이슈부터 시작, Validate project commit conventions without third-party dependencies., rebase 원래 브랜치 검증, Exercise commit-msg with real Git commits, rebases, and linked worktrees., 실제 Git과 worktree 회귀 검증, os, pathlib (+7 more)

### Community 7 - "독립 리뷰와 PR 정책"
Cohesion: 0.15
Nodes (13): 최신 SHA 독립 AI 리뷰, PR 정책과 main 보호, Copilot 코드 리뷰 기준, branchPattern, run(), assert, { test }, { validate } (+5 more)

### Community 9 - "루틴 영속 모델과 스키마"
Cohesion: 0.19
Nodes (12): HanjuSchemaV1, .models, .versionIdentifier, RoutineTemplate, Bool, Date, String, UUID (+4 more)

### Community 11 - "후속 데이터와 시스템 연동"
Cohesion: 0.70
Nodes (4): 캘린더 중단 후 복구 계약, LocalDate와 DST 해석, 후속 모델과 명령 계약, 알림 예약과 종료 중 한계

## Knowledge Gaps
- **53 isolated node(s):** `Hanju`, `URL`, `UUID`, `Date`, `XCUIElement` (+48 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 70 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `이슈 연결 Git 규칙` connect `커밋 규칙과 리베이스 검증` to `기술 채택과 디자인 기준`, `독립 리뷰와 PR 정책`?**
  _High betweenness centrality (0.176) - this node is a cross-community bridge._
- **Why does `RoutineTemplate` connect `루틴 영속 모델과 스키마` to `루틴 저장과 동작 검증`, `루틴 화면과 초안 보호`, `프로젝트와 빌드 테스트 구성`, `화면 명세와 후속 실행`?**
  _High betweenness centrality (0.140) - this node is a cross-community bridge._
- **Why does `PR 정책과 main 보호` connect `독립 리뷰와 PR 정책` to `기술 채택과 디자인 기준`, `커밋 규칙과 리베이스 검증`?**
  _High betweenness centrality (0.122) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `RoutineTemplate` (e.g. with `.create()` and `.writeRoutine()`) actually correct?**
  _`RoutineTemplate` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `RoutineDraft` (e.g. with `RoutineEditorSheet` and `.testBlankNameCannotCreateRoutine()`) actually correct?**
  _`RoutineDraft` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Hanju`, `URL`, `UUID` to the rest of the system?**
  _53 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `루틴 저장과 동작 검증` be split into smaller, more focused modules?**
  _Cohesion score 0.06765327695560254 - nodes in this community are weakly interconnected._

## 추출 검증과 한계

- 이전 source 02a9202e5dea15b9f217f93df4c6091ca1f169d4의 원시 추출을 재사용했다. 파일 SHA256으로 47개 동일 입력을 확인했고 변경·추가 4개만 AST/의미 재검증했다. 전체 corpus를 다시 추출하지 않았다.
- 대표 relation/confidence/confidence_score와 보고서 비율은 graphify가 선택한 대표 연결 기준이다. 병합 연결의 evidence 배열은 원시 관계별 source/target/relation/confidence/confidence_score/source_file/source_location을 모두 보존한다.
- graphify 원시 추출(AST+의미)의 536개 관계 중 17개는 같은 endpoint 쌍의 추가 관계·라인이다. 최종 단순 그래프는 519개 연결이며 중복 쌍 14개의 모든 원문 관계를 edge.evidence에 보존했다.
- AST 오연결 1건을 원문으로 수정했다: RoutineWriter.create의 주입 save closure 호출은 RoutineEditorSheet.save 호출이 아니므로 제거했다. pr-policy.cjs의 module.exports 두 항목도 호출이 아닌 exports 관계로 보정했다.
- AST의 외부/제네릭 타입 노드는 사용 근거 위치를 source_file/source_location에 기록했다. 정의 파일·실제 순환 의존으로 해석하지 않는다.
- Swift/CJS/hook은 AST 지원을 확인했다. Xcode project/scheme, CI YAML, 디자인·asset JSON은 현재 Codex가 의미 추출했으며 AST 호출 그래프 대상이 아니다.
- 이름 등록·저장 기반 단계이며 계획·실행·기록·알림·캘린더와 전체 AC는 후속이다. snapshot 검증 문서의 CI 진행 표현을 성공 결과로 바꾸지 않았다. 원격 PR14 최신 CI 결과는 이 그래프의 입력 원문 밖이다.
- 입력 51개 전체 파일 출처를 포함하지만 주요 개념 중심 인덱스이며 모든 문장·SwiftUI modifier·Xcode 설정의 완전한 모델은 아니다.
- design/tokens.json 민감 파일명 오탐은 디자인 값 확인 뒤 입력에 명시 포함했다. archive/skills/graphify 출력/의존 메타데이터/빌드 산출물은 제외했다.
- 모델 ID·입력/출력 토큰·비용 집계는 제공되지 않아 null로 기록한다. 외부 LLM API를 사용하지 않았다.

- 51/51 입력에 출처 노드 존재, 상대 경로와 실제 줄번호 범위 확인. dangling/missing endpoint·self-loop 0.
- 연결 성분 1, degree 0 노드 0.

## 분석 입력 목록

- `.githooks/commit-msg`
- `.github/ISSUE_TEMPLATE/bug.md`
- `.github/ISSUE_TEMPLATE/task.md`
- `.github/copilot-instructions.md`
- `.github/pull_request_template.md`
- `.github/scripts/pr-policy.cjs`
- `.github/scripts/pr-policy.test.cjs`
- `.github/scripts/test_commit_msg.py`
- `.github/workflows/ios.yml`
- `.github/workflows/pr-policy.yml`
- `AGENTS.md`
- `CONTRIBUTING.md`
- `DEVELOPMENT_HANDOFF.md`
- `Hanju.xcodeproj/project.pbxproj`
- `Hanju.xcodeproj/xcshareddata/xcschemes/Hanju.xcscheme`
- `Hanju/App/AppTabs.swift`
- `Hanju/App/HanjuApp.swift`
- `Hanju/Assets.xcassets/AccentColor.colorset/Contents.json`
- `Hanju/Assets.xcassets/Background.colorset/Contents.json`
- `Hanju/Assets.xcassets/Contents.json`
- `Hanju/Assets.xcassets/Surface.colorset/Contents.json`
- `Hanju/Assets.xcassets/TextPrimary.colorset/Contents.json`
- `Hanju/Assets.xcassets/TextSecondary.colorset/Contents.json`
- `Hanju/Design/DesignTokens.swift`
- `Hanju/Features/Library/LibraryView.swift`
- `Hanju/Features/Library/RoutineDraft.swift`
- `Hanju/Features/Library/RoutineEditorSheet.swift`
- `Hanju/Features/Library/RoutineWriter.swift`
- `Hanju/Models/HanjuSchemaV1.swift`
- `Hanju/Models/RoutineTemplate.swift`
- `Hanju/Persistence/PersistenceStore.swift`
- `HanjuTests/RoutinePersistenceTests.swift`
- `HanjuUITests/RoutineLibraryUITests.swift`
- `README.md`
- `design/01-direction.md`
- `design/02-foundations.md`
- `design/03-components.md`
- `design/04-screens.md`
- `design/05-swiftui-handoff.md`
- `design/contrast-report.json`
- `design/preview/index.html`
- `design/reference/user-design-brief.txt`
- `design/tokens.json`
- `docs/adr/0001-native-ios-foundation.md`
- `docs/development/data-contracts.md`
- `docs/development/graphify.md`
- `docs/development/implementation-plan.md`
- `docs/development/local-development.md`
- `docs/development/review-workflow.md`
- `docs/product-plan.md`
- `docs/verification/2026-10-04-foundation.md`
