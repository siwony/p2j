# 프로젝트 지식 그래프

분석 기준: main `fca2a978e1321cb87f821b12307811451bbc60f5` · 이슈 #45, #46, #47 · 코드 PR #50, #51, #52 · Graphify 0.9.68. 결과 PR의 병합 SHA와 분석 대상 SHA는 별개다.

## 전체 집계

입력 **105개**(코드 64개, 문서·설정 41개), 노드 **1503개**, 원시 관계 **4236개**, 무방향 연결 **4009개**, 커뮤니티 **66개**다. 고립 노드 1개, 차수0 또는1인 노드 407개, self-edge 2개다.

전체 membership에 파일hub·AST멤버·외부타입을 포함한다. 응집도는 설치 Graphify score_all 원값이며 thin필터·큰 커뮤니티 축소·낮은점수 숨김은 없다.

## 이번 증분 분석

이전 main `c047e6cd98b0e15f7a215635dcae12d8deba51f5`의 105개 입력과 완전 원시캐시를 확인했다. 입력98개는 같고7개를 갱신했다(Swift5·문서2, 추가/삭제0). 불변3261관계와 소유node 전체payload·방향을 유지했다. 실제 AST215개 node occurrence/887개 관계를 다시 추출했고 현재Codex가 변경 원문·문서 의미와 모든 커뮤니티 구성원을 읽었다.

#45: 재조정에서 원래 세대가 제거돼도 현재 열린 원래 route/ticket 전체와 대상 버전이 일치하는 유효 대상은 명시 시작할 수 있다. 새 C·새 세대 receipt는 소비하지 않고 옛 응답을 재열기/재예약하지 않는다. #46: 편집/확인창이 없을 때 같은 세대의 명시 body open도 새 presentation ID로 이전 읽기 화면을 교체한다. 무효 요청은 이전 화면을 보존하고 blocker·start 중복 억제는 유지한다.

#47: 회차별 civil 날짜/자체 시각·상태·해석instant·terminal·소비세대 checkpoint를 같은 원자JSON에 보존하며 receipt128·예약예산과 분리한다. 지난/소비 기본 알림을 시간대·pause·완료취소·기본시각 변경으로 되살리지 않는다. 실제 날짜/자체시각 변경 또는 관측 skip→restore만 수명을 새로 연다. 구버전은 남은 normal과 정확한 future snooze의 소비 근거를 쓰고 DST는 원래 시간대 resolve instant로 비교한다. snooze 시각·세대를 normal로 전용하거나 소실 이력을 추정하지 않는다.

didSave posting context에서 entity/persistent ID를 확인한 원시 전이와 관측 Date/시간대를 FIFO에 담고 첫 OS await 전에 전체 checkpoint와 성공prefix를 파일에 확정한다. await 뒤 세대와FIFO를 재확인하고 파일 실패는 이벤트를 남긴다. 지난 알림의 실제 시작 성공은 선택 대상 checkpoint만 receipt 완료 후보와 확정한다. DB/JSON 원자성과 JSON전 프로세스종료로 소실된 전이 복구는 보장하지 않는다. 같은값 재저장은 복구가 아니다.

Records UI helper는 요소 frame으로 스크롤 방향을 고르고 버튼 전체 가시성·range 존재를 확인한다. range의 고정제목 아래 위치 요구는 제거했으며 실제 주 범위·메모 보존 assertion은 유지한다. 현재 NotificationTests는35개 정의다. 이 그래프 작업에서는 테스트·CI를 새로 실행하거나 main전체회귀 완료를 확인하지 않았다. 기존 #44 선별검사/전체회귀 정책도 유지한다. 캘린더 #12와 실기기/iOS17/전체접근성·2주인수 #13은 후속이다.

## 이전 결과와 대응

노드 1434→1503, 원시 관계 3821→4236, 무방향 연결 3597→4009, 커뮤니티 73→66다. receiver33개 보정의 원래/현재payload·원문 앵커를 남겼다(calls13, reads_value20). 기존69개 receiver·CJS11개 관계/심볼분리·export2개 보정과 공유타입 이력은 보존했다. 이전 init오인1개는 새target 방출로 별도 감사한다.

제거node ID2개는 실제 mark→markStartReceipt 변경과 Date 사용stub 파일별ID 정규화다. 관련7개 관계를 현재 명시관계로 전부 대응했고 새 helper 분기/동작을 별도로 기술한다. 입력 삭제나 force export는 없다. 커뮤니티66개의 전체 구성원·출처를 읽어 이름을 다시 정했다.

## 커뮤니티 전체 목록

| ID | 이름 | 전체 노드 | 응집도 |
|---:|---|---:|---:|
| 0 | 알림 수명과 실행 검증 | 147 | 0.057777 |
| 1 | 실행 시간과 기록 검증 | 89 | 0.079418 |
| 2 | 알림 설정과 civil 수명 | 70 | 0.068737 |
| 3 | 계획 명령과 회차 이전 | 64 | 0.090278 |
| 4 | PR 선택과 전체 회귀 | 58 | 0.053842 |
| 5 | 이슈 연결과 Git 검증 | 52 | 0.074661 |
| 6 | 시간 표시와 명령 오류 | 41 | 0.056098 |
| 7 | 닫기 시도와 UIKit 위임 | 38 | 0.083926 |
| 8 | 버전 스키마와 디스크 이전 | 37 | 0.075075 |
| 9 | 실행 원본과 저장 계약 | 34 | 0.073084 |
| 10 | 프로젝트 파일과 화면 연결 | 30 | 0.131034 |
| 11 | 기록 장부와 주 탐색 | 29 | 0.108374 |
| 12 | 루틴 편집과 버리기 확인 | 27 | 0.116809 |
| 13 | 주간 선택과 초안 상태 | 27 | 0.136752 |
| 14 | 화면 명세와 알림 진입 | 26 | 0.110769 |
| 15 | 지역 날짜와 시각 해석 | 25 | 0.126667 |
| 16 | 제품 계약과 후속 연동 | 25 | 0.113333 |
| 17 | 주별 메모와 재시도 검증 | 25 | 0.260000 |
| 18 | 기록과 알림 UI 검증 | 25 | 0.180000 |
| 19 | 회차 상태와 현지 시각 | 24 | 0.094203 |
| 20 | 시각 기반과 알림 저장 계약 | 23 | 0.150198 |
| 21 | 구현 인계와 네이티브 기반 | 23 | 0.094862 |
| 22 | 주간 목록과 실행 탐색 | 23 | 0.197628 |
| 23 | 오늘 실행과 알림 선택 | 23 | 0.217391 |
| 24 | 테스트 파일과 회귀 연결 | 22 | 0.116883 |
| 25 | 루틴 목록과 편집 진입 | 21 | 0.152381 |
| 26 | 루틴 저장과 복원 검증 | 21 | 0.223810 |
| 27 | 계획 조정과 중립 건너뛰기 | 20 | 0.136842 |
| 28 | 실행 탐색과 완료 UI 검증 | 20 | 0.263158 |
| 29 | 제품 범위와 기록 정책 | 19 | 0.198830 |
| 30 | 탐색 보존과 저장 경계 | 18 | 0.124183 |
| 31 | 루틴 편집과 복원 UI 검증 | 18 | 0.372549 |
| 32 | 날짜 입력과 화면 닫기 | 16 | 0.133333 |
| 33 | 루틴 입력과 검증 오류 | 16 | 0.216667 |
| 34 | 알림 응답과 유한 완료 | 16 | 0.208333 |
| 35 | 개발 협업과 리뷰 규칙 | 15 | 0.228571 |
| 36 | 저장과 OS 실패 주입 | 14 | 0.142857 |
| 37 | 하단 탭과 접근성 초점 | 14 | 0.142857 |
| 38 | 주간 기록과 메모 조회 값 | 14 | 0.175824 |
| 39 | 기록 조회와 원문 저장 | 14 | 0.307692 |
| 40 | 주간 요청과 조정 종류 | 14 | 0.175824 |
| 41 | 앱 시작과 알림 위임 | 14 | 0.164835 |
| 42 | 주간 계획과 복원 UI 검증 | 14 | 0.340659 |
| 43 | 실행 복귀와 호출자 보존 | 12 | 0.196970 |
| 44 | 완료 기록과 수행일 편집 | 12 | 0.196970 |
| 45 | 행동 우선 기록과 이동 근거 | 12 | 0.166667 |
| 46 | 실제 OS 예약과 테스트 경계 | 12 | 0.212121 |
| 47 | 주간 기록과 메모 저장 계약 | 11 | 0.290909 |
| 48 | 알림 요청과 OS 어댑터 | 11 | 0.200000 |
| 49 | V4 이전과 원본 검증 | 11 | 0.272727 |
| 50 | 탭 요청과 편집 보호 | 10 | 0.311111 |
| 51 | 루틴 행과 목록 조회 값 | 10 | 0.200000 |
| 52 | 루틴 디스크와 실패 검증 | 10 | 0.266667 |
| 53 | 앱 환경과 공유 서비스 | 9 | 0.222222 |
| 54 | 메모 재시도와 실패 보존 | 9 | 0.305556 |
| 55 | 메모 저장 상태 표현 | 9 | 0.222222 |
| 56 | 실행 강조와 색상 에셋 | 8 | 0.250000 |
| 57 | 앱 저장소와 모델 구성 | 7 | 0.333333 |
| 58 | 실행 상세와 제어 동작 | 7 | 0.333333 |
| 59 | 계획 초안과 횟수 배분 | 7 | 0.619048 |
| 60 | V1 루틴 영속 필드 | 7 | 0.428571 |
| 61 | OS 알림 권한 상태 | 7 | 0.285714 |
| 62 | 선호 요일과 날짜 계약 | 6 | 0.333333 |
| 63 | 명시 목록과 타이머 보존 | 6 | 0.400000 |
| 64 | 네이티브 기반 기술 결정 | 4 | 0.833333 |
| 65 | 에셋 카탈로그 메타데이터 | 1 | 1.000000 |

### 0. 알림 수명과 실행 검증

전체 노드: **147개** · 응집도: **0.057777**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Services/Notifications/NotificationCoordinator.swift`, `Hanju/Services/Notifications/NotificationPlan.swift`, `Hanju/Services/Notifications/NotificationStateStore.swift`, `HanjuTests/NotificationTests.swift`, `docs/development/data-contracts.md`.

주요 구성: `NotificationCoordinator`, `ExecutionSnapshot`, `NotificationTests`, `.fixture()`, `NotificationPersistentState`, `.attach()`, `.preferences()`, `Client`. 전체 member_ids는 provenance.json에 있다.

### 1. 실행 시간과 기록 검증

전체 노드: **89개** · 응집도: **0.079418**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/ExecutionTests.swift`, `HanjuTests/RecordsTests.swift`.

주요 구성: `.start()`, `.complete()`, `.snapshot()`, `ExecutionClock`, `.edit()`, `CompletionDraft`, `ExecutionWriter`, `.fixture()`. 전체 member_ids는 provenance.json에 있다.

### 2. 알림 설정과 civil 수명

전체 노드: **70개** · 응집도: **0.068737**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Settings/SettingsView.swift`, `Hanju/Models/LocalDate.swift`, `Hanju/Services/Notifications/NotificationPlan.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`, `docs/adr/0004-local-notifications-and-reconciliation.md`.

주요 구성: `NotificationTicket`, `NotificationEnvelope`, `NotificationCivil`, `NotificationPreferences`, `SettingsView`, `NotificationRoute`, `NotificationTarget`, `.time()`. 전체 member_ids는 provenance.json에 있다.

### 3. 계획 명령과 회차 이전

전체 노드: **64개** · 응집도: **0.090278**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `HanjuTests/WeekPlanTests.swift`.

주요 구성: `.move()`, `.confirm()`, `PlanDraft`, `.skip()`, `.rest()`, `WeekPlanTests`, `.replan()`, `PlanWriter`. 전체 member_ids는 provenance.json에 있다.

### 4. PR 선택과 전체 회귀

전체 노드: **58개** · 응집도: **0.053842**.

출처: `.github/scripts/ios-test-plan.cjs`, `.github/scripts/ios-test-plan.test.cjs`, `.github/workflows/ios.yml`, `docs/development/local-development.md`, `docs/development/review-workflow.md`.

주요 구성: `run()`, `selectPlan()`, `buildArguments()`, `iOS 빌드와 테스트 CI`, `changedFiles()`, `verifyResults()`, `execute()`, `parseDiff()`. 전체 member_ids는 provenance.json에 있다.

### 5. 이슈 연결과 Git 검증

전체 노드: **52개** · 응집도: **0.074661**.

출처: `.githooks/commit-msg`, `.github/ISSUE_TEMPLATE/bug.md`, `.github/ISSUE_TEMPLATE/task.md`, `.github/scripts/pr-policy.cjs`, `.github/scripts/pr-policy.test.cjs`, `.github/scripts/test_commit_msg.py`, `.github/workflows/pr-policy.yml`, `CONTRIBUTING.md`, `docs/development/review-workflow.md`.

주요 구성: `CommitMessageHookTests`, `.git()`, `.commit()`, `.reword()`, `.assert_rejected()`, `이슈 연결 Git 규칙`, `.test_invalid_or_missing_rebase_head_name_rejected()`, `PR 정책과 main 보호`. 전체 member_ids는 provenance.json에 있다.

### 6. 시간 표시와 명령 오류

전체 노드: **41개** · 응집도: **0.056098**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Services/Notifications/NotificationStateStore.swift`.

주요 구성: `PlanError`, `ExecutionError`, `Interval`, `RecordedDuration`, `NotificationFailure`, `.format()`, `.timerLabel()`, `WriteError`. 전체 member_ids는 provenance.json에 있다.

### 7. 닫기 시도와 UIKit 위임

전체 노드: **38개** · 응집도: **0.083926**.

출처: `Hanju/Features/Library/UnsavedChangesGuard.swift`.

주요 구성: `Coordinator`, `UnsavedChangesGuard`, `ObserverController`, `.attach()`, `.forwardingTarget()`, `.presentationControllerShouldDismiss()`, `.responds()`, `.dismantleUIViewController()`. 전체 member_ids는 provenance.json에 있다.

### 8. 버전 스키마와 디스크 이전

전체 노드: **37개** · 응집도: **0.075075**.

출처: `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `HanjuTests/SchemaMigrationTests.swift`.

주요 구성: `.migrateAndAddPlan()`, `HanjuSchemaV1`, `HanjuSchemaV3`, `HanjuSchemaV4`, `HanjuMigrationPlan`, `SchemaMigrationTests`, `.verifyRoutine()`, `.writeV1Fixture()`. 전체 member_ids는 provenance.json에 있다.

### 9. 실행 원본과 저장 계약

전체 노드: **34개** · 응집도: **0.073084**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Records/RecordsSnapshot.swift`, `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `Hanju/Services/Notifications/NotificationStateStore.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/WeekPlanTests.swift`, `docs/adr/0002-execution-time-and-recovery.md`, `docs/development/data-contracts.md`.

주요 구성: `단일 실행과 저장 원자성`, `재실행 시계 비교 한계`, `복구 불확실성 영속 보존`, `쉬기 대상과 실행 보존`, `계획 항목의 영속 스냅샷`, `원본 구간과 복구 표식`, `회차별 실행 기록 모델`, `실행 시계와 복구 결정`. 전체 member_ids는 provenance.json에 있다.

### 10. 프로젝트 파일과 화면 연결

전체 노드: **30개** · 응집도: **0.131034**.

출처: `Hanju.xcodeproj/project.pbxproj`, `Hanju/App/AppTabs.swift`, `Hanju/App/HanjuApp.swift`, `Hanju/Design/DesignTokens.swift`, `Hanju/Features/Library/RoutineEditorSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Settings/SettingsView.swift`, `Hanju/Features/Today/TodayView.swift`, `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/WeekView.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/RoutineTemplate.swift`, `HanjuTests/WeekPlanTests.swift`.

주요 구성: `Hanju 네이티브 프로젝트`, `project.pbxproj`, `DesignTokens`, `루틴 저장과 보관 명령`, `오늘 실행과 수행일 완료`, `이전 메모 재시도 안내`, `알림 대상과 현재 장부`, `앱 수명 실행 환경 주입`. 전체 member_ids는 provenance.json에 있다.

### 11. 기록 장부와 주 탐색

전체 노드: **29개** · 응집도: **0.108374**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Records/RecordsView.swift`, `HanjuUITests/RecordsUITests.swift`.

주요 구성: `RecordsView`, `.now()`, `.load()`, `.edit()`, `Focus`, `.changeWeek()`, `.recordsHeader()`, `.consumeNotificationRequest()`. 전체 member_ids는 provenance.json에 있다.

### 12. 루틴 편집과 버리기 확인

전체 노드: **27개** · 응집도: **0.116809**.

출처: `Hanju/Features/Library/RoutineEditorSheet.swift`.

주요 구성: `RoutineEditorSheet`, `.archive()`, `SwiftUI DismissAction.callAsFunction`, `.dayName()`, `.init()`, `.save()`, `.toggleDay()`, `PendingAction`. 전체 member_ids는 provenance.json에 있다.

### 13. 주간 선택과 초안 상태

전체 노드: **27개** · 응집도: **0.136752**.

출처: `Hanju/Features/Week/WeeklySelectionSheet.swift`.

주요 구성: `WeeklySelectionSheet`, `.label()`, `.show()`, `.allocate()`, `.countBinding()`, `.loadPrevious()`, `.previousBinding()`, `.save()`. 전체 member_ids는 provenance.json에 있다.

### 14. 화면 명세와 알림 진입

전체 노드: **26개** · 응집도: **0.110769**.

출처: `Hanju/Features/Settings/SettingsView.swift`, `Hanju/Features/Today/TodayView.swift`, `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/adr/0004-local-notifications-and-reconciliation.md`, `docs/product-plan.md`.

주요 구성: `04-screens.md`, `03-components.md`, `Week 이번 주 화면`, `Today 오늘 화면`, `PlannedOccurrence`, `Reschedule 일정 이동`, `WeekMemo 입력`, `CalendarSheet 주별 연결`. 전체 member_ids는 provenance.json에 있다.

### 15. 지역 날짜와 시각 해석

전체 노드: **25개** · 응집도: **0.126667**.

출처: `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/LocalDate.swift`.

주요 구성: `LocalDate`, `.adding()`, `.calendar()`, `.init()`, `.resolve()`, `Resolution`, `LocalDate.init(year:month:day:)`, `.body`. 전체 member_ids는 provenance.json에 있다.

### 16. 제품 계약과 후속 연동

전체 노드: **25개** · 응집도: **0.113333**.

출처: `design/03-components.md`, `design/05-swiftui-handoff.md`, `docs/development/data-contracts.md`, `docs/development/implementation-plan.md`, `docs/development/planning-revision-1.3.md`, `docs/product-plan.md`.

주요 구성: `data-contracts.md`, `기획 1.3 변경 인계`, `V4 기록과 후속 연동 계약`, `Apple 캘린더 주별 연결`, `실제 공유 UI 추출`, `순차 기능 이슈와 의존성`, `실제 수행일 정정`, `놓친 일 다시 고르기`. 전체 member_ids는 provenance.json에 있다.

### 17. 주별 메모와 재시도 검증

전체 노드: **25개** · 응집도: **0.260000**.

출처: `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

주요 구성: `WeeklyMemoCoordinator`, `.flush()`, `.load()`, `.draft()`, `.update()`, `.retry()`, `.testFailedWeekDraftSurvivesOtherWeekSaveReloadAndRetry()`, `.testDebounceKeepsLatestTextAndCapturedWeekWithoutDuplicateFlush()`. 전체 member_ids는 provenance.json에 있다.

### 18. 기록과 알림 UI 검증

전체 노드: **25개** · 응집도: **0.180000**.

출처: `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/NotificationTests.swift`, `HanjuUITests/NotificationUITests.swift`, `HanjuUITests/RecordsUITests.swift`.

주요 구성: `RecordsUITests`, `.testCompletionCorrectionMovesSameRecordBetweenWeeksAndUndoRecompleteRefreshes()`, `.reveal()`, `.selectWeek()`, `.add()`, `NotificationUITests`, `.reveal()`, `.tapSwitch()`. 전체 member_ids는 provenance.json에 있다.

### 19. 회차 상태와 현지 시각

전체 노드: **24개** · 응집도: **0.094203**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/WeekView.swift`, `Hanju/Models/LocalDate.swift`, `HanjuTests/WeekPlanTests.swift`.

주요 구성: `OccurrenceSnapshot`, `LocalTime`, `Status`, `.init()`, `.init()`, `.testGregorianDatesWeekBoundariesAndDSTResolution()`, `LocalTime.init(hour:minute:)`, `Int`. 전체 member_ids는 provenance.json에 있다.

### 20. 시각 기반과 알림 저장 계약

전체 노드: **23개** · 응집도: **0.150198**.

출처: `DEVELOPMENT_HANDOFF.md`, `Hanju/Services/Notifications/NotificationStateStore.swift`, `HanjuTests/NotificationTests.swift`, `README.md`, `design/01-direction.md`, `design/02-foundations.md`, `design/contrast-report.json`, `design/preview/index.html`, `design/reference/user-design-brief.txt`, `design/tokens.json`, `docs/adr/0004-local-notifications-and-reconciliation.md`, `docs/development/implementation-plan.md`, `docs/development/local-development.md`.

주요 구성: `DEVELOPMENT_HANDOFF.md`, `README.md`, `tokens.json`, `ADR 0004 로컬 알림과 저장 후 재조정`, `02-foundations.md`, `implementation-plan.md`, `01-direction.md`, `정돈한 생활의 페이지`. 전체 member_ids는 provenance.json에 있다.

### 21. 구현 인계와 네이티브 기반

전체 노드: **23개** · 응집도: **0.094862**.

출처: `DEVELOPMENT_HANDOFF.md`, `Hanju.xcodeproj/xcshareddata/xcschemes/Hanju.xcscheme`, `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Library/LibraryView.swift`, `Hanju/Features/Library/RoutineSnapshot.swift`, `Hanju/Features/Library/UnsavedChangesGuard.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `HanjuTests/RoutinePersistenceTests.swift`, `HanjuUITests/RoutineLibraryUITests.swift`, `docs/development/implementation-plan.md`, `docs/verification/2026-10-04-foundation.md`.

주요 구성: `주간 기록 구현과 후속 경계`, `LibraryView`, `Hanju 공유 실행 테스트 scheme`, `기반 네이티브 검증 기록`, `변경 초안 swipe 확인 구현`, `시간대 변경과 수행일 보존`, `네이티브 닫기 시도 연결`, `실행과 주간 기록 구현 인계`. 전체 member_ids는 provenance.json에 있다.

### 22. 주간 목록과 실행 탐색

전체 노드: **23개** · 응집도: **0.197628**.

출처: `Hanju/Features/Week/WeekView.swift`.

주요 구성: `WeekView`, `.load()`, `.rowActions()`, `.resume()`, `.show()`, `Editor`, `.editCompletion()`, `.rowDescription()`. 전체 member_ids는 provenance.json에 있다.

### 23. 오늘 실행과 알림 선택

전체 노드: **23개** · 응집도: **0.217391**.

출처: `Hanju/Features/Today/TodayView.swift`.

주요 구성: `TodayView`, `.perform()`, `.startNotification()`, `Editor`, `.activeActions()`, `.load()`, `RunningRoute`, `.complete()`. 전체 member_ids는 provenance.json에 있다.

### 24. 테스트 파일과 회귀 연결

전체 노드: **22개** · 응집도: **0.116883**.

출처: `Hanju/Features/Week/WeekView.swift`, `HanjuTests/ExecutionTests.swift`, `HanjuTests/NotificationTests.swift`, `HanjuTests/RecordsMigrationTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/SchemaMigrationTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuUITests/NotificationUITests.swift`, `HanjuUITests/WeekPlanUITests.swift`.

주요 구성: `실행 시간과 날짜 회귀검증`, `계획 취소 복원 UI 검증`, `현재 미완료와 쉬기 안내`, `실제 디스크 V4 이전 검증`, `기록 집계와 원자 저장 검증`, `루틴 저장 실패와 복원 검증`, `V1 디스크 이전 검증`, `계획과 실행 결합 회귀검증`. 전체 member_ids는 provenance.json에 있다.

### 25. 루틴 목록과 편집 진입

전체 노드: **21개** · 응집도: **0.152381**.

출처: `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`.

주요 구성: `RoutineListView`, `Focus`, `Editor`, `.changeArchive()`, `.load()`, `.edit()`, `.didDismiss()`, `.create()`. 전체 member_ids는 provenance.json에 있다.

### 26. 루틴 저장과 복원 검증

전체 노드: **21개** · 응집도: **0.223810**.

출처: `Hanju/Features/Library/RoutineWriter.swift`, `HanjuTests/RoutineLibraryTests.swift`.

주요 구성: `.persist()`, `.fetch()`, `.setArchived()`, `RoutineWriter`, `RoutineLibraryTests`, `.exerciseStore()`, `.find()`, `.testFailedEditAndArchiveLeavePersistentValuesAndOtherDraftAlone()`. 전체 member_ids는 provenance.json에 있다.

### 27. 계획 조정과 중립 건너뛰기

전체 노드: **20개** · 응집도: **0.136842**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`.

주요 구성: `PlanAdjustmentSheet`, `Mode`, `.selectedBinding()`, `.init()`, `.skip()`, `SwiftUI DismissAction.callAsFunction`, `.body`, `Bool`. 전체 member_ids는 provenance.json에 있다.

### 28. 실행 탐색과 완료 UI 검증

전체 노드: **20개** · 응집도: **0.263158**.

출처: `HanjuUITests/ExecutionUITests.swift`.

주요 구성: `ExecutionUITests`, `.reveal()`, `.createTodayPlans()`, `.pickDate()`, `.cancel()`, `.testPastWeekPausedResumeConfirmsSwitchAndReturnsToSamePlan()`, `.testTodayMoveDraftSurvivesSkipCancellationAndSkipReturnsToToday()`, `.testExplicitWeekAgendaOpensMovedDateAndSameDayWithoutStoppingRunning()`. 전체 member_ids는 provenance.json에 있다.

### 29. 제품 범위와 기록 정책

전체 노드: **19개** · 응집도: **0.198830**.

출처: `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/product-plan.md`.

주요 구성: `한 주 iPhone MVP`, `product-plan.md`, `Records 행동 우선 기록`, `채택 기술 구성`, `단일 실행 시간 기록`, `기기 내 오프라인 저장`, `생활 시각과 수행일 보존`, `AC-05 직접 완료와 수행일 정정`. 전체 member_ids는 provenance.json에 있다.

### 30. 탐색 보존과 저장 경계

전체 노드: **18개** · 응집도: **0.124183**.

출처: `.github/copilot-instructions.md`, `Hanju/Services/Notifications/NotificationCoordinator.swift`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `design/preview/index.html`, `docs/adr/0004-local-notifications-and-reconciliation.md`, `docs/product-plan.md`.

주요 구성: `05-swiftui-handoff.md`, `Running Routine 실행 화면`, `네이티브 검증 계약`, `캘린더 해제와 외부 변경`, `copilot-instructions.md`, `저장 후 직렬 재조정`, `기획 1.2 프리뷰 경계`, `네이티브 탭과 시트 탐색`. 전체 member_ids는 provenance.json에 있다.

### 31. 루틴 편집과 복원 UI 검증

전체 노드: **18개** · 응집도: **0.372549**.

출처: `HanjuUITests/RoutineLibraryUITests.swift`.

주요 구성: `RoutineLibraryUITests`, `.openEditor()`, `.routineRow()`, `.openLibrary()`, `.reveal()`, `.enter()`, `.finishInput()`, `.testCategoryChangeRemainsVisibleAndRevertedEditSwipesCleanly()`. 전체 member_ids는 provenance.json에 있다.

### 32. 날짜 입력과 화면 닫기

전체 노드: **16개** · 응집도: **0.133333**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Week/PlanDateFields.swift`.

주요 구성: `PlanDateFields`, `PlanDismissal`, `RoutineFieldError`, `.body()`, `View`, `Content`, `Bool`, `ViewModifier`. 전체 member_ids는 provenance.json에 있다.

### 33. 루틴 입력과 검증 오류

전체 노드: **16개** · 응집도: **0.216667**.

출처: `Hanju/Features/Library/RoutineDraft.swift`.

주요 구성: `RoutineDraft`, `Field`, `ValidationError`, `.optionalPositiveInteger()`, `.validate()`, `.validatedName()`, `String`, `Int`. 전체 member_ids는 provenance.json에 있다.

### 34. 알림 응답과 유한 완료

전체 노드: **16개** · 응집도: **0.208333**.

출처: `Hanju/Services/Notifications/NotificationCoordinator.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `.userNotificationCenter()`, `NotificationInbox`, `NotificationPresentationCompletion`, `NotificationCompletion`, `.attach()`, `.receive()`, `.init()`, `.noteResponseTimeout()`. 전체 member_ids는 provenance.json에 있다.

### 35. 개발 협업과 리뷰 규칙

전체 노드: **15개** · 응집도: **0.228571**.

출처: `.github/pull_request_template.md`, `AGENTS.md`, `CONTRIBUTING.md`, `docs/development/graphify.md`, `docs/development/review-workflow.md`, `docs/product-plan.md`.

주요 구성: `AGENTS.md`, `CONTRIBUTING.md`, `graphify.md`, `독립 리뷰와 Copilot 대기`, `최신 Codex와 Copilot 리뷰`, `review-workflow.md`, `main 병합 후 그래프 갱신`, `pull_request_template.md`. 전체 member_ids는 provenance.json에 있다.

### 36. 저장과 OS 실패 주입

전체 노드: **14개** · 응집도: **0.142857**.

출처: `HanjuTests/ExecutionTests.swift`, `HanjuTests/NotificationTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

주요 구성: `Failure`, `Failure`, `Failure`, `Failure`, `Failure`, `Failure`, `Error`, `disk`. 전체 member_ids는 provenance.json에 있다.

### 37. 하단 탭과 접근성 초점

전체 노드: **14개** · 응집도: **0.142857**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Library/LibraryView.swift`, `Hanju/Features/Week/WeekView.swift`.

주요 구성: `Focus`, `Tab`, `Destination`, `Hashable`, `library`, `records`, `settings`, `today`. 전체 member_ids는 provenance.json에 있다.

### 38. 주간 기록과 메모 조회 값

전체 노드: **14개** · 응집도: **0.175824**.

출처: `Hanju/Features/Records/RecordsSnapshot.swift`, `Hanju/Features/Records/RecordsView.swift`.

주요 구성: `WeeklyRecordsSnapshot`, `RoutineCount`, `RecordedTimeSummary`, `WeeklyMemoSnapshot`, `.didDismiss()`, `Int`, `LocalDate`, `String`. 전체 member_ids는 provenance.json에 있다.

### 39. 기록 조회와 원문 저장

전체 노드: **14개** · 응집도: **0.307692**.

출처: `Hanju/Features/Records/RecordsStore.swift`, `HanjuTests/RecordsMigrationTests.swift`.

주요 구성: `.saveMemo()`, `.fetchMemo()`, `.fetch()`, `.testMemoFailureAndSuccessfulMoveEvidenceSurviveDiskReopen()`, `.memo()`, `RecordsStore`, `.isolatedContext()`, `ModelContext.fetch 사용`. 전체 member_ids는 provenance.json에 있다.

### 40. 주간 요청과 조정 종류

전체 노드: **14개** · 응집도: **0.175824**.

출처: `Hanju/Features/Week/WeekView.swift`.

주요 구성: `Kind`, `WeekRequest`, `Caller`, `.init()`, `.saved()`, `LocalDate`, `records`, `today`. 전체 member_ids는 provenance.json에 있다.

### 41. 앱 시작과 알림 위임

전체 노드: **14개** · 응집도: **0.164835**.

출처: `Hanju/Features/Library/UnsavedChangesGuard.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `NotificationAppDelegate`, `.application()`, `UUID.init(uuidString:)`, `전면 전환 없는 재알림`, `앱 시작 위임과 응답`, `단일 시각과 주간 반복`, `SystemNotificationClient.swift`, `Bool`. 전체 member_ids는 provenance.json에 있다.

### 42. 주간 계획과 복원 UI 검증

전체 노드: **14개** · 응집도: **0.340659**.

출처: `HanjuUITests/WeekPlanUITests.swift`.

주요 구성: `WeekPlanUITests`, `.reveal()`, `.choose()`, `.createRoutine()`, `.testTodayRecoveryKeepsUnselectedAndReturnsToCallerOnCancel()`, `.pickDate()`, `.testCreateCancelSkipRestoreAndRelaunch()`, `.testPreviousPlanRequiresExplicitConfirmationAndExcludesArchivedRoutines()`. 전체 member_ids는 provenance.json에 있다.

### 43. 실행 복귀와 호출자 보존

전체 노드: **12개** · 응집도: **0.196970**.

출처: `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/WeekView.swift`, `Hanju/Persistence/PersistenceStore.swift`, `HanjuUITests/ExecutionUITests.swift`, `design/04-screens.md`.

주요 구성: `지난주 재개와 호출 복귀`, `실행 완료와 복원 UI 검증`, `실행 제어와 시간 표시`, `앱 수명 실행 명령`, `이동 초안과 중립 건너뛰기`, `지난 작업 재개 계약`, `V4 저장소와 실행 수명`, `PersistenceStore.swift`. 전체 member_ids는 provenance.json에 있다.

### 44. 완료 기록과 수행일 편집

전체 노드: **12개** · 응집도: **0.196970**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`.

주요 구성: `CompletionSheet`, `.save()`, `.undo()`, `SwiftUI DismissAction.callAsFunction`, `.init()`, `.body`, `.dateBinding`, `.dirty`. 전체 member_ids는 provenance.json에 있다.

### 45. 행동 우선 기록과 이동 근거

전체 노드: **12개** · 응집도: **0.166667**.

출처: `Hanju/Features/Records/RecordsStore.swift`, `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `HanjuUITests/RecordsUITests.swift`.

주요 구성: `수행일별 완료와 실천 횟수`, `주별 메모 원문 원자 저장`, `행동 우선 기록 장부`, `주별 메모 초안과 재시도`, `주별 메모 원문 저장`, `메모 저장과 계획 호출 복귀`, `날짜 이동과 근거 원자 저장`, `최초 실제 날짜 이동 근거`. 전체 member_ids는 provenance.json에 있다.

### 46. 실제 OS 예약과 테스트 경계

전체 노드: **12개** · 응집도: **0.212121**.

출처: `Hanju/Services/Notifications/SystemNotificationClient.swift`, `HanjuTests/NotificationTests.swift`.

주요 구성: `NotificationSystemSnapshot`, `SystemNotificationClient`, `.summary()`, `.add()`, `.snapshot()`, `.removeDelivered()`, `.removePending()`, `UNUserNotificationCenter.add`. 전체 member_ids는 provenance.json에 있다.

### 47. 주간 기록과 메모 저장 계약

전체 노드: **11개** · 응집도: **0.290909**.

출처: `docs/adr/0003-weekly-records-and-memo.md`, `docs/development/data-contracts.md`, `docs/development/implementation-plan.md`.

주요 구성: `수행일별 기록과 메모 결정`, `주간 기록과 메모 저장 계약`, `부담 없는 계획과 호출자 복귀`, `실제 첫 날짜 이동 근거`, `확정 시간과 합계 한계`, `주별 초안과 저장 세대`, `수행일 장부와 루틴 횟수`, `주별 메모 원문 보존`. 전체 member_ids는 provenance.json에 있다.

### 48. 알림 요청과 OS 어댑터

전체 노드: **11개** · 응집도: **0.200000**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `NotificationClient`, `Request`, `.add()`, `.removeDelivered()`, `.removePending()`, `.snapshot()`, `.authorize()`, `.removeDelivered()`. 전체 member_ids는 provenance.json에 있다.

### 49. V4 이전과 원본 검증

전체 노드: **11개** · 응집도: **0.272727**.

출처: `HanjuTests/RecordsMigrationTests.swift`.

주요 구성: `.writeFixture()`, `.verifyFixture()`, `RecordsMigrationTests`, `.testActualV1V2V3DiskStoresMigrateToV4WithoutInventingMoveHistory()`, `Fixture`, `Int`, `ExecutionSnapshot`, `ModelContainer`. 전체 member_ids는 provenance.json에 있다.

### 50. 탭 요청과 편집 보호

전체 노드: **10개** · 응집도: **0.311111**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Services/Notifications/NotificationPresentationGate.swift`.

주요 구성: `View`, `AppTabs`, `NotificationPresentationGate`, `RecordsNotificationRequest`, `.body()`, `.notificationPresentation()`, `NotificationPresentationGate.swift`, `Bool`. 전체 member_ids는 provenance.json에 있다.

### 51. 루틴 행과 목록 조회 값

전체 노드: **10개** · 응집도: **0.200000**.

출처: `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineSnapshot.swift`.

주요 구성: `RoutineSnapshot`, `RoutineRow`, `.init()`, `.categories`, `.body`, `.details`, `String`, `Bool`. 전체 member_ids는 provenance.json에 있다.

### 52. 루틴 디스크와 실패 검증

전체 노드: **10개** · 응집도: **0.266667**.

출처: `Hanju/Features/Library/RoutineWriter.swift`, `HanjuTests/RoutinePersistenceTests.swift`.

주요 구성: `.create()`, `RoutinePersistenceTests`, `.writeRoutine()`, `.testBlankNameCannotCreateRoutine()`, `.testInMemoryContainersDoNotShareData()`, `.testSaveFailurePreservesDraftAndRetryCreatesOnlyOneRoutine()`, `.testSaveAndReopenRetainsIdentityAndOptionalValues()`, `Date`. 전체 member_ids는 provenance.json에 있다.

### 53. 앱 환경과 공유 서비스

전체 노드: **9개** · 응집도: **0.222222**.

출처: `Hanju/App/HanjuApp.swift`, `Hanju/Persistence/PersistenceStore.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `HanjuApp`, `.openServices()`, `.open()`, `.body`, `App`, `.notifications`, `.persistence`, `PersistenceStore`. 전체 member_ids는 provenance.json에 있다.

### 54. 메모 재시도와 실패 보존

전체 노드: **9개** · 응집도: **0.305556**.

출처: `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

주요 구성: `초안 변경 여부별 재시도`, `입력 세대 확인과 동기 저장`, `메모 재시도와 버튼 문구`, `주입 메모 쓰기 호출`, `실패 뒤 편집 보존 검증`, `메모 세대와 실패 보존 검증`, `재조회 실패 읽기 검증`, `WeeklyMemoCoordinator.swift`. 전체 member_ids는 provenance.json에 있다.

### 55. 메모 저장 상태 표현

전체 노드: **9개** · 응집도: **0.222222**.

출처: `Hanju/Features/Records/WeeklyMemoCoordinator.swift`.

주요 구성: `Status`, `Draft`, `.isDirty`, `failed`, `idle`, `pending`, `saved`, `saving`. 전체 member_ids는 provenance.json에 있다.

### 56. 실행 강조와 색상 에셋

전체 노드: **8개** · 응집도: **0.250000**.

출처: `Hanju/Assets.xcassets/AccentColor.colorset/Contents.json`, `Hanju/Assets.xcassets/AccentSubtle.colorset/Contents.json`, `Hanju/Assets.xcassets/Background.colorset/Contents.json`, `Hanju/Assets.xcassets/OnAccent.colorset/Contents.json`, `Hanju/Assets.xcassets/Surface.colorset/Contents.json`, `Hanju/Assets.xcassets/TextPrimary.colorset/Contents.json`, `Hanju/Assets.xcassets/TextSecondary.colorset/Contents.json`, `Hanju/Design/DesignTokens.swift`.

주요 구성: `실행 강조와 대비 색상`, `실행 패널의 연한 강조색`, `강조 버튼의 전경 색상`, `AccentColor.colorset/Contents.json`, `Background.colorset/Contents.json`, `Surface.colorset/Contents.json`, `TextPrimary.colorset/Contents.json`, `TextSecondary.colorset/Contents.json`. 전체 member_ids는 provenance.json에 있다.

### 57. 앱 저장소와 모델 구성

전체 노드: **7개** · 응집도: **0.333333**.

출처: `Hanju/Persistence/PersistenceStore.swift`.

주요 구성: `.makeContainer()`, `PersistenceStore`, `ExecutionRecorder`, `ModelContainer`, `Bool`, `String`, `URL`. 전체 member_ids는 provenance.json에 있다.

### 58. 실행 상세와 제어 동작

전체 노드: **7개** · 응집도: **0.333333**.

출처: `Hanju/Features/Execution/RunningRoutineView.swift`.

주요 구성: `RunningRoutineView`, `.perform()`, `.resume()`, `ExecutionSnapshot`, `String`, `UUID`, `Void`. 전체 member_ids는 provenance.json에 있다.

### 59. 계획 초안과 횟수 배분

전체 노드: **7개** · 응집도: **0.619048**.

출처: `Hanju/Features/Week/PlanDraft.swift`.

주요 구성: `Entry`, `.allocate()`, `.init()`, `.validateCounts()`, `String`, `Int`, `UUID`. 전체 member_ids는 provenance.json에 있다.

### 60. V1 루틴 영속 필드

전체 노드: **7개** · 응집도: **0.428571**.

출처: `Hanju/Models/HanjuSchemaV1.swift`.

주요 구성: `RoutineTemplate`, `.init()`, `Date`, `String`, `UUID`, `Bool`, `Int`. 전체 member_ids는 provenance.json에 있다.

### 61. OS 알림 권한 상태

전체 노드: **7개** · 응집도: **0.285714**.

출처: `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `Authorization`, `authorized`, `denied`, `ephemeral`, `notDetermined`, `provisional`, `unknown`. 전체 member_ids는 provenance.json에 있다.

### 62. 선호 요일과 날짜 계약

전체 노드: **6개** · 응집도: **0.333333**.

출처: `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Models/LocalDate.swift`, `docs/development/data-contracts.md`.

주요 구성: `월요일 기준 선호 요일 계약`, `선택 입력과 선호 요일 검증`, `시간대 독립 계획 날짜`, `현지 시각과 DST 설명`, `LocalDate.swift`, `RoutineDraft.swift`. 전체 member_ids는 provenance.json에 있다.

### 63. 명시 목록과 타이머 보존

전체 노드: **6개** · 응집도: **0.400000**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Week/WeekView.swift`, `HanjuUITests/ExecutionUITests.swift`.

주요 구성: `명시 agenda 목록과 타이머 보존`, `주간 계획과 늦은 완료`, `탭 탐색과 실행 연결`, `같은 날짜의 명시 agenda 요청`, `성공 날짜 목록과 취소 상세 보존`, `명시 목록 전환 회귀 정의`. 전체 member_ids는 provenance.json에 있다.

### 64. 네이티브 기반 기술 결정

전체 노드: **4개** · 응집도: **0.833333**.

출처: `docs/adr/0001-native-ios-foundation.md`.

주요 구성: `0001-native-ios-foundation.md`, `iOS 17 Swift 6 기반 채택`, `버전 스키마와 로컬 저장`, `개인 기기 설치 범위`. 전체 member_ids는 provenance.json에 있다.

### 65. 에셋 카탈로그 메타데이터

전체 노드: **1개** · 응집도: **1.000000**.

출처: `Hanju/Assets.xcassets/Contents.json`.

주요 구성: `Assets.xcassets/Contents.json`. 전체 member_ids는 provenance.json에 있다.

## God Nodes

- `NotificationCoordinator` — 차수 57 · `Hanju/Services/Notifications/NotificationCoordinator.swift:L5`.
- `ExecutionSnapshot` — 차수 56 · `Hanju/Features/Execution/ExecutionSnapshot.swift:L3`.
- `Hanju 네이티브 프로젝트` — 차수 52 · `Hanju.xcodeproj/project.pbxproj:L481`.
- `LocalDate` — 차수 49 · `Hanju/Models/LocalDate.swift:L4`.
- `NotificationTests` — 차수 46 · `HanjuTests/NotificationTests.swift:L6`.
- `.fixture()` — 차수 43 · `HanjuTests/NotificationTests.swift:L51`.
- `NotificationPersistentState` — 차수 38 · `Hanju/Services/Notifications/NotificationPlan.swift:L107`.
- `.move()` — 차수 37 · `Hanju/Features/Week/PlanWriter.swift:L37`.

## Surprising Connections

원래 열린 route의 실행 명령과 normal checkpoint 수명은 서로 다른 generation을 건드리지 않는 조건으로 연결된다. posting시각 FIFO와 원자JSON은 Task 지연·파일실패에 전이를 보존하지만 DB/JSON 사이 프로세스 종료의 원자성을 보장하지 않는다. 이는 원문 경계이며 실행 성공을 새로 증명하지 않는다.

## Suggested Questions

- 원래 묶음 세대가 제거된 뒤 남은 대상을 시작할 때 새 세대와 새 C는 어떻게 보존되는가?
- 기본 알림의 종료 근거는 시간대 변경·receipt 정리·구버전 파일 이전 뒤 어떤 경로로 유지되는가?
- didSave posting시각부터 FIFO prefix 저장·ack·OS await까지 실패 경계는 어디인가?

## 건강 상태와 해석 한계

- 105개 main 추적 입력 중 98개는 동일하고 7개를 갱신했다(Swift5·ADR/데이터계약2, 신규/삭제0). 불변 관계3261개와 소유 node의 전체 payload·방향을 보존했다. 이전 완전 원시 캐시와 입력 SHA256을 검증했으며 단순 graph export로 복원하지 않았다.
- 변경 Swift5파일에서 설치 Graphify AST215개 node occurrence/887개 raw관계를 실제 추출했다. receiver/동명 오인33개(calls13/reads_value20)를 교정하고 fresh/current 전체payload·source_text를 보존했다. 배열 append와 FIFO append, recorder.read와 테스트 EventClock.read를 구분한다. 지역 sources/changed 값 읽기는 INFERRED이며 실제 메서드 호출로 단정하지 않는다.
- 기존 receiver 보정69개는 불변이며 변경소스의 이전8개 보정은 새 원문 위치로 다시 적용했다. 이전 LocalTime.init 오인1개는 이번에 다른 init target으로 방출되어 새 보정으로 기록했다. 기존 CJS FULL/full 분리·관계11개·export2개와 qualified type/공유stub 이력은 그대로 유지한다. Swift overload·중첩함수/closure·고차함수와 producer 중복 억제 한계가 남으며 완전한 컴파일러 타입 추론은 아니다.
- 제거 ID2개는 소스의 mark→markStartReceipt 이름/동작 변경1개와 RecordsUI Date 사용stub의 파일별 ID 정규화1개다. 관련 기존7개 관계의 전후 전체payload와 이전/현재 원문 앵커를 대응했다. 입력 삭제나 강제 export는 없다. 공유node의 기존 불변 소유 metadata 보존과 새 빈 타입 사용anchor도 fresh/current node 감사에 남긴다.
- 무방향 topology는 여러 관계와 방향을 합친다. 각 link.evidence에 원시 4236개 관계의 모든 필드를 보존했고 endpoint 쌍별 Counter로 검증했다. 단일 link 속성 대신 evidence를 읽어야 한다.
- 고립 에셋 카탈로그 Contents.json1개와 기존 self-edge2개를 보존한다. Inbox.shared 생성자 표현은 메서드 재귀가 아니며 CJS verifyResults.visit의 자식 순회는 의도된 재귀다. 전체 hub·AST 멤버·외부 타입을 응집도에서 제외하지 않으며 큰 커뮤니티와 낮은 점수를 숨기지 않는다.
- 설치 detector는 design/tokens.json 파일명으로 sensitive1개를 표시했다. 실제 디자인 값임을 원문/불변hash로 재확인해 명시 포함한다. 미분류 pbxproj/scheme을 포함하고 skills-lock.json은 외부 스킬 입력으로 제외한다. 비밀키·사용자 데이터는 입력하지 않는다.
- #45는 열린 원래 묶음의 유효 대상 명시 시작, #46은 명시 본문 재열기의 읽기 화면 교체, #47은 영속 기본 알림checkpoint/FIFO/구버전 근거/DST를 보완했다. DB와 알림JSON은 하나의transaction이 아니며 JSON전 프로세스 종료로 소실된 전이와 완전 소실 이력을 재구성할 수 없다. 같은값 재저장은 복구가 아니다. 그래프 작업은 앱/네이티브/Node/원격CI를 실행하거나 main전체회귀 완료를 새로 확인하지 않았다. 캘린더#12·실기기/iOS17/전체접근성/2주인수#13은 후속이다.
- 실제 모델명·입출력 토큰·비용은 확인할 수 없어 null이다. 현재 Codex 세션이 의미 추출과 모든 커뮤니티 라벨을 작성했고 외부 LLM API를 사용하지 않았다. 비용0을 뜻하지 않는다.

## 사용 기록

현재 Codex 세션에서 의미 추출·전체 한국어 라벨을 작성했다. 모델명·입출력 토큰·비용은 알 수 없음(null). 외부 LLM API 없음. 네이티브/원격CI 결과는 해당제품 이슈와 실제 실행 근거를 확인한다.
