> 분석 기준: main `50abf15d57ed39dc08bc841ac12e4d13f68cb276` · 이슈 #18, #7 · PR #20, #21 병합 후 고정 snapshot.
> 현재 Codex 세션의 의미 추출과 한국어 라벨을 사용했다. 모델·토큰·비용은 알 수 없음.
> 기획 1.3 정책 채택과 앱 구현을 구분한다. 그래프 생성은 전체 MVP 또는 인수 완료를 뜻하지 않는다.

# Graph Report - ptoj  (2026-10-04)

## Corpus Check
- 58 source files; 15 changed/new inputs refreshed since e5945a8; 43 unchanged inputs hash-verified.

## Summary
- 433 nodes · 871 edges · 19 communities (all shown)
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 55 edges (avg confidence: 0.92)
- Token cost: 알 수 없음 input · 알 수 없음 output

## Graph Freshness
- Built from commit: `50abf15d`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- main 병합 뒤에만 현재 AI 세션으로 갱신한다. source_commit 이후 변경은 원문 diff로 확인한다.

## Community Hubs (Navigation)
- 루틴 목록과 편집 탐색
- 선택 입력과 저장 회귀검증
- 프로젝트 구성과 구현 경계
- 네이티브 시트 닫기 연결
- 앱 저장소와 V1 스키마
- 편집 초안과 복구 동작
- 개발 인계와 독립 리뷰
- 제품 원칙과 수행 기록
- 이슈 커밋과 리베이스 규칙
- 계획 화면과 상태 명세
- 루틴 편집 UI 회귀검증
- 실제 깃과 훅 회귀검증
- 기획 개정과 복귀 흐름
- PR 정책과 원격 검사
- 접근성 기준과 프리뷰 경계
- 날짜 계약과 캘린더 조정
- 실행 탐색과 실패 복구
- 네이티브 시맨틱 색상
- 디자인 방향과 원문 기준

## God Nodes (most connected - your core abstractions)
1. `한 주 iPhone MVP` - 28 edges
2. `RoutineEditorSheet` - 25 edges
3. `Hanju 네이티브 프로젝트` - 20 edges
4. `RoutineDraft` - 20 edges
5. `RoutineListView` - 19 edges
6. `RoutineSnapshot` - 19 edges
7. `CommitMessageHookTests` - 17 edges
8. `Coordinator` - 15 edges
9. `RoutineLibraryUITests` - 15 edges
10. `기획 1.3 변경 인계` - 11 edges

## Surprising Connections (you probably didn't know these)
- `PR 정책과 main 보호` --implements--> `validate()`  [EXTRACTED]
  docs/development/review-workflow.md → .github/scripts/pr-policy.cjs
- `iOS 17 Swift 6 기반 채택` --implements--> `HanjuApp`  [EXTRACTED]
  docs/adr/0001-native-ios-foundation.md → Hanju/App/HanjuApp.swift
- `RoutineTemplate` --implements--> `RoutineTemplate`  [EXTRACTED]
  design/04-screens.md → Hanju/Models/HanjuSchemaV1.swift
- `V1 저장소와 오류 복구` --implements--> `PersistenceStore`  [EXTRACTED]
  docs/adr/0001-native-ios-foundation.md → Hanju/Persistence/PersistenceStore.swift
- `루틴 편집과 후속 구현 경계` --implements--> `LibraryView`  [EXTRACTED]
  docs/development/implementation-plan.md → Hanju/Features/Library/LibraryView.swift

## Import Cycles

아래는 참조 사용 위치를 정의 파일로 취급한 도구의 파일 투영 결과가 포함될 수 있다. 외부 모듈·제네릭 타입의 source_file은 사용 근거이며 실제 코드 순환을 의미하지 않는다.
- 1-file cycle: `.github/scripts/pr-policy.test.cjs -> .github/scripts/pr-policy.test.cjs`
- 1-file cycle: `.githooks/commit-msg -> .githooks/commit-msg`

## Communities (19 total, all shown)

모든 수치는 graph.json의 전체 노드를 기준으로 한다. 파일·심볼·개념 노드를 제외하지 않으며, 각 목록은 이름 8개만 미리 표시한다.

| ID | 공통 라벨 | JSON·보고서 전체 노드 수 |
| --- | --- | ---: |
| 0 | 루틴 목록과 편집 탐색 | 53 |
| 1 | 선택 입력과 저장 회귀검증 | 47 |
| 2 | 프로젝트 구성과 구현 경계 | 40 |
| 3 | 네이티브 시트 닫기 연결 | 39 |
| 4 | 앱 저장소와 V1 스키마 | 34 |
| 5 | 편집 초안과 복구 동작 | 27 |
| 6 | 개발 인계와 독립 리뷰 | 24 |
| 7 | 제품 원칙과 수행 기록 | 22 |
| 8 | 이슈 커밋과 리베이스 규칙 | 20 |
| 9 | 계획 화면과 상태 명세 | 19 |
| 10 | 루틴 편집 UI 회귀검증 | 18 |
| 11 | 실제 깃과 훅 회귀검증 | 17 |
| 12 | 기획 개정과 복귀 흐름 | 15 |
| 13 | PR 정책과 원격 검사 | 14 |
| 14 | 접근성 기준과 프리뷰 경계 | 11 |
| 15 | 날짜 계약과 캘린더 조정 | 11 |
| 16 | 실행 탐색과 실패 복구 | 9 |
| 17 | 네이티브 시맨틱 색상 | 8 |
| 18 | 디자인 방향과 원문 기준 | 5 |
| 합계 | 19개 커뮤니티 | 433 |

### Community 0 - "루틴 목록과 편집 탐색"
Cohesion: 0.055152394775036286
Nodes (53): Actions, Binding, Equatable, AppTabs, .body, .emptyScreen(), String, Tab (+45 more)

### Community 1 - "선택 입력과 저장 회귀검증"
Cohesion: 0.08695652173913043
Nodes (47): Error, Field, expectedMinutes, firstAction, name, note, weekdays, weeklyFrequency (+39 more)

### Community 2 - "프로젝트 구성과 구현 경계"
Cohesion: 0.10512820512820513
Nodes (40): 변경 초안 swipe 확인 구현, 루틴 편집과 후속 구현 경계, 공유 scheme과 로컬 테스트, 2026-10-04-foundation.md, 기반 네이티브 검증 기록, Foundation, ios.yml, iOS 빌드와 테스트 CI (+32 more)

### Community 3 - "네이티브 시트 닫기 연결"
Cohesion: 0.08097165991902834
Nodes (39): Any, Context, Coordinator, .attach(), .detach(), .forwardingTarget(), .presentationControllerDidAttemptToDismiss(), .presentationControllerDidDismiss() (+31 more)

### Community 4 - "앱 저장소와 V1 스키마"
Cohesion: 0.0784313725490196
Nodes (34): App, HanjuApp, .body, HanjuSchemaV1, .models, .versionIdentifier, RoutineTemplate, .init() (+26 more)

### Community 5 - "편집 초안과 복구 동작"
Cohesion: 0.1168091168091168
Nodes (27): SwiftUI DismissAction.callAsFunction, PendingAction, archive, dismiss, RecoveryAction, archive, save, RoutineEditorSheet (+19 more)

### Community 6 - "개발 인계와 독립 리뷰"
Cohesion: 0.1956521739130435
Nodes (24): 에이전트 파일 소유권, AGENTS.md, CONTRIBUTING.md, 독립 리뷰와 통합, 05-swiftui-handoff.md, 채택 기술 구성, index.html, tokens.json (+16 more)

### Community 7 - "제품 원칙과 수행 기록"
Cohesion: 0.1645021645021645
Nodes (22): 중요 기술 결정 ADR, WeekMemo 입력, Records 행동 우선 기록, Settings 설정 화면, AC-05 직접 완료와 수행일 정정, AC-06 알림, AC-09 주간 메모, AC-10 행동 우선 기록과 주 경계 (+14 more)

### Community 8 - "이슈 커밋과 리베이스 규칙"
Cohesion: 0.12631578947368421
Nodes (20): 이슈 연결 Git 규칙, 이슈부터 시작, commit-msg, Validate project commit conventions without third-party dependencies., rebase 원래 브랜치 검증, reject(), bug.md, task.md (+12 more)

### Community 9 - "계획 화면과 상태 명세"
Cohesion: 0.15204678362573099
Nodes (19): ActiveRoutinePanel, CalendarSyncState, 03-components.md, WeekDaySelector, CalendarSheet 주별 연결, Routine Editor 편집 시트, ExecutionRecord, 04-screens.md (+11 more)

### Community 10 - "루틴 편집 UI 회귀검증"
Cohesion: 0.37254901960784315
Nodes (18): RoutineLibraryUITests, .enter(), .finishInput(), .openEditor(), .openLibrary(), .reveal(), .routineRow(), .swipeEditor() (+10 more)

### Community 11 - "실제 깃과 훅 회귀검증"
Cohesion: 0.38235294117647056
Nodes (17): CommitMessageHookTests, .assert_rejected(), .commit(), .conflicting_history(), .git(), .invoke_hook(), .reword(), .setUp() (+9 more)

### Community 12 - "기획 개정과 복귀 흐름"
Cohesion: 0.1619047619047619
Nodes (15): CompletionSheet 수행일 편집, ReplanEntry 복귀 진입, RestWeekAction 쉬기 확인, 실제 공유 UI 추출, 기능별 폴더 구조, 수행일 집계 저장 계약, 같은 회차 재계획 계약, 일괄 쉬기 원자성 계약 (+7 more)

### Community 13 - "PR 정책과 원격 검사"
Cohesion: 0.1978021978021978
Nodes (14): pr-policy.cjs, branchPattern, run(), pr-policy.test.cjs, assert, fixture(), { test }, { validate } (+6 more)

### Community 14 - "접근성 기준과 프리뷰 경계"
Cohesion: 0.21818181818181817
Nodes (11): 처음부터 접근성 지원, 의미 있는 대비 기준, 02-foundations.md, 한국어 시스템 서체, 기획 1.2 프리뷰 경계, 네이티브 검증 계약, 지정 색 조합 대비 결과, contrast-report.json (+3 more)

### Community 15 - "날짜 계약과 캘린더 조정"
Cohesion: 0.2545454545454545
Nodes (11): 캘린더 연결과 쓰기 직렬화, 캘린더 중단 후 복구 계약, LocalDate와 DST 해석, 주 이동별 캘린더 조정, data-contracts.md, 기획 1.3 후속 모델 계약, 알림 예약과 종료 중 한계, 월요일 기준 선호 요일 계약 (+3 more)

### Community 16 - "실행 탐색과 실패 복구"
Cohesion: 0.25
Nodes (9): Running Routine 실행 화면, Today 오늘 화면, 네이티브 탭과 시트 탐색, 화면 독립 실행 기록기, 초안 보존과 저장 결과, AC-04 기록 시작과 중단, AC-08 캘린더 중단과 외부 수정, AC-12 탐색과 입력 취소 (+1 more)

### Community 17 - "네이티브 시맨틱 색상"
Cohesion: 0.25
Nodes (8): CGFloat, AccentColor.colorset/Contents.json, Background.colorset/Contents.json, Assets.xcassets/Contents.json, Surface.colorset/Contents.json, TextPrimary.colorset/Contents.json, TextSecondary.colorset/Contents.json, DesignTokens

### Community 18 - "디자인 방향과 원문 기준"
Cohesion: 0.6
Nodes (5): 정돈한 생활의 페이지, 01-direction.md, 차분한 숲빛 강조색, 사용자 디자인 원문, user-design-brief.txt

## Knowledge Gaps
- **96 weakly-connected symbols (degree ≤ 1):** `URL`, `UUID`, `Date`, `{ test }`, `assert` (+91 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 115 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `UnsavedChangesGuard` connect `네이티브 시트 닫기 연결` to `프로젝트 구성과 구현 경계`, `편집 초안과 복구 동작`?**
  _High betweenness centrality (0.163) - this node is a cross-community bridge._
- **Why does `RoutineDraft` connect `선택 입력과 저장 회귀검증` to `루틴 목록과 편집 탐색`, `프로젝트 구성과 구현 경계`, `앱 저장소와 V1 스키마`, `편집 초안과 복구 동작`?**
  _High betweenness centrality (0.127) - this node is a cross-community bridge._
- **Are the 5 inferred relationships involving `RoutineDraft` (e.g. with `.body` and `.toggleDay()`) actually correct?**
  _`RoutineDraft` has 5 INFERRED edges - model-reasoned connections that need verification._
- **What connects `URL`, `UUID`, `Date` to the rest of the system?**
  _96 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `루틴 목록과 편집 탐색` be split into smaller, more focused modules?**
  _Cohesion score 0.055152394775036286 - nodes in this community are weakly interconnected._
- **Should `선택 입력과 저장 회귀검증` be split into smaller, more focused modules?**
  _Cohesion score 0.08695652173913043 - nodes in this community are weakly interconnected._
- **Should `프로젝트 구성과 구현 경계` be split into smaller, more focused modules?**
  _Cohesion score 0.10512820512820513 - nodes in this community are weakly interconnected._

## 추출 검증과 한계

- 이전 공유 source ba92e7e95dd8f3c3435b7cc4fcbd7b307797cffe에서 기획 source e5945a80cee18244ceb6b9d821a431617cb4cd10로 문서 11개를 갱신한 뒤, 현재 source에서 변경·추가 15개를 갱신했다. 이번 단계 동일 입력 43개는 SHA256 검증 후 재사용했다. 전체 재추출이 아니다.
- 대표 relation/confidence/confidence_score와 보고서 비율은 graphify가 선택한 대표 연결 기준이다. 병합 연결의 evidence 배열은 원시 관계별 source/target/relation/confidence/confidence_score/source_file/source_location을 모두 보존한다.
- 원시 추출(AST+의미)의 909개 관계 중 38개는 같은 endpoint 쌍의 추가 관계·라인이다. 최종 단순 그래프는 871개 연결이며 중복 쌍 29개의 모든 원문 관계를 edge.evidence에 보존했다. 이전 소스에서 변경된 관계는 최신 소스로 대체했다.
- 새 AST 수신자 오인 16건을 원문으로 보정했다. dismiss()를 enum case로, ModelContext.fetch 및 UIKit super/기존 delegate 호출을 자체 재귀 호출로 해석하지 않도록 실제 외부 API 사용 근거에 연결했다. 상세 보정은 provenance.ast_receiver_corrections에 기록했다.
- RoutineWriter 주입 save closure가 RoutineEditorSheet.save로 연결되지 않음을 확인했다. 이전 pr-policy.cjs module.exports 두 항목의 exports 관계 보정도 유지했다.
- AST 외부/제네릭 타입 및 외부 API 노드의 source_file/source_location은 정의 파일이 아닌 사용 근거 위치다. 파일 투영 결과를 실제 순환 의존으로 해석하지 않는다.
- 이번 단계 Swift 11개를 AST 재추출하고 문서·프로젝트 4개를 현재 Codex에서 의미 재검증했다. Xcode project/scheme, CI YAML, 디자인·asset JSON은 AST 호출 그래프 대상이 아니다.
- #7의 루틴 선택필드 편집·분류 필터·보관/복원·dirty swipe 확인은 구현되어 있다. RoutineSnapshot은 현재 루틴의 UI 값 복사이며 과거 PlannedOccurrence/실행 기록 snapshot 모델은 #8 이후다. V1 스키마는 변경하지 않았다.
- 기획 1.3의 일괄 쉬기·재계획·수행일 정정·주별 캘린더 연결·행동 우선 기록은 #8~#13 후속 구현/인수 계약이다. 현재 그래프가 전체 MVP 또는 전체 AC 완료를 뜻하지 않는다.
- 완료 입력 날짜 집계·추가 일정 수동 반영 등 변경된 1.2 정책은 1.3 정책으로 대체했다. HTML 프리뷰는 1.2 예시다. README의 이름 등록 기반 설명과 기존 기반 검증 문서는 과거 단계 내용이므로 현재 구현 상태는 소스와 최신 구현 계획을 확인한다.
- 현재 입력에는 테스트 정의와 기존 검증 snapshot이 들어 있다. 원격 CI 실행 결과는 이 그래프의 입력이 아니며 테스트 존재를 실행 성공·실기기/VoiceOver 인수로 추정하지 않는다.
- 입력 58개 전체 파일 출처를 포함하지만 주요 개념 중심 인덱스이며 모든 문장·SwiftUI modifier·Xcode 설정의 완전한 모델은 아니다.
- design/tokens.json 민감 파일명 오탐은 디자인 값 확인 뒤 명시 포함했다. archive/skills/graphify 출력/의존 메타데이터/빌드 산출물은 제외했다.
- 커뮤니티 표는 기본 보고서의 파일·메서드 제외 필터를 적용하지 않고 graph.json 전체 노드로 집계했다. 현재 구성원을 확인해 한국어로 다시 이름 붙인 19개 묶음을 모두 표시하며 cohesion도 같은 전체 그래프의 원시 값이다.
- 모델 ID·입력/출력 토큰·비용 집계는 제공되지 않아 null로 기록한다. 외부 LLM API를 사용하지 않았다.

- 58/58 입력에 출처 노드 존재, 상대 경로와 실제 줄번호 범위 확인. dangling/missing endpoint·self-loop 0.
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
- `Hanju/Features/Library/RoutineFieldError.swift`
- `Hanju/Features/Library/RoutineListView.swift`
- `Hanju/Features/Library/RoutineRow.swift`
- `Hanju/Features/Library/RoutineSnapshot.swift`
- `Hanju/Features/Library/RoutineWriter.swift`
- `Hanju/Features/Library/UnsavedChangesGuard.swift`
- `Hanju/Models/HanjuSchemaV1.swift`
- `Hanju/Models/RoutineTemplate.swift`
- `Hanju/Persistence/PersistenceStore.swift`
- `HanjuTests/RoutineLibraryTests.swift`
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
- `docs/development/planning-revision-1.3.md`
- `docs/development/review-workflow.md`
- `docs/product-plan.md`
- `docs/verification/2026-10-04-foundation.md`
