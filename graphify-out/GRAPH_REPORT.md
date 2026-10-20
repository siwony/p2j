# 프로젝트 지식 그래프

분석 기준: main `4ca809386b54dd90e728fc7545846589b1c82deb` · 이슈 #30 · PR #31 · Graphify 0.9.68.

## 전체 집계

입력 **84개**(코드 45개, 문서·설정 39개), 노드 **926개**, 원시 관계 **2384개**, 무방향 연결 **2226개**, 커뮤니티 **46개**다. 고립 노드 1개, 차수 0 또는 1인 노드 263개다.

표와 각 커뮤니티의 노드 수는 graph.json의 전체 membership 기준이다. 파일 hub·AST 멤버·외부 타입을 제외하는 기본 thin 필터는 사용하지 않았다. 응집도는 설치된 Graphify score_all의 전체 membership 계산값이다.

## 이번 분석의 의미

이전 원시 캐시가 없어 모든 입력을 다시 분석했다. 이전 출판 결과와 원문 비교에서 파일 77개는 같은 내용이고 7개가 바뀌었으며 추가·삭제는 없다. 의미 ID는 원문 확인 뒤 유지했다. 증분 캐시 복구나 이전 원시 바이트 재사용을 주장하지 않는다.

이번 주 명시 agenda 요청은 UUID로 같은 날짜 재요청을 구별하고 해당 날짜 목록으로 돌아간다. 보통 탭 이동·계획/재계획 취소는 실행 상세를 보존한다. 저장 성공과 savedDay가 있을 때만 목록으로 돌아가며 대상 날짜에 초점을 둔다. 이 탐색 전환은 실행 기록기에 start/pause 명령을 보내지 않는다. UI helper는 실제 내부 native switch를 조작한다. iOS CI 정의의 제한은 45분이다.

기존 실행/V3·날짜 보존 수정은 구현되어 있다. 전체 Records #10, 알림 #11, 캘린더 #12, 실기기 인수 #13은 후속이다. 이 그래프는 테스트 정의를 읽었으며 앱 테스트·원격 CI 성공을 보고하지 않는다.

## 이전 출판 결과와 대응

노드는 942 → 926개다. 이전 미해결/외부 타입 참조 stub 49개를 실제 선언 또는 파일별 외부 타입 참조로 대체하고 새 노드 33개를 추가했다. 실제 선언 삭제는 없다. 기존 관계 중 타입 참조 148개와 PlanWriter.commit calls 1개는 현재 관계에 대응하며, commit은 주입 save/ModelContext.save 분기를 INFERRED indirect_call로 표현한다. 대응 원본·대체 증거 전부는 provenance.json의 previous_published_comparison에 기록했다. 원시 관계는 2249 → 2384개, 연결은 2089 → 2226개다. 강제 export 옵션은 사용하지 않았다.

## 커뮤니티 전체 목록

| ID | 이름 | 전체 노드 | 응집도 |
|---:|---|---:|---:|
| 0 | 실행 기록과 시간 복구 | 98 | 0.067326 |
| 1 | 루틴 저장과 원자 검증 | 71 | 0.057143 |
| 2 | 루틴 목록과 편집 상태 | 60 | 0.051977 |
| 3 | 주간 계획 명령 검증 | 40 | 0.155128 |
| 4 | 변경 초안과 닫기 위임 | 39 | 0.080972 |
| 5 | 이슈 연결과 Git 정책 | 35 | 0.077311 |
| 6 | 동결 스키마와 디스크 이전 | 35 | 0.084034 |
| 7 | 계획 조정과 시트 상태 | 32 | 0.076613 |
| 8 | 네이티브 화면과 프로젝트 구성 | 29 | 0.128079 |
| 9 | 개발 협업과 리뷰 규칙 | 27 | 0.165242 |
| 10 | 제품 범위와 기록 정책 | 26 | 0.135385 |
| 11 | 화면 계약과 명시 탐색 | 25 | 0.123333 |
| 12 | 주간 선택과 계획 시트 | 24 | 0.155797 |
| 13 | 실행 원본과 복구 계약 | 22 | 0.112554 |
| 14 | 이번 주 실행과 탐색 | 22 | 0.199134 |
| 15 | 실행 화면 회귀 정의 | 20 | 0.263158 |
| 16 | 모델 저장과 검증 인계 | 18 | 0.163399 |
| 17 | 루틴 편집 화면 검증 | 18 | 0.372549 |
| 18 | 하단 탭과 루틴 진입 | 17 | 0.147059 |
| 19 | 커밋 훅 회귀 검증 | 17 | 0.382353 |
| 20 | 계획 회차와 상태 판단 | 17 | 0.125000 |
| 21 | 기능 인계와 네이티브 검증 | 16 | 0.150000 |
| 22 | 오늘 실행과 완료 조회 | 16 | 0.325000 |
| 23 | 날짜 입력과 시간대 해석 | 15 | 0.161905 |
| 24 | 재계획과 쉬기 인수 계약 | 14 | 0.175824 |
| 25 | 동결된 주간 계획 모델 | 14 | 0.252747 |
| 26 | 주간 계획 화면 검증 | 14 | 0.340659 |
| 27 | 날짜와 시각 생성 규칙 | 13 | 0.192308 |
| 28 | 명시 목록과 상세 보존 | 13 | 0.166667 |
| 29 | 후속 연동과 수행일 계약 | 12 | 0.227273 |
| 30 | 계획 초안과 요청 식별 | 12 | 0.348485 |
| 31 | 접근성 색상과 디자인 토큰 | 11 | 0.218182 |
| 32 | 지역 날짜와 주간 연산 | 10 | 0.244444 |
| 33 | 계획 오류와 검증 경계 | 10 | 0.200000 |
| 34 | 실행 강조와 색상 에셋 | 8 | 0.250000 |
| 35 | 저장 실패 테스트 대역 | 7 | 0.285714 |
| 36 | 실행 오류와 입력 제한 | 7 | 0.285714 |
| 37 | 실행 상세와 제어 동작 | 7 | 0.380952 |
| 38 | 생활 기록의 시각 방향 | 5 | 0.600000 |
| 39 | 선호 요일과 날짜 계약 | 5 | 0.400000 |
| 40 | 앱 수명과 실행 저장소 | 5 | 0.500000 |
| 41 | 계획 스냅샷과 조회 복사 | 5 | 0.400000 |
| 42 | 건너뛰기와 입력 보존 | 5 | 0.400000 |
| 43 | 주간 화면의 접근성 초점 | 5 | 0.400000 |
| 44 | 오늘 화면의 편집 분기 | 4 | 0.500000 |
| 45 | 에셋 카탈로그 메타데이터 | 1 | 1.000000 |

### 0. 실행 기록과 시간 복구

전체 노드: **98개** · 응집도: **0.067326**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/ExecutionTests.swift`.

구성 예시: `CompletionSheet`, `.body`, `.dateBinding`, `.dirty`, `.init()`, `.latestAllowedDay`, `.save()`, `.undo()`, `SwiftUI DismissAction.callAsFunction`, `Binding`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 1. 루틴 저장과 원자 검증

전체 노드: **71개** · 응집도: **0.057143**.

출처: `Hanju/App/HanjuApp.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Persistence/PersistenceStore.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/RoutinePersistenceTests.swift`.

구성 예시: `App`, `HanjuApp`, `.body`, `Field`, `expectedMinutes`, `firstAction`, `name`, `note`, `weekdays`, `weeklyFrequency`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 2. 루틴 목록과 편집 상태

전체 노드: **60개** · 응집도: **0.051977**.

출처: `Hanju/Features/Library/RoutineEditorSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineSnapshot.swift`.

구성 예시: `SwiftUI DismissAction.callAsFunction`, `PendingAction`, `archive`, `dismiss`, `RecoveryAction`, `archive`, `save`, `RoutineEditorSheet`, `.archive()`, `.body`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 3. 주간 계획 명령 검증

전체 노드: **40개** · 응집도: **0.155128**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/PlanWriter.swift`, `HanjuTests/WeekPlanTests.swift`.

구성 예시: `.save()`, `ModelContext.fetch`, `PlanWriter`, `.check()`, `.commit()`, `.confirm()`, `.fetch()`, `.find()`, `.markSkipped()`, `.move()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 4. 변경 초안과 닫기 위임

전체 노드: **39개** · 응집도: **0.080972**.

출처: `Hanju/Features/Library/UnsavedChangesGuard.swift`.

구성 예시: `Any`, `Context`, `Coordinator`, `.attach()`, `.detach()`, `.forwardingTarget()`, `.presentationControllerDidAttemptToDismiss()`, `.presentationControllerDidDismiss()`, `.presentationControllerShouldDismiss()`, `.presentationControllerWillDismiss()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 5. 이슈 연결과 Git 정책

전체 노드: **35개** · 응집도: **0.077311**.

출처: `.githooks/commit-msg`, `.github/ISSUE_TEMPLATE/bug.md`, `.github/ISSUE_TEMPLATE/task.md`, `.github/scripts/pr-policy.cjs`, `.github/scripts/pr-policy.test.cjs`, `.github/scripts/test_commit_msg.py`, `.github/workflows/pr-policy.yml`, `CONTRIBUTING.md`, `docs/development/review-workflow.md`.

구성 예시: `이슈 연결 Git 규칙`, `이슈부터 시작`, `PR 정책과 main 보호`, `commit-msg`, `Validate project commit conventions without third-party dependencies.`, `rebase 원래 브랜치 검증`, `reject()`, `bug.md`, `task.md`, `pr-policy.cjs`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 6. 동결 스키마와 디스크 이전

전체 노드: **35개** · 응집도: **0.084034**.

출처: `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `HanjuTests/SchemaMigrationTests.swift`.

구성 예시: `HanjuSchemaV1`, `.models`, `.versionIdentifier`, `PersistentModel`, `Schema`, `HanjuMigrationPlan`, `.schemas`, `.stages`, `ExecutionInterval`, `.init()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 7. 계획 조정과 시트 상태

전체 노드: **32개** · 응집도: **0.076613**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Content`, `SwiftUI DismissAction.callAsFunction`, `Mode`, `move`, `recovery`, `rest`, `PlanAdjustmentSheet`, `.body`, `.canSave`, `.dirty`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 8. 네이티브 화면과 프로젝트 구성

전체 노드: **29개** · 응집도: **0.128079**.

출처: `Hanju.xcodeproj/project.pbxproj`, `Hanju/App/AppTabs.swift`, `Hanju/App/HanjuApp.swift`, `Hanju/Design/DesignTokens.swift`, `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `Hanju/Features/Library/LibraryView.swift`, `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Features/Library/RoutineEditorSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Features/Library/UnsavedChangesGuard.swift`, `Hanju/Features/Today/TodayView.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/RoutineTemplate.swift`.

구성 예시: `CGFloat`, `AppTabs.swift`, `HanjuApp.swift`, `앱 수명 실행 환경 주입`, `DesignTokens.swift`, `DesignTokens`, `CompletionSheet.swift`, `수행일과 선택 시간 편집`, `원본 수행일의 선택 범위`, `RunningRoutineView.swift`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 9. 개발 협업과 리뷰 규칙

전체 노드: **27개** · 응집도: **0.165242**.

출처: `.github/copilot-instructions.md`, `.github/pull_request_template.md`, `AGENTS.md`, `CONTRIBUTING.md`, `DEVELOPMENT_HANDOFF.md`, `README.md`, `design/05-swiftui-handoff.md`, `design/preview/index.html`, `design/tokens.json`, `docs/adr/0001-native-ios-foundation.md`, `docs/development/graphify.md`, `docs/development/local-development.md`, `docs/development/review-workflow.md`.

구성 예시: `에이전트 파일 소유권`, `모든 PR 최신 Copilot 확인`, `AGENTS.md`, `CONTRIBUTING.md`, `독립 리뷰와 Copilot 대기`, `05-swiftui-handoff.md`, `저장 날짜의 자동변경 금지`, `채택 기술 구성`, `index.html`, `tokens.json`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 10. 제품 범위와 기록 정책

전체 노드: **26개** · 응집도: **0.135385**.

출처: `CONTRIBUTING.md`, `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/product-plan.md`.

구성 예시: `중요 기술 결정 ADR`, `WeekMemo 입력`, `Records 행동 우선 기록`, `Settings 설정 화면`, `초안 보존과 저장 결과`, `AC-05 직접 완료와 수행일 정정`, `AC-06 알림`, `AC-08 캘린더 중단과 외부 수정`, `AC-09 주간 메모`, `AC-10 행동 우선 기록과 주 경계`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 11. 화면 계약과 명시 탐색

전체 노드: **25개** · 응집도: **0.123333**.

출처: `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/product-plan.md`.

구성 예시: `ActiveRoutinePanel`, `CalendarSyncState`, `03-components.md`, `WeekDaySelector`, `CalendarSheet 주별 연결`, `Routine Editor 편집 시트`, `ExecutionRecord`, `명시적 날짜 열기의 Week 목록 복귀`, `04-screens.md`, `Routine Library 루틴함`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 12. 주간 선택과 계획 시트

전체 노드: **24개** · 응집도: **0.155797**.

출처: `Hanju/Features/Week/WeeklySelectionSheet.swift`.

구성 예시: `DayWorkload`, `.label()`, `SwiftUI DismissAction.callAsFunction`, `Binding`, `Bool`, `Error`, `Int`, `Set`, `String`, `UUID`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 13. 실행 원본과 복구 계약

전체 노드: **22개** · 응집도: **0.112554**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `HanjuTests/WeekPlanTests.swift`, `docs/adr/0002-execution-time-and-recovery.md`, `docs/development/data-contracts.md`.

구성 예시: `Darwin`, `실행 시계와 복구 결정`, `V3 실행 저장 계약`, `Foundation`, `ExecutionClock.swift`, `재실행 시계 비교 한계`, `수면 포함 실행 시계`, `ExecutionSnapshot.swift`, `미기록과 불확실 시간 구분`, `ExecutionWriter.swift`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 14. 이번 주 실행과 탐색

전체 노드: **22개** · 응집도: **0.199134**.

출처: `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Editor`, `Focus`, `Editor`, `RunningRoute`, `String`, `UUID`, `Void`, `WeekView`, `.body`, `.confirmSkip()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 15. 실행 화면 회귀 정의

전체 노드: **20개** · 응집도: **0.263158**.

출처: `HanjuUITests/ExecutionUITests.swift`.

구성 예시: `ExecutionUITests`, `.cancel()`, `.createTodayPlans()`, `.pickDate()`, `.reveal()`, `.testDirectCompletionEditCancellationZeroTimeAndUndo()`, `.testExplicitWeekAgendaOpensMovedDateAndSameDayWithoutStoppingRunning()`, `.testPastWeekPausedResumeConfirmsSwitchAndReturnsToSamePlan()`, `.testPriorWeekDirectCompletionAndPerformedDateCorrectionKeepPlanInPlace()`, `.testRecoveryFromRunningWeekKeepsDetailOnCancelAndOpensAgendaOnSave()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 16. 모델 저장과 검증 인계

전체 노드: **18개** · 응집도: **0.163399**.

출처: `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/ExecutionTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/SchemaMigrationTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuUITests/RoutineLibraryUITests.swift`, `HanjuUITests/WeekPlanUITests.swift`.

구성 예시: `Hanju`, `WeeklySelectionSheet.swift`, `명시 선택과 초안 보호`, `회차별 실행 기록 모델`, `ExecutionMigrationTests.swift`, `V2 이전과 복구 영속 검증`, `ExecutionTests.swift`, `실행 시간과 날짜 회귀검증`, `RoutineLibraryTests.swift`, `루틴 저장 실패와 복원 검증`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 17. 루틴 편집 화면 검증

전체 노드: **18개** · 응집도: **0.372549**.

출처: `HanjuUITests/RoutineLibraryUITests.swift`.

구성 예시: `RoutineLibraryUITests`, `.enter()`, `.finishInput()`, `.openEditor()`, `.openLibrary()`, `.reveal()`, `.routineRow()`, `.swipeEditor()`, `.testCategoryChangeRemainsVisibleAndRevertedEditSwipesCleanly()`, `.testDirtySwipeKeepsInputThenDiscardsAndCleanSwipeDismisses()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 18. 하단 탭과 루틴 진입

전체 노드: **17개** · 응집도: **0.147059**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Library/LibraryView.swift`.

구성 예시: `Actions`, `AppTabs`, `.body`, `.emptyScreen()`, `String`, `Tab`, `library`, `records`, `settings`, `today`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 19. 커밋 훅 회귀 검증

전체 노드: **17개** · 응집도: **0.382353**.

출처: `.github/scripts/test_commit_msg.py`.

구성 예시: `CommitMessageHookTests`, `.assert_rejected()`, `.commit()`, `.conflicting_history()`, `.git()`, `.invoke_hook()`, `.reword()`, `.setUp()`, `.test_apply_rebase_uses_original_branch()`, `.test_direct_main_detached_and_invalid_branch_rejected()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 20. 계획 회차와 상태 판단

전체 노드: **17개** · 응집도: **0.125000**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/WeekView.swift`.

구성 예시: `OccurrenceSnapshot`, `.canReplan`, `.isUnfinished`, `.statusLabel`, `Status`, `completed`, `paused`, `planned`, `running`, `skipped`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 21. 기능 인계와 네이티브 검증

전체 노드: **16개** · 응집도: **0.150000**.

출처: `.github/workflows/ios.yml`, `DEVELOPMENT_HANDOFF.md`, `Hanju.xcodeproj/xcshareddata/xcschemes/Hanju.xcscheme`, `Hanju/Features/Library/RoutineSnapshot.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `HanjuTests/RoutinePersistenceTests.swift`, `docs/development/implementation-plan.md`, `docs/development/local-development.md`, `docs/verification/2026-10-04-foundation.md`.

구성 예시: `실행 구현과 후속 인계`, `변경 초안 swipe 확인 구현`, `implementation-plan.md`, `실행 구현과 후속 기능 경계`, `공유 scheme과 로컬 테스트`, `2026-10-04-foundation.md`, `기반 네이티브 검증 기록`, `ios.yml`, `iOS 빌드와 테스트 CI`, `네이티브 CI 시간 제한`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 22. 오늘 실행과 완료 조회

전체 노드: **16개** · 응집도: **0.325000**.

출처: `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Today/TodayView.swift`.

구성 예시: `.read()`, `UUID`, `RunningRoute`, `Bool`, `String`, `UUID`, `Void`, `TodayView`, `.activeActions()`, `.body`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 23. 날짜 입력과 시간대 해석

전체 노드: **15개** · 응집도: **0.161905**.

출처: `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Models/LocalDate.swift`, `HanjuTests/WeekPlanTests.swift`.

구성 예시: `Calendar`, `ClosedRange`, `PlanDateFields`, `.body`, `.dateBinding`, `.hasTime`, `.timeBinding`, `Binding`, `Date`, `.calendar()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 24. 재계획과 쉬기 인수 계약

전체 노드: **14개** · 응집도: **0.175824**.

출처: `design/03-components.md`, `design/05-swiftui-handoff.md`, `docs/development/data-contracts.md`, `docs/development/implementation-plan.md`, `docs/development/planning-revision-1.3.md`, `docs/product-plan.md`.

구성 예시: `CompletionSheet 수행일 편집`, `ReplanEntry 복귀 진입`, `RestWeekAction 쉬기 확인`, `실제 공유 UI 추출`, `기능별 폴더 구조`, `같은 회차 재계획 계약`, `일괄 쉬기와 실행 원자 저장`, `순차 기능 이슈와 의존성`, `기획 1.3 변경 인계`, `기획 1.3 인수 시나리오`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 25. 동결된 주간 계획 모델

전체 노드: **14개** · 응집도: **0.252747**.

출처: `Hanju/Models/HanjuSchemaV2.swift`.

구성 예시: `HanjuSchemaV2`, `.models`, `.versionIdentifier`, `PlannedOccurrence`, `.init()`, `Bool`, `Date`, `Int`, `PersistentModel`, `Schema`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 26. 주간 계획 화면 검증

전체 노드: **14개** · 응집도: **0.340659**.

출처: `HanjuUITests/WeekPlanUITests.swift`.

구성 예시: `Bool`, `Date`, `String`, `XCUIApplication`, `XCUIElement`, `WeekPlanUITests`, `.choose()`, `.createRoutine()`, `.pickDate()`, `.reveal()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 27. 날짜와 시각 생성 규칙

전체 노드: **13개** · 응집도: **0.192308**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Models/LocalDate.swift`.

구성 예시: `Codable`, `.init()`, `LocalDate.init(year:month:day:)`, `.init()`, `LocalTime`, `LocalTime.init(hour:minute:)`, `.init()`, `.label`, `.minutes`, `Resolution`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 28. 명시 목록과 상세 보존

전체 노드: **13개** · 응집도: **0.166667**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Week/WeekView.swift`, `HanjuUITests/ExecutionUITests.swift`, `HanjuUITests/WeekPlanUITests.swift`, `design/04-screens.md`.

구성 예시: `지난 작업 재개 계약`, `탭 탐색과 실행 연결`, `같은 날짜의 명시 agenda 요청`, `WeekView.swift`, `명시 agenda 목록과 타이머 보존`, `주간 계획과 늦은 완료`, `현재 미완료와 쉬기 안내`, `지난주 재개와 호출 복귀`, `성공 날짜 목록과 취소 상세 보존`, `명시 목록 전환 회귀 정의`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 29. 후속 연동과 수행일 계약

전체 노드: **12개** · 응집도: **0.227273**.

출처: `Hanju/Features/Execution/ExecutionWriter.swift`, `docs/development/data-contracts.md`, `docs/product-plan.md`.

구성 예시: `캘린더 연결과 쓰기 직렬화`, `캘린더 중단 후 복구 계약`, `LocalDate와 DST 해석`, `주 이동별 캘린더 조정`, `data-contracts.md`, `V3 실행과 후속 연동 계약`, `알림 예약과 종료 중 한계`, `같은 회차의 과거 재개`, `수행일 집계 저장 계약`, `AC-07 주별 캘린더 연결`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 30. 계획 초안과 요청 식별

전체 노드: **12개** · 응집도: **0.348485**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Equatable`, `Entry`, `.init()`, `PlanDraft`, `.allocate()`, `.validate()`, `.validateCounts()`, `Int`, `String`, `UUID`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 31. 접근성 색상과 디자인 토큰

전체 노드: **11개** · 응집도: **0.218182**.

출처: `design/02-foundations.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `design/contrast-report.json`, `design/preview/index.html`, `design/tokens.json`, `docs/product-plan.md`.

구성 예시: `처음부터 접근성 지원`, `의미 있는 대비 기준`, `02-foundations.md`, `한국어 시스템 서체`, `기획 1.2 프리뷰 경계`, `네이티브 검증 계약`, `지정 색 조합 대비 결과`, `contrast-report.json`, `로컬 디자인 시뮬레이션`, `시맨틱 디자인 토큰`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 32. 지역 날짜와 주간 연산

전체 노드: **10개** · 응집도: **0.244444**.

출처: `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/LocalDate.swift`.

구성 예시: `Comparable`, `.lastDay`, `LocalDate`, `.adding()`, `.fullLabel`, `.id`, `.key`, `.label`, `.monday`, `.weekDays`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 33. 계획 오류와 검증 경계

전체 노드: **10개** · 응집도: **0.200000**.

출처: `Hanju/Features/Week/PlanDraft.swift`.

구성 예시: `PlanError`, `batchLimit`, `changedOccurrence`, `.errorDescription`, `inactiveRoutine`, `invalidDate`, `invalidDraft`, `invalidStoredData`, `missingOccurrence`, `runningNeedsRecorder`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 34. 실행 강조와 색상 에셋

전체 노드: **8개** · 응집도: **0.250000**.

출처: `Hanju/Assets.xcassets/AccentColor.colorset/Contents.json`, `Hanju/Assets.xcassets/AccentSubtle.colorset/Contents.json`, `Hanju/Assets.xcassets/Background.colorset/Contents.json`, `Hanju/Assets.xcassets/OnAccent.colorset/Contents.json`, `Hanju/Assets.xcassets/Surface.colorset/Contents.json`, `Hanju/Assets.xcassets/TextPrimary.colorset/Contents.json`, `Hanju/Assets.xcassets/TextSecondary.colorset/Contents.json`, `Hanju/Design/DesignTokens.swift`.

구성 예시: `실행 패널의 연한 강조색`, `강조 버튼의 전경 색상`, `AccentColor.colorset/Contents.json`, `Background.colorset/Contents.json`, `Surface.colorset/Contents.json`, `TextPrimary.colorset/Contents.json`, `TextSecondary.colorset/Contents.json`, `실행 강조와 대비 색상`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 35. 저장 실패 테스트 대역

전체 노드: **7개** · 응집도: **0.285714**.

출처: `HanjuTests/ExecutionTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/WeekPlanTests.swift`.

구성 예시: `Error`, `Failure`, `disk`, `Failure`, `diskFull`, `Failure`, `disk`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 36. 실행 오류와 입력 제한

전체 노드: **7개** · 응집도: **0.285714**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`.

구성 예시: `ExecutionError`, `anotherRunning`, `changed`, `.errorDescription`, `futureDate`, `invalidData`, `invalidMinutes`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 37. 실행 상세와 제어 동작

전체 노드: **7개** · 응집도: **0.380952**.

출처: `Hanju/Features/Execution/RunningRoutineView.swift`.

구성 예시: `RunningRoutineView`, `.load()`, `.perform()`, `.resume()`, `String`, `UUID`, `Void`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 38. 생활 기록의 시각 방향

전체 노드: **5개** · 응집도: **0.600000**.

출처: `design/01-direction.md`, `design/reference/user-design-brief.txt`.

구성 예시: `정돈한 생활의 페이지`, `01-direction.md`, `차분한 숲빛 강조색`, `사용자 디자인 원문`, `user-design-brief.txt`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 39. 선호 요일과 날짜 계약

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Models/LocalDate.swift`, `docs/development/data-contracts.md`.

구성 예시: `월요일 기준 선호 요일 계약`, `선택 입력과 선호 요일 검증`, `LocalDate.swift`, `시간대 독립 계획 날짜`, `현지 시각과 DST 설명`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 40. 앱 수명과 실행 저장소

전체 노드: **5개** · 응집도: **0.500000**.

출처: `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Persistence/PersistenceStore.swift`.

구성 예시: `ExecutionRecorder.swift`, `앱 수명 실행 명령`, `PersistenceStore.swift`, `V3 저장소와 실행 수명`, `Observation`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 41. 계획 스냅샷과 조회 복사

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Models/HanjuSchemaV2.swift`.

구성 예시: `OccurrenceSnapshot.swift`, `계획 화면 값 복사`, `HanjuSchemaV2.swift`, `동결 모델과 V3 이전`, `계획 항목의 영속 스냅샷`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 42. 건너뛰기와 입력 보존

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `HanjuUITests/ExecutionUITests.swift`.

구성 예시: `PlanAdjustmentSheet.swift`, `계획 변경과 실행 갱신`, `이동 초안과 중립 건너뛰기`, `ExecutionUITests.swift`, `실행 완료와 복원 UI 검증`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 43. 주간 화면의 접근성 초점

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Focus`, `day`, `plan`, `rest`, `row`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 44. 오늘 화면의 편집 분기

전체 노드: **4개** · 응집도: **0.500000**.

출처: `Hanju/Features/Today/TodayView.swift`.

구성 예시: `Editor`, `completion`, `.id`, `move`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 45. 에셋 카탈로그 메타데이터

전체 노드: **1개** · 응집도: **1.000000**.

출처: `Hanju/Assets.xcassets/Contents.json`.

구성 예시: `Assets.xcassets/Contents.json`. 전체 member_ids와 출처는 provenance.json에 보존했다.

## 건강 상태와 해석 한계

- 이전 증분 원시 캐시·실행 스크립트가 없어 full 생성했다. 출판된 evidence는 비교 자료이며 완전한 원시 캐시를 복원했다고 주장하지 않는다. 84개 입력의 AST 45개와 문서·설정 39개를 전부 다시 확인했다.
- 전체 AST는 이전 증분의 타입 참조 stub 49개를 실제 선언 또는 파일별 외부 타입 참조로 대체한다. 기존 노드 942개에서 49개 제외·33개 추가되어 926개다. 원본 입력 삭제는 없고, 이전 관계 149개는 모두 대응 검증했다. 강제 export 옵션은 사용하지 않았다.
- undirected graph의 대표 link 한 개는 여러 방향·관계를 축약한다. link.evidence의 source/target/relation 및 모든 원시 필드를 사용해야 한다. 같은 순서 없는 endpoint 쌍의 원시 관계를 Counter로 검증했다.
- 정적 AST는 Swift의 오버로드·동명 심볼·closure·외부 타입 및 본문 내부 모든 호출을 완전히 해석하지 못한다. 52개 호출 수신자를 실제 원문으로 교정하고 exports 2개를 구분했다. PlanWriter.commit 분기는 의미 관계로 보완했다. confidence가 추론인 호출은 런타임 확정이 아니다.
- 외부/제네릭 및 미해결 타입의 source 위치는 사용 근거이며 해당 타입 선언 위치가 아니다. 같은 import의 반복 노드 메타데이터는 extraction_evidence에 보존했다. Coordinator.responds의 복합 super/original 조건 등 AST 관계가 모든 실행 분기를 열거하지는 않는다.
- 에셋 카탈로그 루트 Contents.json 노드 1개는 원문에 명시 연결이 없어 고립 상태로 보존했다. 파일별 hub·AST member stub·외부 타입도 보고서 전체 노드와 커뮤니티 집계에 포함한다.
- 테스트 관계는 소스에 있는 XCTest/CI 정의다. 이 작업에서 앱 테스트나 원격 CI를 실행·확인하지 않았으며 성공·skip 수를 추정하지 않는다. 재계획 UI 테스트의 월요일 조건부 XCTSkip을 현재 실행 결과와 구분한다.
- #9 실행/V3와 #27 수정, #30 명시 agenda 탐색은 현재 코드에 있다. 전체 Records #10, 알림 #11, 캘린더 #12, 실기기 인수 #13은 후속 범위다. 계획·화면 명세의 노드는 구현 완료를 뜻하지 않는다.
- 실제 모델명·토큰 사용량·비용은 관측되지 않아 null이다. 외부 LLM API를 사용하지 않았다는 사실은 비용 0을 뜻하지 않는다.

## 사용 기록

의미 추출과 라벨은 현재 Codex 세션 및 두 Codex 하위 에이전트가 담당했다. 외부 LLM API 호출 없음. 모델명·입력 토큰·출력 토큰·비용은 알 수 없음(null)이다. 다음 갱신도 제품 변경이 main에 병합된 뒤 고정 SHA에서 수행한다.
