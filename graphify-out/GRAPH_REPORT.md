> 분석 기준: main `6a95296983188e3546cd5d62425bcfa05b88bb70` · 이슈 #9 · PR #25 병합 후 고정 snapshot.
> 현재 Codex 세션의 의미 추출과 한국어 라벨을 사용했다. 모델·토큰·비용은 알 수 없음.
> 기획 1.3 정책 채택과 앱 구현을 구분한다. 그래프 생성은 전체 MVP 또는 인수 완료를 뜻하지 않는다.

# Graph Report - ptoj  (2026-10-07)

## Corpus Check
- 84 tracked source files; 32 refreshed; 52 hash-verified reuse.

## Summary
- 908 nodes · 2063 edges · 44 communities (all shown)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 111 edges (avg confidence: 0.85)
- Token cost: 알 수 없음 input · 알 수 없음 output

## Graph Freshness
- Built from commit: `6a952969`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- main 병합 뒤에만 현재 AI 세션으로 갱신한다. source_commit 이후 변경은 원문 diff로 확인한다.

## Community Hubs (Navigation)
- 실행 기록과 명령 회귀검증
- 루틴 목록과 편집 상태
- 계획 명령과 원자 저장
- 실행 루틴 계획 UI 검증
- 네이티브 시트 닫기 연결
- 오늘 실행과 탭 탐색
- 이슈 커밋과 PR 정책
- 주간 탐색과 기록 편집
- 동결 스키마와 V3 모델
- 네이티브 화면과 프로젝트 구성
- 계획 선택과 초안 닫기
- 개발 인계와 최신 리뷰
- 지역 날짜와 DST 해석
- 계획 실행 화면 명세
- 제품 원칙과 수행 기록
- 계획 조정과 확인 시트
- 앱 저장소와 기반 검증
- 실제 깃과 훅 회귀검증
- 루틴 저장과 실패 격리
- 계획 실행 테스트 구성
- 계획 조회와 상태 값
- V2 계획 모델 보존
- 기획 개정과 기록 계약
- 구현 인계와 기반 검증
- 루틴 선택 입력 검증
- 날짜 계약과 후속 연동
- 계획 초안과 횟수 배분
- 실행 원자성과 원본 보존
- 실행 저장 오류 안내
- 접근성 기준과 프리뷰 경계
- 계획 입력 오류 유형
- 앱 수명 실행 서비스
- V1 디스크 이전 검증
- 실행 강조와 네이티브 색상
- 영속 스냅샷과 V3 이전
- 계획 날짜 입력 바인딩
- 현지 시각 값 변환
- 저장 실패 테스트 오류
- 루틴 디스크 보존 검증
- 실행 시계와 복구 결정
- 오늘 실행과 UI 검증
- 디자인 방향과 원문 기준
- 선호 요일과 날짜 계약

## God Nodes (most connected - your core abstractions)
1. `Hanju 네이티브 프로젝트` - 43 edges
2. `ExecutionSnapshot` - 40 edges
3. `LocalDate` - 30 edges
4. `한 주 iPhone MVP` - 28 edges
5. `WeekView` - 27 edges
6. `RoutineEditorSheet` - 25 edges
7. `WeeklySelectionSheet` - 24 edges
8. `ExecutionClock` - 24 edges
9. `SwiftData` - 20 edges
10. `RoutineDraft` - 20 edges

## Surprising Connections (you probably didn't know these)
- `RoutineTemplate` --implements--> `RoutineTemplate`  [EXTRACTED]
  design/04-screens.md → Hanju/Models/HanjuSchemaV1.swift
- `iOS 17 Swift 6 기반 채택` --implements--> `HanjuApp`  [EXTRACTED]
  docs/adr/0001-native-ios-foundation.md → Hanju/App/HanjuApp.swift
- `버전 스키마와 로컬 저장` --implements--> `PersistenceStore`  [EXTRACTED]
  docs/adr/0001-native-ios-foundation.md → Hanju/Persistence/PersistenceStore.swift
- `실행 구현과 후속 기능 경계` --implements--> `LibraryView`  [EXTRACTED]
  docs/development/implementation-plan.md → Hanju/Features/Library/LibraryView.swift
- `실행 구현과 후속 기능 경계` --references--> `루틴 목록과 편집 값 복사`  [EXTRACTED]
  docs/development/implementation-plan.md → Hanju/Features/Library/RoutineSnapshot.swift

## Import Cycles

아래는 참조 사용 위치를 정의 파일로 취급한 도구의 파일 투영 결과가 포함될 수 있다. 외부 모듈·제네릭 타입의 source_file은 사용 근거이며 실제 코드 순환을 의미하지 않는다.
- 1-file cycle: `.github/scripts/pr-policy.test.cjs -> .github/scripts/pr-policy.test.cjs`
- 1-file cycle: `.githooks/commit-msg -> .githooks/commit-msg`

## Communities (44 total, all shown)

모든 수치는 graph.json의 전체 노드를 기준으로 한다. 파일·심볼·개념 노드를 제외하지 않으며, 각 목록은 이름 8개만 미리 표시한다.

| ID | 공통 라벨 | JSON·보고서 전체 노드 수 |
| --- | --- | ---: |
| 0 | 실행 기록과 명령 회귀검증 | 105 |
| 1 | 루틴 목록과 편집 상태 | 61 |
| 2 | 계획 명령과 원자 저장 | 48 |
| 3 | 실행 루틴 계획 UI 검증 | 42 |
| 4 | 네이티브 시트 닫기 연결 | 39 |
| 5 | 오늘 실행과 탭 탐색 | 37 |
| 6 | 이슈 커밋과 PR 정책 | 35 |
| 7 | 주간 탐색과 기록 편집 | 34 |
| 8 | 동결 스키마와 V3 모델 | 33 |
| 9 | 네이티브 화면과 프로젝트 구성 | 30 |
| 10 | 계획 선택과 초안 닫기 | 28 |
| 11 | 개발 인계와 최신 리뷰 | 26 |
| 12 | 지역 날짜와 DST 해석 | 23 |
| 13 | 계획 실행 화면 명세 | 23 |
| 14 | 제품 원칙과 수행 기록 | 22 |
| 15 | 계획 조정과 확인 시트 | 21 |
| 16 | 앱 저장소와 기반 검증 | 20 |
| 17 | 실제 깃과 훅 회귀검증 | 17 |
| 18 | 루틴 저장과 실패 격리 | 17 |
| 19 | 계획 실행 테스트 구성 | 16 |
| 20 | 계획 조회와 상태 값 | 16 |
| 21 | V2 계획 모델 보존 | 16 |
| 22 | 기획 개정과 기록 계약 | 15 |
| 23 | 구현 인계와 기반 검증 | 15 |
| 24 | 루틴 선택 입력 검증 | 15 |
| 25 | 날짜 계약과 후속 연동 | 12 |
| 26 | 계획 초안과 횟수 배분 | 12 |
| 27 | 실행 원자성과 원본 보존 | 12 |
| 28 | 실행 저장 오류 안내 | 12 |
| 29 | 접근성 기준과 프리뷰 경계 | 11 |
| 30 | 계획 입력 오류 유형 | 10 |
| 31 | 앱 수명 실행 서비스 | 9 |
| 32 | V1 디스크 이전 검증 | 9 |
| 33 | 실행 강조와 네이티브 색상 | 8 |
| 34 | 영속 스냅샷과 V3 이전 | 8 |
| 35 | 계획 날짜 입력 바인딩 | 7 |
| 36 | 현지 시각 값 변환 | 7 |
| 37 | 저장 실패 테스트 오류 | 7 |
| 38 | 루틴 디스크 보존 검증 | 7 |
| 39 | 실행 시계와 복구 결정 | 6 |
| 40 | 오늘 실행과 UI 검증 | 6 |
| 41 | 디자인 방향과 원문 기준 | 5 |
| 42 | 선호 요일과 날짜 계약 | 5 |
| 43 | 에셋 카탈로그 메타데이터 | 1 |
| 합계 | 44개 커뮤니티 | 908 |

### Community 0 - "실행 기록과 명령 회귀검증"
Cohesion: 0.05952380952380952
Nodes (105): CompletionSheet, .body, .dateBinding, .dirty, .init(), .save(), .undo(), Binding (+97 more)

### Community 1 - "루틴 목록과 편집 상태"
Cohesion: 0.05081967213114754
Nodes (61): Binding, SwiftUI DismissAction.callAsFunction, PendingAction, archive, dismiss, RecoveryAction, archive, save (+53 more)

### Community 2 - "계획 명령과 원자 저장"
Cohesion: 0.12322695035460993
Nodes (48): .save(), ModelContext.fetch, PlanWriter, .check(), .commit(), .confirm(), .fetch(), .find() (+40 more)

### Community 3 - "실행 루틴 계획 UI 검증"
Cohesion: 0.13472706155632985
Nodes (42): ExecutionUITests, .cancel(), .createTodayPlans(), .pickDate(), .reveal(), .testDirectCompletionEditCancellationZeroTimeAndUndo(), .testPriorWeekDirectCompletionAndPerformedDateCorrectionKeepPlanInPlace(), .testRunningRestStopsAndRestoreRetainsMeasuredHistory() (+34 more)

### Community 4 - "네이티브 시트 닫기 연결"
Cohesion: 0.08097165991902834
Nodes (39): Any, Context, Coordinator, .attach(), .detach(), .forwardingTarget(), .presentationControllerDidAttemptToDismiss(), .presentationControllerDidDismiss() (+31 more)

### Community 5 - "오늘 실행과 탭 탐색"
Cohesion: 0.1021021021021021
Nodes (37): Actions, AppTabs, .body, .emptyScreen(), String, Tab, library, records (+29 more)

### Community 6 - "이슈 커밋과 PR 정책"
Cohesion: 0.0773109243697479
Nodes (35): 이슈 연결 Git 규칙, 이슈부터 시작, PR 정책과 main 보호, commit-msg, Validate project commit conventions without third-party dependencies., rebase 원래 브랜치 검증, reject(), bug.md (+27 more)

### Community 7 - "주간 탐색과 기록 편집"
Cohesion: 0.1051693404634581
Nodes (34): Editor, Editor, Focus, day, plan, rest, row, Kind (+26 more)

### Community 8 - "동결 스키마와 V3 모델"
Cohesion: 0.07954545454545454
Nodes (33): HanjuSchemaV1, .models, .versionIdentifier, RoutineTemplate, .init(), Bool, Date, String (+25 more)

### Community 9 - "네이티브 화면과 프로젝트 구성"
Cohesion: 0.11954022988505747
Nodes (30): CGFloat, AppTabs.swift, 탭 탐색과 실행 연결, HanjuApp.swift, 앱 수명 실행 환경 주입, DesignTokens.swift, DesignTokens, CompletionSheet.swift (+22 more)

### Community 10 - "계획 선택과 초안 닫기"
Cohesion: 0.1164021164021164
Nodes (28): Content, PlanDismissal, .body(), Void, DayWorkload, .label(), Binding, Bool (+20 more)

### Community 11 - "개발 인계와 최신 리뷰"
Cohesion: 0.1753846153846154
Nodes (26): 에이전트 파일 소유권, 모든 PR 최신 Copilot 확인, AGENTS.md, CONTRIBUTING.md, 독립 리뷰와 Copilot 대기, 05-swiftui-handoff.md, 채택 기술 구성, index.html (+18 more)

### Community 12 - "지역 날짜와 DST 해석"
Cohesion: 0.1422924901185771
Nodes (23): Calendar, Comparable, .body, .timeBinding, .lastDay, LocalDate, .adding(), .calendar() (+15 more)

### Community 13 - "계획 실행 화면 명세"
Cohesion: 0.13438735177865613
Nodes (23): ActiveRoutinePanel, CalendarSyncState, 03-components.md, WeekDaySelector, CalendarSheet 주별 연결, Routine Editor 편집 시트, ExecutionRecord, 04-screens.md (+15 more)

### Community 14 - "제품 원칙과 수행 기록"
Cohesion: 0.1645021645021645
Nodes (22): 중요 기술 결정 ADR, WeekMemo 입력, Records 행동 우선 기록, Settings 설정 화면, AC-05 직접 완료와 수행일 정정, AC-06 알림, AC-09 주간 메모, AC-10 행동 우선 기록과 주 경계 (+14 more)

### Community 15 - "계획 조정과 확인 시트"
Cohesion: 0.12857142857142856
Nodes (21): Mode, move, recovery, rest, PlanAdjustmentSheet, .body, .canSave, .dirty (+13 more)

### Community 16 - "앱 저장소와 기반 검증"
Cohesion: 0.14210526315789473
Nodes (20): App, HanjuApp, .body, PersistenceStore, .makeContainer(), .open(), Bool, ModelContainer (+12 more)

### Community 17 - "실제 깃과 훅 회귀검증"
Cohesion: 0.38235294117647056
Nodes (17): CommitMessageHookTests, .assert_rejected(), .commit(), .conflicting_history(), .git(), .invoke_hook(), .reword(), .setUp() (+9 more)

### Community 18 - "루틴 저장과 실패 격리"
Cohesion: 0.2867647058823529
Nodes (17): ModelContext.fetch, RoutineWriter, .commit(), .create(), .fetch(), .find(), .optionalText(), .persist() (+9 more)

### Community 19 - "계획 실행 테스트 구성"
Cohesion: 0.19166666666666668
Nodes (16): Foundation, Hanju, PlanDraft.swift, 횟수 배분과 확정 초안, ExecutionMigrationTests.swift, ExecutionTests.swift, 실행 시간과 날짜 회귀검증, RoutineLibraryTests.swift (+8 more)

### Community 20 - "계획 조회와 상태 값"
Cohesion: 0.14166666666666666
Nodes (16): OccurrenceSnapshot, .canReplan, .init(), .isUnfinished, .statusLabel, Status, completed, paused (+8 more)

### Community 21 - "V2 계획 모델 보존"
Cohesion: 0.20833333333333334
Nodes (16): HanjuSchemaV2, .models, .versionIdentifier, PlannedOccurrence, .init(), Bool, Date, Int (+8 more)

### Community 22 - "기획 개정과 기록 계약"
Cohesion: 0.1619047619047619
Nodes (15): CompletionSheet 수행일 편집, ReplanEntry 복귀 진입, RestWeekAction 쉬기 확인, 실제 공유 UI 추출, 기능별 폴더 구조, 수행일 집계 저장 계약, 같은 회차 재계획 계약, 일괄 쉬기와 실행 원자 저장 (+7 more)

### Community 23 - "구현 인계와 기반 검증"
Cohesion: 0.1619047619047619
Nodes (15): 실행 구현과 후속 인계, 변경 초안 swipe 확인 구현, implementation-plan.md, 실행 구현과 후속 기능 경계, 공유 scheme과 로컬 테스트, 2026-10-04-foundation.md, 기반 네이티브 검증 기록, ios.yml (+7 more)

### Community 24 - "루틴 선택 입력 검증"
Cohesion: 0.23809523809523808
Nodes (15): Field, expectedMinutes, firstAction, name, note, weekdays, weeklyFrequency, RoutineDraft (+7 more)

### Community 25 - "날짜 계약과 후속 연동"
Cohesion: 0.22727272727272727
Nodes (12): 초안 보존과 저장 결과, 캘린더 연결과 쓰기 직렬화, 캘린더 중단 후 복구 계약, LocalDate와 DST 해석, 주 이동별 캘린더 조정, data-contracts.md, V3 실행과 후속 연동 계약, 알림 예약과 종료 중 한계 (+4 more)

### Community 26 - "계획 초안과 횟수 배분"
Cohesion: 0.3333333333333333
Nodes (12): Equatable, Entry, .init(), PlanDraft, .allocate(), .validate(), .validateCounts(), Int (+4 more)

### Community 27 - "실행 원자성과 원본 보존"
Cohesion: 0.18181818181818182
Nodes (12): ExecutionSnapshot.swift, 미기록과 불확실 시간 구분, ExecutionWriter.swift, 단일 실행과 저장 원자성, 완료 날짜와 재완료 수명, 수동 시간의 적용 경계, 복구 불확실성 영속 보존, PlanWriter.swift (+4 more)

### Community 28 - "실행 저장 오류 안내"
Cohesion: 0.16666666666666666
Nodes (12): ExecutionError, anotherRunning, changed, .errorDescription, futureDate, invalidData, invalidMinutes, String (+4 more)

### Community 29 - "접근성 기준과 프리뷰 경계"
Cohesion: 0.21818181818181817
Nodes (11): 처음부터 접근성 지원, 의미 있는 대비 기준, 02-foundations.md, 한국어 시스템 서체, 기획 1.2 프리뷰 경계, 네이티브 검증 계약, 지정 색 조합 대비 결과, contrast-report.json (+3 more)

### Community 30 - "계획 입력 오류 유형"
Cohesion: 0.2
Nodes (10): PlanError, batchLimit, changedOccurrence, .errorDescription, inactiveRoutine, invalidDate, invalidDraft, invalidStoredData (+2 more)

### Community 31 - "앱 수명 실행 서비스"
Cohesion: 0.2777777777777778
Nodes (9): ExecutionRecorder.swift, 앱 수명 실행 명령, RoutineListView.swift, PlanAdjustmentSheet.swift, 계획 변경과 실행 갱신, PersistenceStore.swift, V3 저장소와 실행 수명, Observation (+1 more)

### Community 32 - "V1 디스크 이전 검증"
Cohesion: 0.4722222222222222
Nodes (9): SchemaMigrationTests, .migrateAndAddPlan(), .testRealV1DiskStoreMigratesToV3AndReopensWithAllRoutineValues(), .verifyRoutine(), .writeV1Fixture(), Date, ModelContainer, URL (+1 more)

### Community 33 - "실행 강조와 네이티브 색상"
Cohesion: 0.25
Nodes (8): 실행 패널의 연한 강조색, 강조 버튼의 전경 색상, AccentColor.colorset/Contents.json, Background.colorset/Contents.json, Surface.colorset/Contents.json, TextPrimary.colorset/Contents.json, TextSecondary.colorset/Contents.json, 실행 강조와 대비 색상

### Community 34 - "영속 스냅샷과 V3 이전"
Cohesion: 0.25
Nodes (8): OccurrenceSnapshot.swift, 계획 화면 값 복사, HanjuSchemaV2.swift, 동결 모델과 V3 이전, 계획 항목의 영속 스냅샷, HanjuSchemaV3.swift, 회차별 실행 기록 모델, V2 이전과 복구 영속 검증

### Community 35 - "계획 날짜 입력 바인딩"
Cohesion: 0.2857142857142857
Nodes (7): ClosedRange, PlanDateFields, .dateBinding, .hasTime, Binding, Bool, Date

### Community 36 - "현지 시각 값 변환"
Cohesion: 0.3333333333333333
Nodes (7): Codable, LocalTime, LocalTime.init(hour:minute:), .init(), .label, .minutes, Int

### Community 37 - "저장 실패 테스트 오류"
Cohesion: 0.2857142857142857
Nodes (7): Error, Failure, disk, Failure, diskFull, Failure, disk

### Community 38 - "루틴 디스크 보존 검증"
Cohesion: 0.3333333333333333
Nodes (7): RoutineLibraryTests, .exerciseStore(), .testAllOptionalFieldsEditArchiveRestoreAndReopen(), .testRevertingEveryDraftFieldRestoresCleanEquality(), Date, URL, XCTestCase

### Community 39 - "실행 시계와 복구 결정"
Cohesion: 0.3333333333333333
Nodes (6): Darwin, 실행 시계와 복구 결정, V3 실행 저장 계약, ExecutionClock.swift, 재실행 시계 비교 한계, 수면 포함 실행 시계

### Community 40 - "오늘 실행과 UI 검증"
Cohesion: 0.3333333333333333
Nodes (6): RunningRoutineView.swift, 실행 제어와 시간 표시, TodayView.swift, 오늘 실행과 수행일 완료, ExecutionUITests.swift, 실행 완료와 복원 UI 검증

### Community 41 - "디자인 방향과 원문 기준"
Cohesion: 0.6
Nodes (5): 정돈한 생활의 페이지, 01-direction.md, 차분한 숲빛 강조색, 사용자 디자인 원문, user-design-brief.txt

### Community 42 - "선호 요일과 날짜 계약"
Cohesion: 0.4
Nodes (5): 월요일 기준 선호 요일 계약, 선택 입력과 선호 요일 검증, LocalDate.swift, 시간대 독립 계획 날짜, 현지 시각과 DST 설명

### Community 43 - "에셋 카탈로그 메타데이터"
Cohesion: 1.0
Nodes (1): Assets.xcassets/Contents.json

## Knowledge Gaps
- **251 weakly-connected symbols (degree ≤ 1):** `URL`, `UUID`, `Date`, `{ test }`, `assert` (+246 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 272 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Hanju 네이티브 프로젝트` connect `네이티브 화면과 프로젝트 구성` to `영속 스냅샷과 V3 이전`, `실행 시계와 복구 결정`, `오늘 실행과 UI 검증`, `선호 요일과 날짜 계약`, `계획 실행 테스트 구성`, `구현 인계와 기반 검증`, `실행 원자성과 원본 보존`, `앱 수명 실행 서비스`?**
  _High betweenness centrality (0.341) - this node is a cross-community bridge._
- **Why does `View` connect `오늘 실행과 탭 탐색` to `실행 기록과 명령 회귀검증`, `루틴 목록과 편집 상태`, `계획 날짜 입력 바인딩`, `주간 탐색과 기록 편집`, `계획 선택과 초안 닫기`, `계획 조정과 확인 시트`?**
  _High betweenness centrality (0.094) - this node is a cross-community bridge._
- **Why does `ExecutionSnapshot` connect `실행 기록과 명령 회귀검증` to `계획 초안과 횟수 배분`, `실행 원자성과 원본 보존`, `오늘 실행과 탭 탐색`, `주간 탐색과 기록 편집`?**
  _High betweenness centrality (0.081) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `LocalDate` (e.g. with `.timeBinding` and `.body`) actually correct?**
  _`LocalDate` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `URL`, `UUID`, `Date` to the rest of the system?**
  _251 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `실행 기록과 명령 회귀검증` be split into smaller, more focused modules?**
  _Cohesion score 0.05952380952380952 - nodes in this community are weakly interconnected._
- **Should `루틴 목록과 편집 상태` be split into smaller, more focused modules?**
  _Cohesion score 0.05081967213114754 - nodes in this community are weakly interconnected._

## 추출 검증과 한계

- 공유 graph의 source 29dbb87aa32e277a831718fe0ce7ec9763b818a7에서 병합 main 6a95296983188e3546cd5d62425bcfa05b88bb70로 갱신했다. 입력 84개 중 변경·추가 32개(신규 13개), 같은 SHA256 52개 재사용, 삭제 0개다. 전체 재추출이 아니다.
- 최종 단순 무방향 그래프의 대표 relation/confidence와 보고서 비율은 도구가 선택한 대표 연결 기준이다. 방향은 대표 연결만으로 판단하지 않는다. 모든 연결의 evidence에 원시 source/target/relation/confidence/confidence_score/source_file/source_location/context/rationale/weight/origin 등 존재하는 전체 필드를 보존했다.
- 원시 2218개 관계가 2063개 단순 연결로 합쳐졌다. 동일 endpoint 쌍의 추가 관계 155개와 다중 근거 쌍 106개를 포함해 모든 원시 관계를 전체 필드 Counter 및 순서 없는 endpoint 쌍별 Counter로 검증했다.
- 새 AST 수신자 오인 20건을 원문으로 보정했다. recorder→writer, 화면 helper→recorder, Mode enum→PlanWriter, ModelContext.fetch와 테스트 helper를 구분했다. 주입 save를 CompletionSheet/PlanAdjustmentSheet.save로 잘못 연결한 항목은 실제 주입/ModelContext 분기에 연결했다. 변경 없는 출처의 이전 보정 20건도 재검증해 유지했다.
- 기존 pr-policy.cjs module.exports의 exports 두 관계 보정은 유지했다. AST는 같은 이름과 일부 첫 호출 위치만 표현하며 모든 SwiftUI modifier/호출 위치를 추출하지 않는다. PlanWriter.confirm의 두 transaction.fetch도 L21 하나로 표현된다.
- AST 외부/제네릭 타입·API 노드의 출처는 정의가 아닌 사용 근거다. 증분 AST 범위 밖 타입이 일반 참조로 남을 수 있어 주요 실행/저장/모델 연결은 원문 의미 근거로 보완했다. 파일 투영을 실제 순환 의존으로 단정하지 않는다.
- 변경 Swift 21개를 AST 재추출하고 문서·프로젝트·asset 11개를 현재 Codex로 재검증했다. Xcode/scheme·YAML·JSON은 AST 호출 그래프 대상이 아니다. 문서의 변경된 줄과 의미를 현재 source로 갱신했다.
- #9 실행 타이머·직접/늦은 완료·기록 시간/수행일 정정·단일 running·전환/쉬기/이동 원자 저장은 현재 구현이다. V1/V2 저장 모델을 재사용하는 V3 record/interval을 추가했으며 V1/V2의 저장 정의는 동결됐다.
- 실행 시계는 Date 관측 사실과 수면 포함 CLOCK_MONOTONIC_RAW를 구분한다. cold recovery는 고정 launch sample의 차이 5초 이하를 허용하는 휴리스틱이며 process UUID는 boot UUID가 아니다. 감지한 불확실성은 recoveryNeedsReview로 영속 보존해 다음 재실행의 시각 일치로 사라지지 않는다.
- 미기록 nil·확정 0·1분 미만·불확실 전체시간을 구별한다. 불확실 전체 seconds는 nil이며 knownSeconds는 별도 부분합이다. 수동 정정은 manualThroughSequence 경계까지 대체하고 원본 구간을 지우지 않는다. 날짜만 정정하면 exact seconds·수동값·완료 입력 사실을 유지한다.
- 전체 주간 Records/메모 #10, 알림 #11, 캘린더 #12, 실제 기기 잠금/종료/재부팅과 전체 접근성 인수 #13은 후속이다. 현재 그래프가 전체 MVP 인수를 뜻하지 않는다. source 문서의 #8 담당 절에 남은 recorder 미구현 설명은 당시 단계의 경계이며 최신 #9 절과 실제 소스가 현재 상태다.
- 기획 1.3이 1.2 정책을 대체한다. HTML 프리뷰 1.2·README 기반 설명·기존 기반 검증 snapshot은 과거 단계다. 루틴 UI RoutineSnapshot·계획 UI OccurrenceSnapshot과 영속 PlannedOccurrence/ExecutionRecord를 구분한다.
- 최신 협업 규칙은 코드의 독립 Codex 검토와 모든 PR의 최신 head Copilot 완료를 요구한다. 문서/Graphify도 포함한다. Copilot 무응답 시 독립 Codex만으로 병합하지 않는다. 이 그래프 자체가 원격 리뷰 완료의 증거는 아니다.
- 테스트 source는 정의와 시나리오의 근거다. 현재 PR의 원격 CI/리뷰 결과는 입력으로 포함하지 않았으며 실행 성공·실기기 인수를 추정하지 않는다. 과거 source의 조건부 UI skip 정의도 현재 실행 결과로 해석하지 않는다.
- 84개 입력 전체에 출처 노드가 있으나 모든 문장·설정·호출의 완전한 추출을 보장하지 않는다. 에셋 카탈로그의 Contents.json 메타데이터 하나는 명시 연결 없이 고립돼 있다. 파일 이름이 같아도 source_file로 구분한다.
- 입력은 고정 main tracked 목록으로 산출하고 archive/skills/.git/graphify 출력/의존 메타데이터/빌드·캐시/비밀·개인 데이터를 제외했다. design/tokens.json의 이름 기반 민감 오탐은 디자인 값임을 확인해 포함했다.
- 보고서는 기본 thin-node 필터 없이 전체 908개 노드와 44개 커뮤니티를 모두 집계한다. 새 구성원으로 한국어 라벨을 작성했고 JSON·라벨·보고서 전체 노드 수를 대조했다. cohesion은 전체 그래프 원시 값이다.
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
