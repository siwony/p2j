# 프로젝트 지식 그래프

분석 기준: main `cd3cc7359cf2410980a276319a83e08bd9341675` · 이슈 #10 · PR #33 · Graphify 0.9.68.

## 전체 집계

입력 **94개**(코드 54개, 문서·설정 40개), 노드 **1125개**, 원시 관계 **2935개**, 무방향 연결 **2752개**, 커뮤니티 **54개**다. 고립 노드 1개, 차수 0 또는 1인 노드 315개다.

표와 각 커뮤니티의 노드 수는 graph.json의 전체 membership 기준이다. 파일 hub·AST 멤버·외부 타입을 제외하는 기본 thin 필터는 사용하지 않았다. 응집도는 설치된 Graphify score_all의 전체 membership 계산값이다.

## 이번 분석의 의미

이전 main `4ca809386b54dd90e728fc7545846589b1c82deb`의 완전한 원시 캐시와 원문 SHA256을 확인해 증분 분석했다. 파일 73개는 동일하고 11개가 수정됐으며 10개가 추가됐다. 삭제는 없다. 원시 관계 1881개를 모든 필드·방향과 함께 보존했다. Swift 15개를 불변 AST 문맥으로 재추출하고 문서·설정 6개를 현재 Codex로 다시 해석했다. 오래된 native manifest는 사용하지 않았다.

주간 Records는 완료 상태의 실제 performedOn으로 묶고 같은 회차를 중복 집계하지 않는다. 루틴 ID와 당시 snapshot 이름으로 실천 횟수를 보여준다. 시간 미기록·0초·1분 미만·복구 불확실을 구분하고 확정 시간만 합산하며 overflow 시 부분 합계를 전체처럼 표시하지 않는다. 원본 계획 날짜와 완료 입력시각은 수행일 정정과 구분한다.

V4는 V1–V3 영속 정의를 재사용하고 주별 메모와 최초 실제 날짜 이동 근거를 추가한다. 이전 기록의 이동 여부를 만들어내지 않으며 move/replan/restore에서 실제 날짜가 바뀔 때만 근거를 같은 저장으로 남긴다. 메모는 공백·개행·빈 clear를 보존하고 주별 draft·500ms 세대 확인·focus/scene/탭/주 이동 flush와 실패 원문 재시도를 제공한다. 첫 읽기 실패는 빈 원문으로 덮어쓰지 못한다. 계획 진입의 이전 메모는 선택적 참고이고 취소는 Records 호출자와 초안을 보존한다.

이전 명시 agenda·동일 날짜 UUID·계획 취소 상세 보존과 타이머 독립성은 유지된다. iOS CI 정의의 제한은 55분이다. #10은 구현되었지만 알림 #11, 캘린더 #12, 실기기와 전체 인수 #13은 후속이다. 이 분석은 테스트 정의를 읽었으며 앱 테스트·원격 CI 성공을 재검증하지 않았다.

## 이전 결과와 대응

노드 926→1125개, 원시 관계 2384→2935개, 연결 2226→2752개, 커뮤니티 46→54개다. placeholder helper와 전용 타입 사용 노드 3개는 실제 RecordsView 대체로 빠졌으며 WeekView의 타입 stub 2개는 실제 중첩 enum으로 해석했다. 이전 5노드·관련 관계·대체 근거와 신규 204노드 ID는 provenance.json에 보존했다. 동일 원문 관계 1881개와 새 원본 AST 856개 전체를 Counter로 검증하며, 교정 전 payload도 남긴다. 강제 export는 사용하지 않았다.

## 커뮤니티 전체 목록

| ID | 이름 | 전체 노드 | 응집도 |
|---:|---|---:|---:|
| 0 | 실행 시간과 기록 회귀 | 114 | 0.061015 |
| 1 | 주간 기록과 메모 상태 | 83 | 0.055833 |
| 2 | 계획 명령과 이전 검증 | 73 | 0.072298 |
| 3 | 루틴 편집과 목록 상태 | 60 | 0.052542 |
| 4 | 닫기 시도와 UIKit 위임 | 39 | 0.080972 |
| 5 | 커밋 훅과 Git 검증 | 33 | 0.136364 |
| 6 | 버전 스키마와 V4 모델 | 33 | 0.083333 |
| 7 | 실행 원본과 시간 계약 | 28 | 0.087302 |
| 8 | 주간 선택과 참고 메모 | 28 | 0.113757 |
| 9 | 네이티브 파일과 프로젝트 연결 | 27 | 0.136752 |
| 10 | 화면 계약과 계획 탐색 | 25 | 0.123333 |
| 11 | 제품 범위와 기록 정책 | 24 | 0.152174 |
| 12 | 앱 저장소와 루틴 영속 | 22 | 0.134199 |
| 13 | 저장 검증과 메모 세대 | 22 | 0.160173 |
| 14 | 이번 주 실행과 복귀 | 22 | 0.212121 |
| 15 | 개발 협업과 리뷰 규칙 | 21 | 0.142857 |
| 16 | 루틴 저장과 실패 검증 | 21 | 0.223810 |
| 17 | 계획 조정과 시트 상태 | 20 | 0.136842 |
| 18 | 실행 탐색 화면 검증 | 20 | 0.263158 |
| 19 | 제품 방향과 기술 기반 | 18 | 0.241830 |
| 20 | 루틴 편집 화면 검증 | 18 | 0.372549 |
| 21 | 지역 날짜와 시간대 해석 | 17 | 0.176471 |
| 22 | 기능 인계와 CI 정의 | 17 | 0.139706 |
| 23 | 오늘 실행과 완료 동작 | 17 | 0.308824 |
| 24 | 계획 회차와 상태 판단 | 17 | 0.125000 |
| 25 | V4 기록과 메모 계약 | 16 | 0.183333 |
| 26 | 루틴 초안과 입력 검증 | 16 | 0.216667 |
| 27 | 실행 수명과 계획 연동 | 15 | 0.142857 |
| 28 | 재계획과 기록 인수 계약 | 14 | 0.175824 |
| 29 | PR 정책과 자동 검사 | 14 | 0.197802 |
| 30 | 명시 요청과 호출자 구분 | 14 | 0.175824 |
| 31 | 동결 모델과 이전 검증 | 14 | 0.241758 |
| 32 | 주간 계획 화면 검증 | 14 | 0.340659 |
| 33 | 날짜 입력과 닫기 동작 | 13 | 0.153846 |
| 34 | 하단 탭과 루틴 진입 | 13 | 0.166667 |
| 35 | 수행일 편집과 완료 취소 | 13 | 0.179487 |
| 36 | 주간 기록 화면 검증 | 13 | 0.333333 |
| 37 | 실행 오류와 저장 경계 | 12 | 0.166667 |
| 38 | 접근성과 디자인 토큰 | 11 | 0.218182 |
| 39 | 저장 실패 테스트 대역 | 11 | 0.181818 |
| 40 | 명시 목록과 상세 보존 | 11 | 0.200000 |
| 41 | 생활 시각과 해석 결과 | 10 | 0.244444 |
| 42 | 후속 연동과 날짜 계약 | 10 | 0.288889 |
| 43 | 계획 초안과 횟수 배분 | 10 | 0.444444 |
| 44 | 기록 조회와 메모 저장 | 10 | 0.222222 |
| 45 | 계획 오류와 입력 제한 | 10 | 0.200000 |
| 46 | 실행 강조와 색상 에셋 | 8 | 0.250000 |
| 47 | 동결 루틴 원본 모델 | 8 | 0.357143 |
| 48 | 주간 날짜와 이전 메모 | 6 | 0.333333 |
| 49 | 수행일 보존과 선택 범위 | 5 | 0.400000 |
| 50 | 선호 요일과 날짜 계약 | 5 | 0.400000 |
| 51 | 주간 화면 접근성 초점 | 5 | 0.400000 |
| 52 | 오늘 화면 편집 분기 | 4 | 0.500000 |
| 53 | 에셋 카탈로그 메타데이터 | 1 | 1.000000 |

### 0. 실행 시간과 기록 회귀

전체 노드: **114개** · 응집도: **0.061015**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/ExecutionTests.swift`, `HanjuTests/RecordsTests.swift`.

구성 예시: `ExecutionClock`, `.elapsed()`, `.now()`, `Sample`, `Date`, `Double`, `Int64`, `UUID`, `ExecutionRecorder`, `.complete()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 1. 주간 기록과 메모 상태

전체 노드: **83개** · 응집도: **0.055833**.

출처: `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Records/RecordsSnapshot.swift`, `Hanju/Features/Records/RecordsStore.swift`, `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `HanjuTests/RecordsMigrationTests.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

구성 예시: `.now()`, `RecordedTimeSummary`, `RoutineCount`, `.id`, `Bool`, `Double`, `ExecutionSnapshot`, `Int`, `LocalDate`, `Set`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 2. 계획 명령과 이전 검증

전체 노드: **73개** · 응집도: **0.072298**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `HanjuTests/RecordsMigrationTests.swift`, `HanjuTests/WeekPlanTests.swift`.

구성 예시: `.save()`, `ModelContext.fetch`, `PlanWriter`, `.check()`, `.commit()`, `.confirm()`, `.fetch()`, `.find()`, `.markSkipped()`, `.move()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 3. 루틴 편집과 목록 상태

전체 노드: **60개** · 응집도: **0.052542**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Library/RoutineEditorSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineSnapshot.swift`.

구성 예시: `SwiftUI DismissAction.callAsFunction`, `PendingAction`, `archive`, `dismiss`, `RecoveryAction`, `archive`, `save`, `RoutineEditorSheet`, `.archive()`, `.body`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 4. 닫기 시도와 UIKit 위임

전체 노드: **39개** · 응집도: **0.080972**.

출처: `Hanju/Features/Library/UnsavedChangesGuard.swift`.

구성 예시: `Any`, `Context`, `Coordinator`, `.attach()`, `.detach()`, `.forwardingTarget()`, `.presentationControllerDidAttemptToDismiss()`, `.presentationControllerDidDismiss()`, `.presentationControllerShouldDismiss()`, `.presentationControllerWillDismiss()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 5. 커밋 훅과 Git 검증

전체 노드: **33개** · 응집도: **0.136364**.

출처: `.githooks/commit-msg`, `.github/scripts/test_commit_msg.py`.

구성 예시: `commit-msg`, `Validate project commit conventions without third-party dependencies.`, `rebase 원래 브랜치 검증`, `reject()`, `test_commit_msg.py`, `CommitMessageHookTests`, `.assert_rejected()`, `.commit()`, `.conflicting_history()`, `.git()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 6. 버전 스키마와 V4 모델

전체 노드: **33개** · 응집도: **0.083333**.

출처: `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `Hanju/Models/HanjuSchemaV4.swift`.

구성 예시: `HanjuMigrationPlan`, `.schemas`, `.stages`, `ExecutionInterval`, `.init()`, `ExecutionRecord`, `.init()`, `HanjuSchemaV3`, `.models`, `.versionIdentifier`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 7. 실행 원본과 시간 계약

전체 노드: **28개** · 응집도: **0.087302**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Records/RecordsSnapshot.swift`, `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `HanjuTests/ExecutionTests.swift`, `HanjuTests/WeekPlanTests.swift`, `docs/adr/0002-execution-time-and-recovery.md`, `docs/development/data-contracts.md`.

구성 예시: `Darwin`, `실행 시계와 복구 결정`, `V3 실행 저장 계약`, `Foundation`, `ExecutionClock.swift`, `재실행 시계 비교 한계`, `수면 포함 실행 시계`, `ExecutionSnapshot.swift`, `미기록과 불확실 시간 구분`, `ExecutionWriter.swift`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 8. 주간 선택과 참고 메모

전체 노드: **28개** · 응집도: **0.113757**.

출처: `Hanju/Features/Week/WeeklySelectionSheet.swift`.

구성 예시: `DayWorkload`, `.label()`, `SwiftUI DismissAction.callAsFunction`, `Binding`, `Bool`, `Error`, `Int`, `LocalDate`, `OccurrenceSnapshot`, `PlanDraft`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 9. 네이티브 파일과 프로젝트 연결

전체 노드: **27개** · 응집도: **0.136752**.

출처: `Hanju.xcodeproj/project.pbxproj`, `Hanju/App/AppTabs.swift`, `Hanju/App/HanjuApp.swift`, `Hanju/Design/DesignTokens.swift`, `Hanju/Features/Library/LibraryView.swift`, `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Features/Library/RoutineEditorSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Features/Library/UnsavedChangesGuard.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/RoutineTemplate.swift`, `Hanju/Persistence/PersistenceStore.swift`, `HanjuUITests/RoutineLibraryUITests.swift`.

구성 예시: `CGFloat`, `AppTabs.swift`, `HanjuApp.swift`, `앱 수명 실행 환경 주입`, `DesignTokens.swift`, `DesignTokens`, `LibraryView.swift`, `RoutineDraft.swift`, `RoutineEditorSheet.swift`, `RoutineFieldError.swift`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 10. 화면 계약과 계획 탐색

전체 노드: **25개** · 응집도: **0.123333**.

출처: `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/product-plan.md`.

구성 예시: `ActiveRoutinePanel`, `CalendarSyncState`, `03-components.md`, `WeekDaySelector`, `CalendarSheet 주별 연결`, `Routine Editor 편집 시트`, `ExecutionRecord`, `명시적 날짜 열기의 Week 목록 복귀`, `04-screens.md`, `Routine Library 루틴함`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 11. 제품 범위와 기록 정책

전체 노드: **24개** · 응집도: **0.152174**.

출처: `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/product-plan.md`.

구성 예시: `WeekMemo 입력`, `Records 행동 우선 기록`, `Settings 설정 화면`, `초안 보존과 저장 결과`, `AC-05 직접 완료와 수행일 정정`, `AC-06 알림`, `AC-08 캘린더 중단과 외부 수정`, `AC-09 주간 메모`, `AC-10 행동 우선 기록과 주 경계`, `AC-11 오프라인과 날짜 변경`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 12. 앱 저장소와 루틴 영속

전체 노드: **22개** · 응집도: **0.134199**.

출처: `Hanju/App/HanjuApp.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Persistence/PersistenceStore.swift`, `HanjuTests/RoutinePersistenceTests.swift`.

구성 예시: `App`, `ExecutionRecorder`, `HanjuApp`, `.body`, `.create()`, `PersistenceStore`, `.makeContainer()`, `.open()`, `Bool`, `ModelContainer`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 13. 저장 검증과 메모 세대

전체 노드: **22개** · 응집도: **0.160173**.

출처: `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/ExecutionTests.swift`, `HanjuTests/RecordsMigrationTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/SchemaMigrationTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`, `HanjuUITests/WeekPlanUITests.swift`.

구성 예시: `Hanju`, `WeeklyMemoCoordinator.swift`, `입력 세대 확인과 동기 저장`, `주입 메모 쓰기 호출`, `주별 메모 원문 저장`, `ExecutionMigrationTests.swift`, `V2 이전과 복구 영속 검증`, `ExecutionTests.swift`, `RecordsMigrationTests.swift`, `실제 디스크 V4 이전 검증`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 14. 이번 주 실행과 복귀

전체 노드: **22개** · 응집도: **0.212121**.

출처: `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Editor`, `RunningRoute`, `ExecutionSnapshot`, `Focus`, `OccurrenceSnapshot`, `String`, `UUID`, `Void`, `WeekView`, `.body`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 15. 개발 협업과 리뷰 규칙

전체 노드: **21개** · 응집도: **0.142857**.

출처: `.github/ISSUE_TEMPLATE/bug.md`, `.github/ISSUE_TEMPLATE/task.md`, `.github/copilot-instructions.md`, `.github/pull_request_template.md`, `AGENTS.md`, `CONTRIBUTING.md`, `docs/development/graphify.md`, `docs/development/review-workflow.md`, `docs/product-plan.md`.

구성 예시: `에이전트 파일 소유권`, `모든 PR 최신 Copilot 확인`, `중요 기술 결정 ADR`, `CONTRIBUTING.md`, `이슈 연결 Git 규칙`, `독립 리뷰와 Copilot 대기`, `이슈부터 시작`, `graphify.md`, `현재 AI 의미 추출과 라벨`, `main 병합 후 그래프 갱신`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 16. 루틴 저장과 실패 검증

전체 노드: **21개** · 응집도: **0.223810**.

출처: `Hanju/Features/Library/RoutineWriter.swift`, `HanjuTests/RoutineLibraryTests.swift`.

구성 예시: `ModelContext.fetch`, `RoutineWriter`, `.commit()`, `.fetch()`, `.find()`, `.optionalText()`, `.persist()`, `.setArchived()`, `Bool`, `ModelContext`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 17. 계획 조정과 시트 상태

전체 노드: **20개** · 응집도: **0.136842**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`.

구성 예시: `SwiftUI DismissAction.callAsFunction`, `Mode`, `move`, `recovery`, `rest`, `PlanAdjustmentSheet`, `.body`, `.canSave`, `.dirty`, `.init()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 18. 실행 탐색 화면 검증

전체 노드: **20개** · 응집도: **0.263158**.

출처: `HanjuUITests/ExecutionUITests.swift`.

구성 예시: `ExecutionUITests`, `.cancel()`, `.createTodayPlans()`, `.pickDate()`, `.reveal()`, `.testDirectCompletionEditCancellationZeroTimeAndUndo()`, `.testExplicitWeekAgendaOpensMovedDateAndSameDayWithoutStoppingRunning()`, `.testPastWeekPausedResumeConfirmsSwitchAndReturnsToSamePlan()`, `.testPriorWeekDirectCompletionAndPerformedDateCorrectionKeepPlanInPlace()`, `.testRecoveryFromRunningWeekKeepsDetailOnCancelAndOpensAgendaOnSave()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 19. 제품 방향과 기술 기반

전체 노드: **18개** · 응집도: **0.241830**.

출처: `AGENTS.md`, `DEVELOPMENT_HANDOFF.md`, `README.md`, `design/01-direction.md`, `design/05-swiftui-handoff.md`, `design/preview/index.html`, `design/reference/user-design-brief.txt`, `design/tokens.json`, `docs/adr/0001-native-ios-foundation.md`, `docs/development/local-development.md`.

구성 예시: `AGENTS.md`, `정돈한 생활의 페이지`, `01-direction.md`, `차분한 숲빛 강조색`, `05-swiftui-handoff.md`, `저장 날짜의 자동변경 금지`, `채택 기술 구성`, `index.html`, `사용자 디자인 원문`, `user-design-brief.txt`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 20. 루틴 편집 화면 검증

전체 노드: **18개** · 응집도: **0.372549**.

출처: `HanjuUITests/RoutineLibraryUITests.swift`.

구성 예시: `RoutineLibraryUITests`, `.enter()`, `.finishInput()`, `.openEditor()`, `.openLibrary()`, `.reveal()`, `.routineRow()`, `.swipeEditor()`, `.testCategoryChangeRemainsVisibleAndRevertedEditSwipesCleanly()`, `.testDirtySwipeKeepsInputThenDiscardsAndCleanSwipeDismisses()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 21. 지역 날짜와 시간대 해석

전체 노드: **17개** · 응집도: **0.176471**.

출처: `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Models/LocalDate.swift`, `HanjuTests/WeekPlanTests.swift`.

구성 예시: `Calendar`, `Comparable`, `.body`, `LocalDate`, `.calendar()`, `LocalDate.init(year:month:day:)`, `.fullLabel`, `.id`, `.init()`, `.key`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 22. 기능 인계와 CI 정의

전체 노드: **17개** · 응집도: **0.139706**.

출처: `.github/workflows/ios.yml`, `DEVELOPMENT_HANDOFF.md`, `Hanju.xcodeproj/xcshareddata/xcschemes/Hanju.xcscheme`, `Hanju/Features/Library/RoutineSnapshot.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `HanjuTests/RoutinePersistenceTests.swift`, `docs/development/implementation-plan.md`, `docs/development/local-development.md`, `docs/verification/2026-10-04-foundation.md`.

구성 예시: `실행과 주간 기록 구현 인계`, `변경 초안 swipe 확인 구현`, `implementation-plan.md`, `주간 기록 구현과 후속 경계`, `기록 구현 소유권과 검증`, `공유 scheme과 로컬 테스트`, `2026-10-04-foundation.md`, `기반 네이티브 검증 기록`, `ios.yml`, `iOS 빌드와 테스트 CI`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 23. 오늘 실행과 완료 동작

전체 노드: **17개** · 응집도: **0.308824**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Today/TodayView.swift`.

구성 예시: `.read()`, `UUID`, `RunningRoute`, `Bool`, `String`, `UUID`, `Void`, `TodayView`, `.activeActions()`, `.body`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 24. 계획 회차와 상태 판단

전체 노드: **17개** · 응집도: **0.125000**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/WeekView.swift`.

구성 예시: `OccurrenceSnapshot`, `.canReplan`, `.isUnfinished`, `.statusLabel`, `Status`, `completed`, `paused`, `planned`, `running`, `skipped`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 25. V4 기록과 메모 계약

전체 노드: **16개** · 응집도: **0.183333**.

출처: `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `docs/adr/0003-weekly-records-and-memo.md`, `docs/development/data-contracts.md`.

구성 예시: `부담 없는 계획과 호출자 복귀`, `실제 첫 날짜 이동 근거`, `확정 시간과 합계 한계`, `주별 초안과 저장 세대`, `주별 메모 원문 보존`, `수행일 장부와 루틴 횟수`, `수행일별 기록과 메모 결정`, `동결 모델과 V4 이전`, `기록 기능 검증 문서 근거`, `주간 기록과 메모 저장 계약`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 26. 루틴 초안과 입력 검증

전체 노드: **16개** · 응집도: **0.216667**.

출처: `Hanju/Features/Library/RoutineDraft.swift`.

구성 예시: `Field`, `expectedMinutes`, `firstAction`, `name`, `note`, `weekdays`, `weeklyFrequency`, `RoutineDraft`, `.optionalPositiveInteger()`, `.validate()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 27. 실행 수명과 계획 연동

전체 노드: **15개** · 응집도: **0.142857**.

출처: `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `Hanju/Features/Today/TodayView.swift`, `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/WeekView.swift`, `Hanju/Persistence/PersistenceStore.swift`, `HanjuUITests/ExecutionUITests.swift`, `design/04-screens.md`.

구성 예시: `지난 작업 재개 계약`, `ExecutionRecorder.swift`, `앱 수명 실행 명령`, `RunningRoutineView.swift`, `실행 제어와 시간 표시`, `TodayView.swift`, `오늘 실행과 수행일 완료`, `PlanAdjustmentSheet.swift`, `계획 변경과 실행 갱신`, `이동 초안과 중립 건너뛰기`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 28. 재계획과 기록 인수 계약

전체 노드: **14개** · 응집도: **0.175824**.

출처: `design/03-components.md`, `design/05-swiftui-handoff.md`, `docs/development/data-contracts.md`, `docs/development/implementation-plan.md`, `docs/development/planning-revision-1.3.md`, `docs/product-plan.md`.

구성 예시: `CompletionSheet 수행일 편집`, `ReplanEntry 복귀 진입`, `RestWeekAction 쉬기 확인`, `실제 공유 UI 추출`, `기능별 폴더 구조`, `같은 회차 재계획 계약`, `일괄 쉬기와 실행 원자 저장`, `순차 기능 이슈와 의존성`, `기획 1.3 변경 인계`, `기획 1.3 인수 시나리오`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 29. PR 정책과 자동 검사

전체 노드: **14개** · 응집도: **0.197802**.

출처: `.github/scripts/pr-policy.cjs`, `.github/scripts/pr-policy.test.cjs`, `.github/workflows/pr-policy.yml`.

구성 예시: `pr-policy.cjs`, `branchPattern`, `run()`, `pr-policy.test.cjs`, `assert`, `fixture()`, `{ test }`, `{ validate }`, `titlePattern`, `validate()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 30. 명시 요청과 호출자 구분

전체 노드: **14개** · 응집도: **0.175824**.

출처: `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Caller`, `records`, `today`, `Kind`, `adjustment`, `agenda`, `completion`, `plan`, `recovery`, `LocalDate`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 31. 동결 모델과 이전 검증

전체 노드: **14개** · 응집도: **0.241758**.

출처: `Hanju/Models/HanjuSchemaV1.swift`, `HanjuTests/SchemaMigrationTests.swift`.

구성 예시: `HanjuSchemaV1`, `.models`, `.versionIdentifier`, `PersistentModel`, `Schema`, `SchemaMigrationTests`, `.migrateAndAddPlan()`, `.testRealV1DiskStoreMigratesToV3AndReopensWithAllRoutineValues()`, `.verifyRoutine()`, `.writeV1Fixture()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 32. 주간 계획 화면 검증

전체 노드: **14개** · 응집도: **0.340659**.

출처: `HanjuUITests/WeekPlanUITests.swift`.

구성 예시: `Bool`, `Date`, `String`, `XCUIApplication`, `XCUIElement`, `WeekPlanUITests`, `.choose()`, `.createRoutine()`, `.pickDate()`, `.reveal()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 33. 날짜 입력과 닫기 동작

전체 노드: **13개** · 응집도: **0.153846**.

출처: `Hanju/Features/Week/PlanDateFields.swift`.

구성 예시: `ClosedRange`, `Content`, `PlanDateFields`, `.dateBinding`, `.hasTime`, `.timeBinding`, `PlanDismissal`, `.body()`, `Binding`, `Bool`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 34. 하단 탭과 루틴 진입

전체 노드: **13개** · 응집도: **0.166667**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Library/LibraryView.swift`.

구성 예시: `AppTabs`, `.body`, `Tab`, `library`, `records`, `settings`, `today`, `week`, `Destination`, `archive`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 35. 수행일 편집과 완료 취소

전체 노드: **13개** · 응집도: **0.179487**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`.

구성 예시: `CompletionSheet`, `.body`, `.dateBinding`, `.dirty`, `.init()`, `.latestAllowedDay`, `.save()`, `.undo()`, `SwiftUI DismissAction.callAsFunction`, `Binding`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 36. 주간 기록 화면 검증

전체 노드: **13개** · 응집도: **0.333333**.

출처: `HanjuUITests/RecordsUITests.swift`.

구성 예시: `RecordsUITests`, `.application()`, `.completedRow()`, `.createTodayPlan()`, `.pickDate()`, `.reveal()`, `.testCompletionCorrectionMovesSameRecordBetweenWeeksAndUndoRecompleteRefreshes()`, `.testMemoWeekTabAndBackgroundFlushRelaunchAndPlanningCaller()`, `Bool`, `Date`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 37. 실행 오류와 저장 경계

전체 노드: **12개** · 응집도: **0.166667**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Library/RoutineWriter.swift`.

구성 예시: `ExecutionError`, `anotherRunning`, `changed`, `.errorDescription`, `futureDate`, `invalidData`, `invalidMinutes`, `String`, `WriteError`, `.errorDescription`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 38. 접근성과 디자인 토큰

전체 노드: **11개** · 응집도: **0.218182**.

출처: `design/02-foundations.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `design/contrast-report.json`, `design/preview/index.html`, `design/tokens.json`, `docs/product-plan.md`.

구성 예시: `처음부터 접근성 지원`, `의미 있는 대비 기준`, `02-foundations.md`, `한국어 시스템 서체`, `기획 1.2 프리뷰 경계`, `네이티브 검증 계약`, `지정 색 조합 대비 결과`, `contrast-report.json`, `로컬 디자인 시뮬레이션`, `시맨틱 디자인 토큰`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 39. 저장 실패 테스트 대역

전체 노드: **11개** · 응집도: **0.181818**.

출처: `HanjuTests/ExecutionTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

구성 예시: `Error`, `Failure`, `disk`, `Failure`, `disk`, `Failure`, `diskFull`, `Failure`, `disk`, `Failure`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 40. 명시 목록과 상세 보존

전체 노드: **11개** · 응집도: **0.200000**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Week/WeekView.swift`, `HanjuUITests/ExecutionUITests.swift`, `HanjuUITests/WeekPlanUITests.swift`.

구성 예시: `탭 탐색과 실행 연결`, `같은 날짜의 명시 agenda 요청`, `WeekView.swift`, `명시 agenda 목록과 타이머 보존`, `주간 계획과 늦은 완료`, `현재 미완료와 쉬기 안내`, `성공 날짜 목록과 취소 상세 보존`, `명시 목록 전환 회귀 정의`, `WeekPlanUITests.swift`, `실제 native switch 선택`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 41. 생활 시각과 해석 결과

전체 노드: **10개** · 응집도: **0.244444**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Models/LocalDate.swift`.

구성 예시: `Codable`, `.init()`, `LocalTime`, `LocalTime.init(hour:minute:)`, `.init()`, `.label`, `.minutes`, `Resolution`, `Int`, `String`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 42. 후속 연동과 날짜 계약

전체 노드: **10개** · 응집도: **0.288889**.

출처: `docs/development/data-contracts.md`, `docs/product-plan.md`.

구성 예시: `캘린더 연결과 쓰기 직렬화`, `캘린더 중단 후 복구 계약`, `LocalDate와 DST 해석`, `주 이동별 캘린더 조정`, `data-contracts.md`, `V4 기록과 후속 연동 계약`, `알림 예약과 종료 중 한계`, `같은 회차의 과거 재개`, `AC-07 주별 캘린더 연결`, `Apple 캘린더 주별 연결`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 43. 계획 초안과 횟수 배분

전체 노드: **10개** · 응집도: **0.444444**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Week/PlanDraft.swift`.

구성 예시: `Equatable`, `Entry`, `.init()`, `PlanDraft`, `.allocate()`, `.validate()`, `.validateCounts()`, `Int`, `String`, `UUID`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 44. 기록 조회와 메모 저장

전체 노드: **10개** · 응집도: **0.222222**.

출처: `Hanju/Features/Records/RecordsStore.swift`, `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `HanjuUITests/RecordsUITests.swift`.

구성 예시: `RecordsStore.swift`, `확정 시간 합계와 불확실 구분`, `주별 메모 원문 원자 저장`, `수행일별 완료와 실천 횟수`, `RecordsView.swift`, `행동 우선 기록 장부`, `메모 저장과 계획 호출 복귀`, `주별 메모 초안과 재시도`, `RecordsUITests.swift`, `기록 편집과 메모 UI 검증`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 45. 계획 오류와 입력 제한

전체 노드: **10개** · 응집도: **0.200000**.

출처: `Hanju/Features/Week/PlanDraft.swift`.

구성 예시: `PlanError`, `batchLimit`, `changedOccurrence`, `.errorDescription`, `inactiveRoutine`, `invalidDate`, `invalidDraft`, `invalidStoredData`, `missingOccurrence`, `runningNeedsRecorder`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 46. 실행 강조와 색상 에셋

전체 노드: **8개** · 응집도: **0.250000**.

출처: `Hanju/Assets.xcassets/AccentColor.colorset/Contents.json`, `Hanju/Assets.xcassets/AccentSubtle.colorset/Contents.json`, `Hanju/Assets.xcassets/Background.colorset/Contents.json`, `Hanju/Assets.xcassets/OnAccent.colorset/Contents.json`, `Hanju/Assets.xcassets/Surface.colorset/Contents.json`, `Hanju/Assets.xcassets/TextPrimary.colorset/Contents.json`, `Hanju/Assets.xcassets/TextSecondary.colorset/Contents.json`, `Hanju/Design/DesignTokens.swift`.

구성 예시: `실행 패널의 연한 강조색`, `강조 버튼의 전경 색상`, `AccentColor.colorset/Contents.json`, `Background.colorset/Contents.json`, `Surface.colorset/Contents.json`, `TextPrimary.colorset/Contents.json`, `TextSecondary.colorset/Contents.json`, `실행 강조와 대비 색상`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 47. 동결 루틴 원본 모델

전체 노드: **8개** · 응집도: **0.357143**.

출처: `Hanju/Features/Library/RoutineSnapshot.swift`, `Hanju/Models/HanjuSchemaV1.swift`.

구성 예시: `.init()`, `RoutineTemplate`, `.init()`, `Bool`, `Date`, `Int`, `String`, `UUID`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 48. 주간 날짜와 이전 메모

전체 노드: **6개** · 응집도: **0.333333**.

출처: `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/LocalDate.swift`.

구성 예시: `.nextWeek`, `.lastDay`, `.previousMemo`, `.adding()`, `.monday`, `.weekDays`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 49. 수행일 보존과 선택 범위

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `docs/development/data-contracts.md`.

구성 예시: `수행일 집계 저장 계약`, `CompletionSheet.swift`, `수행일과 선택 시간 편집`, `원본 수행일의 선택 범위`, `시간대 변경과 수행일 보존`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 50. 선호 요일과 날짜 계약

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Models/LocalDate.swift`, `docs/development/data-contracts.md`.

구성 예시: `월요일 기준 선호 요일 계약`, `선택 입력과 선호 요일 검증`, `LocalDate.swift`, `시간대 독립 계획 날짜`, `현지 시각과 DST 설명`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 51. 주간 화면 접근성 초점

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Focus`, `day`, `plan`, `rest`, `row`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 52. 오늘 화면 편집 분기

전체 노드: **4개** · 응집도: **0.500000**.

출처: `Hanju/Features/Today/TodayView.swift`.

구성 예시: `Editor`, `completion`, `.id`, `move`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 53. 에셋 카탈로그 메타데이터

전체 노드: **1개** · 응집도: **1.000000**.

출처: `Hanju/Assets.xcassets/Contents.json`.

구성 예시: `Assets.xcassets/Contents.json`. 전체 member_ids와 출처는 provenance.json에 보존했다.

## 건강 상태와 해석 한계

- 증분 입력 기준은 이전 main 원문의 SHA256과 완전한 원시 추출 캐시다. 오래된 경로를 가진 native manifest는 사용하지 않았다. 동일 파일 73개의 원시 관계 1881개는 모든 payload·방향을 그대로 재사용하고, 변경/추가 Swift 15개와 문서·설정 6개만 재분석했다. 동일 AST 노드는 변경 파일의 이름 해석 문맥으로 제공했다.
- 전체 입력 삭제는 없다. AppTabs placeholder 함수와 전용 타입 사용 노드 3개가 실제 소스 교체로 빠지고, WeekView Editor/Focus 타입 stub 2개는 실제 중첩 enum 선언으로 연결했다. 5개 이전 노드와 모든 관련 원시 관계의 대체 근거를 previous_published_comparison에 보존했다. 새 노드 204개를 더해 전체는 926→1125개다. 강제 export 옵션은 사용하지 않았다.
- 무방향 그래프의 대표 link 한 개는 여러 방향·관계를 축약한다. link.evidence의 source/target/relation 및 모든 원시 필드를 사용해야 한다. 순서 없는 endpoint 쌍별 원시 관계 Counter를 검증한다.
- 정적 AST는 Swift 오버로드·동명 심볼·closure와 모든 본문 호출을 완전히 해석하지 못한다. 이전 수신자 교정 43개는 동일 소스와 함께 보존하고 변경 소스 9개를 재확인했다. 신규 7개를 포함해 이번 추출 16개를 교정했고, 원래 AST 전체 payload는 extraction_before_correction에 남겼다. 기존 exports 2개도 보존했다. PlanWriter.commit와 주입 read/write/save는 간접 호출 의미를 보완하며 런타임 실행 확정이 아니다.
- 외부·제네릭 또는 미해결 타입의 위치는 사용 근거이며 타입 선언 위치가 아니다. Graphify producer 내부 중복 억제와 이름 해석 한계는 그대로 남는다. 추출한 모든 관계 보존은 소스의 모든 실행 분기나 호출을 발견했다는 보장이 아니다.
- 에셋 카탈로그 루트 Contents.json 1개는 명시 연결이 없어 고립 상태로 보존했다. 파일 hub·AST member·외부 타입도 보고서 전체 노드와 커뮤니티 집계에 포함한다. 낮은 응집도는 표에 그대로 표시한다.
- 테스트와 CI 관계는 현재 소스 정의를 분석한 것이다. 이 그래프 작업에서는 앱 테스트나 원격 CI를 실행·재확인하지 않았다. ADR의 날짜별 검증 기록과 현재 실행 결과를 혼동하지 않는다. 실제 기기·전체 MVP 인수는 미검증이며 UI 테스트의 조건부 skip 정의는 실행 결과가 아니다.
- #10 수행일별 기록·선택적 시간 합계·주간 메모 및 V4는 구현되어 있다. 알림 #11, 캘린더 #12, 실기기와 전체 인수 #13은 후속이다. 메모 초안은 앱 수명 안에서 실패 원문을 보존하며 debounce 이전 강제 종료까지 보장하는 별도 journal은 없다. 과거 날짜 이동 이력은 추정하지 않는다.
- 실제 모델명·토큰 사용량·비용은 관측되지 않아 null이다. 외부 LLM API를 사용하지 않았다는 사실은 비용 0을 뜻하지 않는다.

## 사용 기록

의미 추출은 현재 Codex 세션과 문서 담당 Codex 하위 에이전트 1개, 커뮤니티 라벨은 현재 세션이 담당했다. 외부 LLM API 호출 없음. 모델명·입력 토큰·출력 토큰·비용은 알 수 없음(null)이다. 다음 갱신도 제품 변경의 main 병합 후 고정 SHA에서 수행한다.
