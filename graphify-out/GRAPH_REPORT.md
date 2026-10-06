> 분석 기준: main `29dbb87aa32e277a831718fe0ce7ec9763b818a7` · 이슈 #8 · PR #23 병합 후 고정 snapshot.
> 현재 Codex 세션의 의미 추출과 한국어 라벨을 사용했다. 모델·토큰·비용은 알 수 없음.
> 기획 1.3 정책 채택과 앱 구현을 구분한다. 그래프 생성은 전체 MVP 또는 인수 완료를 뜻하지 않는다.

# Graph Report - ptoj  (2026-10-06)

## Corpus Check
- 71 tracked source files; 21 refreshed; 50 hash-verified reuse.

## Summary
- 698 nodes · 1507 edges · 24 communities (all shown)
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 87 edges (avg confidence: 0.88)
- Token cost: 알 수 없음 input · 알 수 없음 output

## Graph Freshness
- Built from commit: `29dbb87a`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- main 병합 뒤에만 현재 AI 세션으로 갱신한다. source_commit 이후 변경은 원문 diff로 확인한다.

## Community Hubs (Navigation)
- 프로젝트 구성과 계획 구현
- 루틴 저장과 디스크 이전
- 지역 날짜와 초안 배분
- 오늘 주간 탐색과 상태
- 계획 저장 명령과 회귀검증
- 네이티브 시트 닫기 연결
- 루틴 목록과 요청 상태
- 이슈 커밋과 PR 정책
- 버전 스키마와 영속 계획
- 루틴 계획 UI 회귀검증
- 계획 조정과 닫기 확인
- 루틴 편집과 입력 복구
- 개발 인계와 독립 리뷰
- 계획 선택과 예상 분량
- 제품 원칙과 후속 기록
- 계획 실행 화면 명세
- 실제 깃과 훅 회귀검증
- 기획 개정과 복귀 계약
- 접근성 기준과 프리뷰 경계
- 날짜 계약과 후속 캘린더
- 네이티브 시맨틱 색상
- 디자인 방향과 원문 기준
- 탐색 취소와 외부 변경
- 저장 실패 테스트 오류

## God Nodes (most connected - your core abstractions)
1. `LocalDate` - 48 edges
2. `OccurrenceSnapshot` - 36 edges
3. `Hanju 네이티브 프로젝트` - 33 edges
4. `한 주 iPhone MVP` - 28 edges
5. `RoutineEditorSheet` - 25 edges
6. `WeeklySelectionSheet` - 25 edges
7. `WeekView` - 23 edges
8. `RoutineDraft` - 20 edges
9. `RoutineListView` - 19 edges
10. `RoutineSnapshot` - 19 edges

## Surprising Connections (you probably didn't know these)
- `PR 정책과 main 보호` --implements--> `validate()`  [EXTRACTED]
  docs/development/review-workflow.md → .github/scripts/pr-policy.cjs
- `iOS 17 Swift 6 기반 채택` --implements--> `HanjuApp`  [EXTRACTED]
  docs/adr/0001-native-ios-foundation.md → Hanju/App/HanjuApp.swift
- `RoutineTemplate` --implements--> `RoutineTemplate`  [EXTRACTED]
  design/04-screens.md → Hanju/Models/HanjuSchemaV1.swift
- `버전 스키마와 로컬 저장` --implements--> `PersistenceStore`  [EXTRACTED]
  docs/adr/0001-native-ios-foundation.md → Hanju/Persistence/PersistenceStore.swift
- `주간 계획과 후속 구현 경계` --references--> `루틴 저장과 보관 명령`  [EXTRACTED]
  docs/development/implementation-plan.md → Hanju/Features/Library/RoutineWriter.swift

## Import Cycles

아래는 참조 사용 위치를 정의 파일로 취급한 도구의 파일 투영 결과가 포함될 수 있다. 외부 모듈·제네릭 타입의 source_file은 사용 근거이며 실제 코드 순환을 의미하지 않는다.
- 1-file cycle: `.github/scripts/pr-policy.test.cjs -> .github/scripts/pr-policy.test.cjs`
- 1-file cycle: `.githooks/commit-msg -> .githooks/commit-msg`

## Communities (24 total, all shown)

모든 수치는 graph.json의 전체 노드를 기준으로 한다. 파일·심볼·개념 노드를 제외하지 않으며, 각 목록은 이름 8개만 미리 표시한다.

| ID | 공통 라벨 | JSON·보고서 전체 노드 수 |
| --- | --- | ---: |
| 0 | 프로젝트 구성과 계획 구현 | 78 |
| 1 | 루틴 저장과 디스크 이전 | 74 |
| 2 | 지역 날짜와 초안 배분 | 60 |
| 3 | 오늘 주간 탐색과 상태 | 57 |
| 4 | 계획 저장 명령과 회귀검증 | 42 |
| 5 | 네이티브 시트 닫기 연결 | 39 |
| 6 | 루틴 목록과 요청 상태 | 34 |
| 7 | 이슈 커밋과 PR 정책 | 34 |
| 8 | 버전 스키마와 영속 계획 | 30 |
| 9 | 루틴 계획 UI 회귀검증 | 30 |
| 10 | 계획 조정과 닫기 확인 | 28 |
| 11 | 루틴 편집과 입력 복구 | 27 |
| 12 | 개발 인계와 독립 리뷰 | 25 |
| 13 | 계획 선택과 예상 분량 | 23 |
| 14 | 제품 원칙과 후속 기록 | 22 |
| 15 | 계획 실행 화면 명세 | 21 |
| 16 | 실제 깃과 훅 회귀검증 | 17 |
| 17 | 기획 개정과 복귀 계약 | 14 |
| 18 | 접근성 기준과 프리뷰 경계 | 11 |
| 19 | 날짜 계약과 후속 캘린더 | 9 |
| 20 | 네이티브 시맨틱 색상 | 8 |
| 21 | 디자인 방향과 원문 기준 | 5 |
| 22 | 탐색 취소와 외부 변경 | 5 |
| 23 | 저장 실패 테스트 오류 | 5 |
| 합계 | 24개 커뮤니티 | 698 |

### Community 0 - "프로젝트 구성과 계획 구현"
Cohesion: 0.05194805194805195
Nodes (78): 일괄 쉬기와 실행 연계 계약, 월요일 기준 선호 요일 계약, 변경 초안 swipe 확인 구현, implementation-plan.md, 주간 계획과 후속 구현 경계, 공유 scheme과 로컬 테스트, 2026-10-04-foundation.md, 기반 네이티브 검증 기록 (+70 more)

### Community 1 - "루틴 저장과 디스크 이전"
Cohesion: 0.05405405405405406
Nodes (74): App, HanjuApp, .body, Field, expectedMinutes, firstAction, name, note (+66 more)

### Community 2 - "지역 날짜와 초안 배분"
Cohesion: 0.05480225988700565
Nodes (60): Calendar, ClosedRange, Codable, Comparable, Destination, archive, .init(), PlanDateFields (+52 more)

### Community 3 - "오늘 주간 탐색과 상태"
Cohesion: 0.05325814536340852
Nodes (57): Actions, AppTabs, .body, .emptyScreen(), String, Tab, library, records (+49 more)

### Community 4 - "계획 저장 명령과 회귀검증"
Cohesion: 0.14982578397212543
Nodes (42): .save(), PlanDraft, .validate(), ModelContext.fetch, PlanWriter, .check(), .commit(), .confirm() (+34 more)

### Community 5 - "네이티브 시트 닫기 연결"
Cohesion: 0.08097165991902834
Nodes (39): Any, Context, Coordinator, .attach(), .detach(), .forwardingTarget(), .presentationControllerDidAttemptToDismiss(), .presentationControllerDidDismiss() (+31 more)

### Community 6 - "루틴 목록과 요청 상태"
Cohesion: 0.09090909090909091
Nodes (34): Binding, Equatable, Editor, Focus, archive, empty, filter, newRoutine (+26 more)

### Community 7 - "이슈 커밋과 PR 정책"
Cohesion: 0.0766488413547237
Nodes (34): 이슈 연결 Git 규칙, 이슈부터 시작, commit-msg, Validate project commit conventions without third-party dependencies., rebase 원래 브랜치 검증, reject(), bug.md, task.md (+26 more)

### Community 8 - "버전 스키마와 영속 계획"
Cohesion: 0.10114942528735632
Nodes (30): HanjuSchemaV1, .models, .versionIdentifier, RoutineTemplate, .init(), Bool, Date, String (+22 more)

### Community 9 - "루틴 계획 UI 회귀검증"
Cohesion: 0.20229885057471264
Nodes (30): RoutineLibraryUITests, .enter(), .finishInput(), .openEditor(), .openLibrary(), .reveal(), .routineRow(), .swipeEditor() (+22 more)

### Community 10 - "계획 조정과 닫기 확인"
Cohesion: 0.0873015873015873
Nodes (28): Content, Mode, move, recovery, rest, PlanAdjustmentSheet, .body, .canSave (+20 more)

### Community 11 - "루틴 편집과 입력 복구"
Cohesion: 0.1168091168091168
Nodes (27): SwiftUI DismissAction.callAsFunction, PendingAction, archive, dismiss, RecoveryAction, archive, save, RoutineEditorSheet (+19 more)

### Community 12 - "개발 인계와 독립 리뷰"
Cohesion: 0.18333333333333332
Nodes (25): 에이전트 파일 소유권, AGENTS.md, CONTRIBUTING.md, 독립 리뷰와 통합, 05-swiftui-handoff.md, 채택 기술 구성, index.html, tokens.json (+17 more)

### Community 13 - "계획 선택과 예상 분량"
Cohesion: 0.1541501976284585
Nodes (23): DayWorkload, .label(), Binding, Bool, Error, Int, RoutineSnapshot, Set (+15 more)

### Community 14 - "제품 원칙과 후속 기록"
Cohesion: 0.1645021645021645
Nodes (22): 중요 기술 결정 ADR, WeekMemo 입력, Records 행동 우선 기록, Settings 설정 화면, AC-05 직접 완료와 수행일 정정, AC-06 알림, AC-09 주간 메모, AC-10 행동 우선 기록과 주 경계 (+14 more)

### Community 15 - "계획 실행 화면 명세"
Cohesion: 0.1523809523809524
Nodes (21): ActiveRoutinePanel, CalendarSyncState, 03-components.md, WeekDaySelector, CalendarSheet 주별 연결, Routine Editor 편집 시트, ExecutionRecord, 04-screens.md (+13 more)

### Community 16 - "실제 깃과 훅 회귀검증"
Cohesion: 0.38235294117647056
Nodes (17): CommitMessageHookTests, .assert_rejected(), .commit(), .conflicting_history(), .git(), .invoke_hook(), .reword(), .setUp() (+9 more)

### Community 17 - "기획 개정과 복귀 계약"
Cohesion: 0.17582417582417584
Nodes (14): CompletionSheet 수행일 편집, ReplanEntry 복귀 진입, RestWeekAction 쉬기 확인, 실제 공유 UI 추출, 기능별 폴더 구조, 수행일 집계 저장 계약, 같은 회차 재계획 계약, 순차 기능 이슈와 의존성 (+6 more)

### Community 18 - "접근성 기준과 프리뷰 경계"
Cohesion: 0.21818181818181817
Nodes (11): 처음부터 접근성 지원, 의미 있는 대비 기준, 02-foundations.md, 한국어 시스템 서체, 기획 1.2 프리뷰 경계, 네이티브 검증 계약, 지정 색 조합 대비 결과, contrast-report.json (+3 more)

### Community 19 - "날짜 계약과 후속 캘린더"
Cohesion: 0.3333333333333333
Nodes (9): 캘린더 연결과 쓰기 직렬화, 캘린더 중단 후 복구 계약, LocalDate와 DST 해석, 주 이동별 캘린더 조정, data-contracts.md, V2 계획과 후속 기록 계약, 알림 예약과 종료 중 한계, AC-07 주별 캘린더 연결 (+1 more)

### Community 20 - "네이티브 시맨틱 색상"
Cohesion: 0.25
Nodes (8): CGFloat, AccentColor.colorset/Contents.json, Background.colorset/Contents.json, Assets.xcassets/Contents.json, Surface.colorset/Contents.json, TextPrimary.colorset/Contents.json, TextSecondary.colorset/Contents.json, DesignTokens

### Community 21 - "디자인 방향과 원문 기준"
Cohesion: 0.6
Nodes (5): 정돈한 생활의 페이지, 01-direction.md, 차분한 숲빛 강조색, 사용자 디자인 원문, user-design-brief.txt

### Community 22 - "탐색 취소와 외부 변경"
Cohesion: 0.4
Nodes (5): 네이티브 탭과 시트 탐색, 초안 보존과 저장 결과, AC-08 캘린더 중단과 외부 수정, AC-12 탐색과 입력 취소, 캘린더 해제와 외부 변경

### Community 23 - "저장 실패 테스트 오류"
Cohesion: 0.4
Nodes (5): Error, Failure, diskFull, Failure, disk

## Knowledge Gaps
- **186 weakly-connected symbols (degree ≤ 1):** `URL`, `UUID`, `Date`, `{ test }`, `assert` (+181 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 206 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalDate` connect `지역 날짜와 초안 배분` to `프로젝트 구성과 계획 구현`, `루틴 저장과 디스크 이전`, `오늘 주간 탐색과 상태`, `계획 저장 명령과 회귀검증`, `루틴 목록과 요청 상태`, `버전 스키마와 영속 계획`, `계획 조정과 닫기 확인`, `계획 선택과 예상 분량`?**
  _High betweenness centrality (0.127) - this node is a cross-community bridge._
- **Why does `UnsavedChangesGuard` connect `네이티브 시트 닫기 연결` to `프로젝트 구성과 계획 구현`, `루틴 편집과 입력 복구`?**
  _High betweenness centrality (0.104) - this node is a cross-community bridge._
- **Are the 5 inferred relationships involving `LocalDate` (e.g. with `AppTabs` and `.body`) actually correct?**
  _`LocalDate` has 5 INFERRED edges - model-reasoned connections that need verification._
- **Are the 6 inferred relationships involving `OccurrenceSnapshot` (e.g. with `.body` and `.allocate()`) actually correct?**
  _`OccurrenceSnapshot` has 6 INFERRED edges - model-reasoned connections that need verification._
- **What connects `URL`, `UUID`, `Date` to the rest of the system?**
  _186 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `프로젝트 구성과 계획 구현` be split into smaller, more focused modules?**
  _Cohesion score 0.05194805194805195 - nodes in this community are weakly interconnected._
- **Should `루틴 저장과 디스크 이전` be split into smaller, more focused modules?**
  _Cohesion score 0.05405405405405406 - nodes in this community are weakly interconnected._

## 추출 검증과 한계

- 이전 공유 main source 50abf15d57ed39dc08bc841ac12e4d13f68cb276에서 현재 main source 29dbb87aa32e277a831718fe0ce7ec9763b818a7로 변경·추가 21개(신규 13개 포함)를 갱신했다. 동일 입력 50개는 SHA256 검증 후 재사용했다. 전체 재추출이 아니다.
- 최종 단순 그래프의 대표 relation/confidence와 보고서 비율은 도구가 선택한 대표 연결 기준이다. 모든 연결의 evidence 배열에 원시 관계의 source/target/relation/confidence/confidence_score/source_file/source_location/context/rationale 등 존재하는 모든 필드를 보존했다.
- 원시 관계 1632개 중 동일 endpoint 쌍 추가 관계 125개를 병합해 연결 1507개가 되었다. 다중 근거 쌍 84개를 포함한 모든 원시 관계를 순서 없는 endpoint 쌍별 Counter로 검증했다.
- 이번 AST 수신자·오버로드 오인 13건을 원문으로 보정했다. ModelContext.fetch와 PlanWriter.fetch, Mode enum과 PlanWriter.move/rest, PlanDraft.allocate, LocalTime 변환 및 LocalDate/LocalTime initializer 위임을 구분한다. 이전 source 보정 16건은 변경되지 않은 출처에서 유지했다.
- RoutineWriter/PlanWriter의 주입 save closure를 편집 시트의 save로 연결하지 않음을 확인했다. 이전 pr-policy.cjs module.exports 두 항목의 exports 보정도 유지했다.
- AST는 이름 기준 연결과 동일 호출의 첫 위치만 표현할 수 있다. 예를 들어 PlanWriter.confirm의 두 transaction.fetch 호출은 한 관계 L21로 표현되며 L26은 원문에서 확인해야 한다. 각 SwiftUI modifier·모든 호출 위치의 완전한 그래프는 아니다.
- AST 외부/제네릭 타입과 API 노드의 출처는 정의가 아닌 사용 위치다. 동명 initializer를 합친 AST에 정확한 위임 대상 노드를 보완했다. 파일 투영을 실제 순환 의존으로 해석하지 않는다.
- 이번 단계 Swift 15개를 AST 재추출하고 문서·프로젝트·CI 6개를 현재 Codex로 의미 재검증했다. 프로젝트/scheme·YAML·JSON은 AST 호출 그래프 대상이 아니다.
- #8의 V2 WeekPlan·PlannedOccurrence는 영속 계획과 확정 당시 루틴 snapshot을 구현한다. V1 RoutineTemplate는 유지하고 lightweight migration을 적용한다. RoutineSnapshot은 루틴 UI 값 복사, OccurrenceSnapshot은 영속 계획 UI 값 복사로 서로 구분한다.
- 계획 확정·이동·쉬기·복원·선택 재계획은 구현됐다. running 변경은 현재 recorder가 없어 거절한다. ExecutionRecord·실행 interval·알림·캘린더 #9~#12와 전체 인수 #13은 후속이며, 상태 enum과 정책 문서의 존재가 완료를 뜻하지 않는다.
- 기획 1.3이 1.2의 완료 날짜 집계·추가 일정 수동 반영 정책 등을 대체한다. HTML 프리뷰 1.2와 README 기반 설명·기존 검증 snapshot은 과거 단계이므로 현재 상태는 최신 소스와 구현 계획을 확인한다.
- 입력에는 테스트 정의와 기존 검증 snapshot이 포함된다. 현재 원격 CI 결과는 입력이 아니며 테스트 존재를 실행 성공·실기기/VoiceOver 인수로 추정하지 않는다. WeekPlan UI 회복 테스트에는 월요일 조건부 skip이 있다.
- 71개 입력의 출처가 있으나 주요 개념 인덱스다. source coverage는 모든 문장·설정·호출이 추출되었다는 뜻이 아니다.
- design/tokens.json의 파일명 민감 오탐은 내용 확인 후 포함했다. archive/skills/.git/graphify 출력/의존 메타데이터/빌드·캐시/비밀·개인 데이터는 입력에서 제외했다.
- 보고서 커뮤니티는 파일·메서드 제외 필터 없이 JSON 전체 노드로 집계한다. 현재 구성원을 바탕으로 24개 커뮤니티를 새로 한국어 라벨링했고 모두 표시한다. cohesion은 전체 그래프 원시 값이다.
- 모델 ID·입력/출력 토큰·비용은 제공되지 않아 null이다. 현재 Codex 세션만 사용했으며 외부 LLM API를 사용하지 않았다.

- 71/71 입력에 출처 노드 존재, 상대 경로와 실제 줄번호 범위 확인. dangling/missing endpoint·self-loop 0.
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
- `Hanju/Features/Today/TodayView.swift`
- `Hanju/Features/Week/OccurrenceSnapshot.swift`
- `Hanju/Features/Week/PlanAdjustmentSheet.swift`
- `Hanju/Features/Week/PlanDateFields.swift`
- `Hanju/Features/Week/PlanDraft.swift`
- `Hanju/Features/Week/PlanWriter.swift`
- `Hanju/Features/Week/WeekView.swift`
- `Hanju/Features/Week/WeeklySelectionSheet.swift`
- `Hanju/Models/HanjuSchemaV1.swift`
- `Hanju/Models/HanjuSchemaV2.swift`
- `Hanju/Models/LocalDate.swift`
- `Hanju/Models/RoutineTemplate.swift`
- `Hanju/Persistence/PersistenceStore.swift`
- `HanjuTests/RoutineLibraryTests.swift`
- `HanjuTests/RoutinePersistenceTests.swift`
- `HanjuTests/SchemaMigrationTests.swift`
- `HanjuTests/WeekPlanTests.swift`
- `HanjuUITests/RoutineLibraryUITests.swift`
- `HanjuUITests/WeekPlanUITests.swift`
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
