> 분석 기준: main `db3a9bfdf9b297446f46084c434ef4bd848511e4` · 이슈 #27 · PR #28 병합 후 고정 snapshot.
> 현재 Codex 세션의 의미 추출과 한국어 라벨을 사용했다. 모델·토큰·비용은 알 수 없음.
> 기획 1.3 정책 채택과 앱 구현을 구분한다. 그래프 생성은 전체 MVP 또는 인수 완료를 뜻하지 않는다.

# Graph Report - ptoj  (2026-10-08)

## Corpus Check
- 84 tracked source files; 12 refreshed; 72 hash-verified reuse.

## Summary
- 942 nodes · 2089 edges · 48 communities (all shown)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 87 edges (avg confidence: 0.87)
- Token cost: 알 수 없음 input · 알 수 없음 output

## Graph Freshness
- Built from commit: `db3a9bfd`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- main 병합 뒤에만 현재 AI 세션으로 갱신한다. source_commit 이후 변경은 원문 diff로 확인한다.

## Community Hubs (Navigation)
- 오늘 실행과 시간 복구
- 루틴 목록과 편집 상태
- 주간 재개와 탭 탐색
- 실행 저장과 원본 회귀검증
- 계획 명령과 원자 저장
- 네이티브 시트 닫기 연결
- 이슈 커밋과 PR 정책
- 동결 스키마와 V3 모델
- 개발 인계와 최신 리뷰
- 제품 원칙과 수행 기록
- 네이티브 화면과 프로젝트 구성
- 루틴 선택과 계획 시트
- 지역 날짜와 DST 해석
- 계획 실행 화면 계약
- 루틴 저장과 디스크 보존
- 계획 조정과 건너뛰기 확인
- 영속 모델과 저장소 연결
- 실행 시계와 원본 보존
- 루틴 편집 UI 검증
- 수행일 계약과 후속 연동
- 실제 깃과 훅 회귀검증
- 실행 복귀와 시간대 UI
- V2 계획 모델 보존
- 수행일과 시간 편집
- 루틴 입력 검증
- 계획 조회와 상태 값
- 주간 계획 UI 검증
- 날짜 입력과 초안 닫기
- 같은 회차의 실행 복귀
- 계획 실행 테스트 구성
- 루틴 저장소 실패 검증
- 실행 저장 오류 안내
- 접근성 기준과 프리뷰 경계
- 구현 인계와 기반 검증
- 계획 초안과 횟수 배분
- 계획 입력 오류 유형
- 루틴 기록 화면 명세
- 실행 제어 화면 상태
- V1 디스크 이전 검증
- 앱 수명 저장소 개방
- 현지 시각 값 변환
- 네이티브 CI 시간 제한
- 실행 강조와 네이티브 색상
- 저장 실패 테스트 오류
- 디자인 방향과 원문 기준
- 선호 요일과 날짜 계약
- 계획 배분 초안 정의

## God Nodes (most connected - your core abstractions)
1. `Hanju 네이티브 프로젝트` - 43 edges
2. `LocalDate` - 30 edges
3. `WeekView` - 29 edges
4. `한 주 iPhone MVP` - 28 edges
5. `RoutineEditorSheet` - 25 edges
6. `ExecutionSnapshot` - 25 edges
7. `ModelContext` - 24 edges
8. `WeeklySelectionSheet` - 24 edges
9. `PlanAdjustmentSheet` - 21 edges
10. `SwiftData` - 20 edges

## Surprising Connections (you probably didn't know these)
- `PR 정책과 main 보호` --implements--> `validate()`  [EXTRACTED]
  docs/development/review-workflow.md → .github/scripts/pr-policy.cjs
- `RoutineTemplate` --implements--> `RoutineTemplate`  [EXTRACTED]
  design/04-screens.md → Hanju/Models/HanjuSchemaV1.swift
- `iOS 17 Swift 6 기반 채택` --implements--> `HanjuApp`  [EXTRACTED]
  docs/adr/0001-native-ios-foundation.md → Hanju/App/HanjuApp.swift
- `버전 스키마와 로컬 저장` --implements--> `PersistenceStore`  [EXTRACTED]
  docs/adr/0001-native-ios-foundation.md → Hanju/Persistence/PersistenceStore.swift
- `실행 구현과 후속 기능 경계` --references--> `루틴 목록과 편집 값 복사`  [EXTRACTED]
  docs/development/implementation-plan.md → Hanju/Features/Library/RoutineSnapshot.swift

## Import Cycles

아래는 참조 사용 위치를 정의 파일로 취급한 도구의 파일 투영 결과가 포함될 수 있다. 외부 모듈·제네릭 타입의 source_file은 사용 근거이며 실제 코드 순환을 의미하지 않는다.
- 1-file cycle: `.github/scripts/pr-policy.test.cjs -> .github/scripts/pr-policy.test.cjs`
- 1-file cycle: `.githooks/commit-msg -> .githooks/commit-msg`

## Communities (48 total, all shown)

모든 수치는 graph.json의 전체 노드를 기준으로 한다. 파일·심볼·개념 노드를 제외하지 않으며, 각 목록은 이름 8개만 미리 표시한다.

| ID | 공통 라벨 | JSON·보고서 전체 노드 수 |
| --- | --- | ---: |
| 0 | 오늘 실행과 시간 복구 | 69 |
| 1 | 루틴 목록과 편집 상태 | 62 |
| 2 | 주간 재개와 탭 탐색 | 50 |
| 3 | 실행 저장과 원본 회귀검증 | 48 |
| 4 | 계획 명령과 원자 저장 | 48 |
| 5 | 네이티브 시트 닫기 연결 | 39 |
| 6 | 이슈 커밋과 PR 정책 | 34 |
| 7 | 동결 스키마와 V3 모델 | 33 |
| 8 | 개발 인계와 최신 리뷰 | 28 |
| 9 | 제품 원칙과 수행 기록 | 26 |
| 10 | 네이티브 화면과 프로젝트 구성 | 25 |
| 11 | 루틴 선택과 계획 시트 | 24 |
| 12 | 지역 날짜와 DST 해석 | 22 |
| 13 | 계획 실행 화면 계약 | 22 |
| 14 | 루틴 저장과 디스크 보존 | 22 |
| 15 | 계획 조정과 건너뛰기 확인 | 22 |
| 16 | 영속 모델과 저장소 연결 | 21 |
| 17 | 실행 시계와 원본 보존 | 18 |
| 18 | 루틴 편집 UI 검증 | 18 |
| 19 | 수행일 계약과 후속 연동 | 17 |
| 20 | 실제 깃과 훅 회귀검증 | 17 |
| 21 | 실행 복귀와 시간대 UI | 17 |
| 22 | V2 계획 모델 보존 | 16 |
| 23 | 수행일과 시간 편집 | 15 |
| 24 | 루틴 입력 검증 | 15 |
| 25 | 계획 조회와 상태 값 | 15 |
| 26 | 주간 계획 UI 검증 | 14 |
| 27 | 날짜 입력과 초안 닫기 | 13 |
| 28 | 같은 회차의 실행 복귀 | 13 |
| 29 | 계획 실행 테스트 구성 | 13 |
| 30 | 루틴 저장소 실패 검증 | 13 |
| 31 | 실행 저장 오류 안내 | 12 |
| 32 | 접근성 기준과 프리뷰 경계 | 11 |
| 33 | 구현 인계와 기반 검증 | 11 |
| 34 | 계획 초안과 횟수 배분 | 10 |
| 35 | 계획 입력 오류 유형 | 10 |
| 36 | 루틴 기록 화면 명세 | 9 |
| 37 | 실행 제어 화면 상태 | 9 |
| 38 | V1 디스크 이전 검증 | 9 |
| 39 | 앱 수명 저장소 개방 | 8 |
| 40 | 현지 시각 값 변환 | 8 |
| 41 | 네이티브 CI 시간 제한 | 8 |
| 42 | 실행 강조와 네이티브 색상 | 8 |
| 43 | 저장 실패 테스트 오류 | 7 |
| 44 | 디자인 방향과 원문 기준 | 5 |
| 45 | 선호 요일과 날짜 계약 | 5 |
| 46 | 계획 배분 초안 정의 | 2 |
| 47 | 에셋 카탈로그 메타데이터 | 1 |
| 합계 | 48개 커뮤니티 | 942 |

### Community 0 - "오늘 실행과 시간 복구"
Cohesion: 0.06777493606138107
Nodes (69): Equatable, ExecutionClock, .elapsed(), .now(), Sample, Date, Double, Int64 (+61 more)

### Community 1 - "루틴 목록과 편집 상태"
Cohesion: 0.05023796932839767
Nodes (62): Binding, SwiftUI DismissAction.callAsFunction, PendingAction, archive, dismiss, RecoveryAction, archive, save (+54 more)

### Community 2 - "주간 재개와 탭 탐색"
Cohesion: 0.07102040816326531
Nodes (50): Actions, AppTabs, .body, .emptyScreen(), String, Tab, library, records (+42 more)

### Community 3 - "실행 저장과 원본 회귀검증"
Cohesion: 0.16578014184397163
Nodes (48): Double, ExecutionInterval, ExecutionRecord, ExecutionWriter, .active(), .check(), .closeRunning(), .commit() (+40 more)

### Community 4 - "계획 명령과 원자 저장"
Cohesion: 0.12234042553191489
Nodes (48): .save(), ModelContext.fetch, PlanWriter, .check(), .commit(), .confirm(), .fetch(), .find() (+40 more)

### Community 5 - "네이티브 시트 닫기 연결"
Cohesion: 0.08097165991902834
Nodes (39): Any, Context, Coordinator, .attach(), .detach(), .forwardingTarget(), .presentationControllerDidAttemptToDismiss(), .presentationControllerDidDismiss() (+31 more)

### Community 6 - "이슈 커밋과 PR 정책"
Cohesion: 0.0766488413547237
Nodes (34): 이슈 연결 Git 규칙, 이슈부터 시작, commit-msg, Validate project commit conventions without third-party dependencies., rebase 원래 브랜치 검증, reject(), bug.md, task.md (+26 more)

### Community 7 - "동결 스키마와 V3 모델"
Cohesion: 0.07954545454545454
Nodes (33): HanjuSchemaV1, .models, .versionIdentifier, RoutineTemplate, .init(), Bool, Date, String (+25 more)

### Community 8 - "개발 인계와 최신 리뷰"
Cohesion: 0.15873015873015872
Nodes (28): 에이전트 파일 소유권, 모든 PR 최신 Copilot 확인, AGENTS.md, CONTRIBUTING.md, 독립 리뷰와 Copilot 대기, 05-swiftui-handoff.md, 저장 날짜의 자동변경 금지, 채택 기술 구성 (+20 more)

### Community 9 - "제품 원칙과 수행 기록"
Cohesion: 0.13538461538461538
Nodes (26): 중요 기술 결정 ADR, WeekMemo 입력, Records 행동 우선 기록, Settings 설정 화면, 초안 보존과 저장 결과, AC-05 직접 완료와 수행일 정정, AC-06 알림, AC-08 캘린더 중단과 외부 수정 (+18 more)

### Community 10 - "네이티브 화면과 프로젝트 구성"
Cohesion: 0.13
Nodes (25): CGFloat, AppTabs.swift, 탭 탐색과 실행 연결, HanjuApp.swift, 앱 수명 실행 환경 주입, DesignTokens.swift, DesignTokens, CompletionSheet.swift (+17 more)

### Community 11 - "루틴 선택과 계획 시트"
Cohesion: 0.14855072463768115
Nodes (24): DayWorkload, .label(), Binding, Bool, Error, Int, RoutineSnapshot, Set (+16 more)

### Community 12 - "지역 날짜와 DST 해석"
Cohesion: 0.1471861471861472
Nodes (22): Calendar, Comparable, .timeBinding, .lastDay, LocalDate, .adding(), .calendar(), LocalDate.init(year:month:day:) (+14 more)

### Community 13 - "계획 실행 화면 계약"
Cohesion: 0.11255411255411256
Nodes (22): ActiveRoutinePanel, CalendarSyncState, 03-components.md, ReplanEntry 복귀 진입, RestWeekAction 쉬기 확인, 실제 공유 UI 추출, WeekDaySelector, CalendarSheet 주별 연결 (+14 more)

### Community 14 - "루틴 저장과 디스크 보존"
Cohesion: 0.19047619047619047
Nodes (22): ModelContext.fetch, RoutineWriter, .commit(), .fetch(), .find(), .optionalText(), .persist(), .setArchived() (+14 more)

### Community 15 - "계획 조정과 건너뛰기 확인"
Cohesion: 0.12121212121212122
Nodes (22): Mode, move, recovery, rest, PlanAdjustmentSheet, .body, .canSave, .dirty (+14 more)

### Community 16 - "영속 모델과 저장소 연결"
Cohesion: 0.17142857142857143
Nodes (21): Foundation, ExecutionRecorder.swift, RoutineDraft.swift, RoutineEditorSheet.swift, RoutineWriter.swift, OccurrenceSnapshot.swift, 계획 화면 값 복사, HanjuSchemaV1.swift (+13 more)

### Community 17 - "실행 시계와 원본 보존"
Cohesion: 0.11764705882352941
Nodes (18): Darwin, 실행 시계와 복구 결정, V3 실행 저장 계약, ExecutionClock.swift, 재실행 시계 비교 한계, 수면 포함 실행 시계, ExecutionSnapshot.swift, 미기록과 불확실 시간 구분 (+10 more)

### Community 18 - "루틴 편집 UI 검증"
Cohesion: 0.37254901960784315
Nodes (18): RoutineLibraryUITests, .enter(), .finishInput(), .openEditor(), .openLibrary(), .reveal(), .routineRow(), .swipeEditor() (+10 more)

### Community 19 - "수행일 계약과 후속 연동"
Cohesion: 0.16176470588235295
Nodes (17): CompletionSheet 수행일 편집, 캘린더 연결과 쓰기 직렬화, 캘린더 중단 후 복구 계약, LocalDate와 DST 해석, 주 이동별 캘린더 조정, data-contracts.md, V3 실행과 후속 연동 계약, 알림 예약과 종료 중 한계 (+9 more)

### Community 20 - "실제 깃과 훅 회귀검증"
Cohesion: 0.38235294117647056
Nodes (17): CommitMessageHookTests, .assert_rejected(), .commit(), .conflicting_history(), .git(), .invoke_hook(), .reword(), .setUp() (+9 more)

### Community 21 - "실행 복귀와 시간대 UI"
Cohesion: 0.3014705882352941
Nodes (17): ExecutionUITests, .cancel(), .createTodayPlans(), .pickDate(), .reveal(), .testDirectCompletionEditCancellationZeroTimeAndUndo(), .testPastWeekPausedResumeConfirmsSwitchAndReturnsToSamePlan(), .testPriorWeekDirectCompletionAndPerformedDateCorrectionKeepPlanInPlace() (+9 more)

### Community 22 - "V2 계획 모델 보존"
Cohesion: 0.20833333333333334
Nodes (16): HanjuSchemaV2, .models, .versionIdentifier, PlannedOccurrence, .init(), Bool, Date, Int (+8 more)

### Community 23 - "수행일과 시간 편집"
Cohesion: 0.14285714285714285
Nodes (15): CompletionSheet, .body, .dateBinding, .dirty, .init(), .latestAllowedDay, .save(), .undo() (+7 more)

### Community 24 - "루틴 입력 검증"
Cohesion: 0.23809523809523808
Nodes (15): Field, expectedMinutes, firstAction, name, note, weekdays, weeklyFrequency, RoutineDraft (+7 more)

### Community 25 - "계획 조회와 상태 값"
Cohesion: 0.14285714285714285
Nodes (15): OccurrenceSnapshot, .canReplan, .isUnfinished, .statusLabel, Status, completed, paused, planned (+7 more)

### Community 26 - "주간 계획 UI 검증"
Cohesion: 0.34065934065934067
Nodes (14): Bool, Date, String, XCUIApplication, XCUIElement, WeekPlanUITests, .choose(), .createRoutine() (+6 more)

### Community 27 - "날짜 입력과 초안 닫기"
Cohesion: 0.15384615384615385
Nodes (13): ClosedRange, Content, PlanDateFields, .body, .dateBinding, .hasTime, PlanDismissal, .body() (+5 more)

### Community 28 - "같은 회차의 실행 복귀"
Cohesion: 0.16666666666666666
Nodes (13): 지난 작업 재개 계약, 원본 수행일의 선택 범위, 앱 수명 실행 명령, 시간대 변경과 수행일 보존, 실행 제어와 시간 표시, 오늘 실행과 수행일 완료, PlanAdjustmentSheet.swift, 계획 변경과 실행 갱신 (+5 more)

### Community 29 - "계획 실행 테스트 구성"
Cohesion: 0.19230769230769232
Nodes (13): Hanju, 현재 미완료와 쉬기 안내, ExecutionTests.swift, 실행 시간과 날짜 회귀검증, RoutineLibraryTests.swift, 루틴 저장 실패와 복원 검증, SchemaMigrationTests.swift, V1 디스크 이전 검증 (+5 more)

### Community 30 - "루틴 저장소 실패 검증"
Cohesion: 0.24358974358974358
Nodes (13): .create(), .makeContainer(), Bool, URL, RoutinePersistenceTests, .testBlankNameCannotCreateRoutine(), .testInMemoryContainersDoNotShareData(), .testSaveAndReopenRetainsIdentityAndOptionalValues() (+5 more)

### Community 31 - "실행 저장 오류 안내"
Cohesion: 0.16666666666666666
Nodes (12): ExecutionError, anotherRunning, changed, .errorDescription, futureDate, invalidData, invalidMinutes, String (+4 more)

### Community 32 - "접근성 기준과 프리뷰 경계"
Cohesion: 0.21818181818181817
Nodes (11): 처음부터 접근성 지원, 의미 있는 대비 기준, 02-foundations.md, 한국어 시스템 서체, 기획 1.2 프리뷰 경계, 네이티브 검증 계약, 지정 색 조합 대비 결과, contrast-report.json (+3 more)

### Community 33 - "구현 인계와 기반 검증"
Cohesion: 0.21818181818181817
Nodes (11): 실행 구현과 후속 인계, 변경 초안 swipe 확인 구현, implementation-plan.md, 실행 구현과 후속 기능 경계, 2026-10-04-foundation.md, 기반 네이티브 검증 기록, LibraryView, .body (+3 more)

### Community 34 - "계획 초안과 횟수 배분"
Cohesion: 0.4222222222222222
Nodes (10): Entry, .init(), PlanDraft, .allocate(), .validate(), .validateCounts(), Int, RoutineSnapshot (+2 more)

### Community 35 - "계획 입력 오류 유형"
Cohesion: 0.2
Nodes (10): PlanError, batchLimit, changedOccurrence, .errorDescription, inactiveRoutine, invalidDate, invalidDraft, invalidStoredData (+2 more)

### Community 36 - "루틴 기록 화면 명세"
Cohesion: 0.3611111111111111
Nodes (9): Routine Editor 편집 시트, ExecutionRecord, 04-screens.md, Routine Library 루틴함, PlannedOccurrence, 수행일 표시와 시간 수정, RoutineTemplate, WeekPlan (+1 more)

### Community 37 - "실행 제어 화면 상태"
Cohesion: 0.3333333333333333
Nodes (9): RunningRoutineView, .body, .load(), .perform(), .resume(), ExecutionSnapshot, String, UUID (+1 more)

### Community 38 - "V1 디스크 이전 검증"
Cohesion: 0.4722222222222222
Nodes (9): SchemaMigrationTests, .migrateAndAddPlan(), .testRealV1DiskStoreMigratesToV3AndReopensWithAllRoutineValues(), .verifyRoutine(), .writeV1Fixture(), Date, ModelContainer, URL (+1 more)

### Community 39 - "앱 수명 저장소 개방"
Cohesion: 0.2857142857142857
Nodes (8): App, HanjuApp, .body, PersistenceStore, .open(), ModelContainer, String, Scene

### Community 40 - "현지 시각 값 변환"
Cohesion: 0.2857142857142857
Nodes (8): Codable, .init(), LocalTime, LocalTime.init(hour:minute:), .init(), .label, .minutes, Int

### Community 41 - "네이티브 CI 시간 제한"
Cohesion: 0.2857142857142857
Nodes (8): 공유 scheme과 로컬 테스트, ios.yml, iOS 빌드와 테스트 CI, 네이티브 CI 시간 제한, Hanju.xcscheme, Hanju 공유 실행 테스트 scheme, RoutineLibraryUITests.swift, 편집 시트와 보관 UI 검증

### Community 42 - "실행 강조와 네이티브 색상"
Cohesion: 0.25
Nodes (8): 실행 패널의 연한 강조색, 강조 버튼의 전경 색상, AccentColor.colorset/Contents.json, Background.colorset/Contents.json, Surface.colorset/Contents.json, TextPrimary.colorset/Contents.json, TextSecondary.colorset/Contents.json, 실행 강조와 대비 색상

### Community 43 - "저장 실패 테스트 오류"
Cohesion: 0.2857142857142857
Nodes (7): Error, Failure, disk, Failure, diskFull, Failure, disk

### Community 44 - "디자인 방향과 원문 기준"
Cohesion: 0.6
Nodes (5): 정돈한 생활의 페이지, 01-direction.md, 차분한 숲빛 강조색, 사용자 디자인 원문, user-design-brief.txt

### Community 45 - "선호 요일과 날짜 계약"
Cohesion: 0.4
Nodes (5): 월요일 기준 선호 요일 계약, 선택 입력과 선호 요일 검증, LocalDate.swift, 시간대 독립 계획 날짜, 현지 시각과 DST 설명

### Community 46 - "계획 배분 초안 정의"
Cohesion: 1.0
Nodes (2): PlanDraft.swift, 횟수 배분과 확정 초안

### Community 47 - "에셋 카탈로그 메타데이터"
Cohesion: 1.0
Nodes (1): Assets.xcassets/Contents.json

## Knowledge Gaps
- **261 weakly-connected symbols (degree ≤ 1):** `URL`, `UUID`, `Date`, `{ test }`, `assert` (+256 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 283 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Hanju 네이티브 프로젝트` connect `네이티브 화면과 프로젝트 구성` to `구현 인계와 기반 검증`, `네이티브 CI 시간 제한`, `선호 요일과 날짜 계약`, `계획 배분 초안 정의`, `영속 모델과 저장소 연결`, `실행 시계와 원본 보존`, `같은 회차의 실행 복귀`, `계획 실행 테스트 구성`?**
  _High betweenness centrality (0.345) - this node is a cross-community bridge._
- **Why does `View` connect `오늘 실행과 시간 복구` to `구현 인계와 기반 검증`, `주간 재개와 탭 탐색`, `루틴 목록과 편집 상태`, `실행 제어 화면 상태`, `루틴 선택과 계획 시트`, `계획 조정과 건너뛰기 확인`, `수행일과 시간 편집`, `날짜 입력과 초안 닫기`?**
  _High betweenness centrality (0.091) - this node is a cross-community bridge._
- **Why does `UnsavedChangesGuard` connect `네이티브 시트 닫기 연결` to `루틴 목록과 편집 상태`, `네이티브 화면과 프로젝트 구성`?**
  _High betweenness centrality (0.078) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `LocalDate` (e.g. with `.timeBinding` and `.body`) actually correct?**
  _`LocalDate` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `URL`, `UUID`, `Date` to the rest of the system?**
  _261 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `오늘 실행과 시간 복구` be split into smaller, more focused modules?**
  _Cohesion score 0.06777493606138107 - nodes in this community are weakly interconnected._
- **Should `루틴 목록과 편집 상태` be split into smaller, more focused modules?**
  _Cohesion score 0.05023796932839767 - nodes in this community are weakly interconnected._

## 추출 검증과 한계

- 공유 graph의 source 6a95296983188e3546cd5d62425bcfa05b88bb70에서 병합 main db3a9bfdf9b297446f46084c434ef4bd848511e4로 갱신했다. 입력 84개 중 변경 12개, 같은 SHA256 72개 재사용, 신규·삭제 0개다. 전체 재추출이 아니다.
- 최종 단순 무방향 그래프의 대표 relation/confidence와 보고서 비율은 도구가 선택한 대표 연결 기준이다. 방향은 대표 연결만으로 판단하지 않는다. 모든 연결의 evidence에 원시 source/target/relation/confidence/confidence_score/source_file/source_location/context/rationale/weight/origin 등 존재하는 전체 필드를 보존했다.
- 원시 2249개 관계가 2089개 단순 연결로 합쳐졌다. 동일 endpoint 쌍의 추가 관계 160개와 다중 근거 쌍 109개를 포함해 모든 원시 관계를 전체 필드 Counter 및 순서 없는 endpoint 쌍별 Counter로 검증했다.
- 변경 출처의 AST 수신자 오인 6건을 현재 원문으로 보정했다. CompletionSheet.undo→recorder.undo, PlanAdjustmentSheet.save→PlanWriter.move/rest, skip→PlanWriter.skip, WeekView.resume→recorder.start, ExecutionWriter.commit의 주입 save 분기를 구분했다. 변경 없는 출처의 이전 보정 36건은 해시·전체 관계 보존으로 재검증했다.
- 기존 pr-policy.cjs module.exports의 exports 두 관계 보정은 유지했다. AST는 같은 이름과 일부 첫 호출 위치만 표현하며 모든 SwiftUI modifier/호출 위치를 추출하지 않는다. 변경 출처 밖의 외부/제네릭 타입 노드와 파일 투영을 실제 구현 정의나 순환 의존으로 단정하지 않는다.
- 변경 Swift 8개를 AST 재추출하고 문서·CI 4개를 현재 Codex로 재검증했다. 변경된 의미 노드/관계는 같은 원문 줄을 대조해 새 위치로 옮기고 정책 변화는 현재 근거로 갱신했다. YAML·문서는 AST 호출 추출 대상이 아니다.
- #27: Week의 과거·지난주 paused는 같은 ID·계획 날짜·구간을 유지해 재개하며 저장 성공 뒤 호출 Week stack에 Running을 연다. 다른 running 전환은 확인하고 취소/실패는 호출 날짜·탭과 실행을 보존한다. Running의 복귀 문구는 호출 탭에 맞춘다.
- #27: 수행일 편집은 stale 검증 뒤 현재 저장된 수행일과 동일한 값은 보존한다. 시간대 이동으로 현지 오늘보다 뒤여도 시간만 수정할 수 있다. 다른 새 미래일은 거절한다. DatePicker 상한은 recorder 시계의 오늘과 원본 수행일 중 큰 값이며 civil date를 자동 변경하지 않는다. 이 범위 설정이 모든 중간 미래일의 UI 선택까지 막는다는 뜻은 아니다.
- #27: 이동 시트의 중립 건너뛰기는 복원 모드에서 숨긴다. 취소는 날짜/시각 초안을 보존하고 확정은 원본 source만 skip해 onSaved(nil)로 호출자에게 복귀한다. 현재 unfinished가 생기면 전체 쉬기 문구를 숨기고 남은 skipped 목록은 유지한다.
- #27: iOS build and tests job의 timeout-minutes는 35다. 실제 소요시간·테스트 성공 횟수를 뜻하지 않는다. 테스트 source의 고정 서울/호놀룰루 예제와 앱별 TZ Kiritimati/호놀룰루 UI 재실행 정의는 실제 기기 시간대 인수를 대신하지 않는다.
- #9 실행/V3 record·interval과 #27 흐름 수정은 현재 구현이다. V1/V2 저장 모델 정의는 동결되고 루틴 UI RoutineSnapshot·계획 UI OccurrenceSnapshot과 영속 스냅샷을 구분한다. 전체 주간 Records/메모 #10, 알림 #11, 캘린더 #12, 실기기/전체 접근성 인수 #13은 후속이다.
- 실행 시계의 cold recovery는 고정 launch sample 차이 5초 이하를 허용하는 휴리스틱이며 process UUID는 boot UUID가 아니다. 감지한 불확실성은 recoveryNeedsReview로 영속 보존한다. nil·0·1분 미만·불확실 전체시간을 구분하며 manualThroughSequence 경계 뒤 구간만 더하고 날짜만 편집하면 exact seconds를 유지한다.
- 기획 1.3이 1.2 정책을 대체한다. HTML 프리뷰 1.2·README 기반 설명·기존 기반 검증 snapshot과 implementation-plan의 #8 시점 recorder 후속 문구는 과거 단계다. 현재 #9 구현과 #27 변경은 실제 소스로 재검증했다.
- 최신 협업 규칙은 코드의 독립 Codex 검토와 모든 PR의 최신 head Copilot 완료를 요구한다. 문서/Graphify도 포함한다. 이 그래프 자체가 원격 리뷰 완료 증거는 아니다.
- 테스트 source는 정의와 시나리오의 근거다. 원격 CI/리뷰 결과를 입력하지 않았으며 실행 성공·실기기 인수를 추정하지 않는다. 조건부 UI XCTSkip 정의도 현재 실행 결과로 해석하지 않는다.
- 84개 입력 전체에 출처 노드가 있지만 모든 문장·설정·호출의 완전 추출을 보장하지 않는다. 에셋 카탈로그 Contents.json 메타데이터 하나는 명시 연결 없이 고립돼 있다. 파일 이름이 같아도 source_file로 구분한다.
- 입력은 고정 main tracked 목록이며 archive/skills/.git/graphify 출력/의존 메타데이터/빌드·캐시/비밀·개인 데이터를 제외했다. design/tokens.json의 이름 기반 민감 오탐은 디자인 값임을 확인해 포함했다.
- 보고서는 기본 thin-node 필터 없이 전체 942개 노드와 48개 커뮤니티를 집계한다. 새 구성원을 읽어 한국어 라벨을 작성했고 JSON·라벨·보고서 노드 수를 대조했다.
- 현재 Codex 세션만 의미 추출/라벨링에 사용했다. 모델 ID·토큰·비용은 제공되지 않아 null이며 외부 LLM API는 사용하지 않았다.

- 84/84 입력에 출처 노드 존재, 상대 경로와 실제 줄번호 범위 확인. dangling/missing endpoint·self-loop 0.
- 연결 성분 2, degree 0 노드 1.

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
- `Hanju/Assets.xcassets/AccentSubtle.colorset/Contents.json`
- `Hanju/Assets.xcassets/Background.colorset/Contents.json`
- `Hanju/Assets.xcassets/Contents.json`
- `Hanju/Assets.xcassets/OnAccent.colorset/Contents.json`
- `Hanju/Assets.xcassets/Surface.colorset/Contents.json`
- `Hanju/Assets.xcassets/TextPrimary.colorset/Contents.json`
- `Hanju/Assets.xcassets/TextSecondary.colorset/Contents.json`
- `Hanju/Design/DesignTokens.swift`
- `Hanju/Features/Execution/CompletionSheet.swift`
- `Hanju/Features/Execution/ExecutionClock.swift`
- `Hanju/Features/Execution/ExecutionRecorder.swift`
- `Hanju/Features/Execution/ExecutionSnapshot.swift`
- `Hanju/Features/Execution/ExecutionWriter.swift`
- `Hanju/Features/Execution/RunningRoutineView.swift`
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
- `Hanju/Models/HanjuSchemaV3.swift`
- `Hanju/Models/LocalDate.swift`
- `Hanju/Models/RoutineTemplate.swift`
- `Hanju/Persistence/PersistenceStore.swift`
- `HanjuTests/ExecutionMigrationTests.swift`
- `HanjuTests/ExecutionTests.swift`
- `HanjuTests/RoutineLibraryTests.swift`
- `HanjuTests/RoutinePersistenceTests.swift`
- `HanjuTests/SchemaMigrationTests.swift`
- `HanjuTests/WeekPlanTests.swift`
- `HanjuUITests/ExecutionUITests.swift`
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
- `docs/adr/0002-execution-time-and-recovery.md`
- `docs/development/data-contracts.md`
- `docs/development/graphify.md`
- `docs/development/implementation-plan.md`
- `docs/development/local-development.md`
- `docs/development/planning-revision-1.3.md`
- `docs/development/review-workflow.md`
- `docs/product-plan.md`
- `docs/verification/2026-10-04-foundation.md`
