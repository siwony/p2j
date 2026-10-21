# 프로젝트 지식 그래프

분석 기준: main `af82a53c8c2d6cc5107e83499d3eae78a21a2665` · 이슈 #11 · 코드 PR #42 · Graphify 0.9.68. 결과 PR의 병합 SHA와 분석 대상 SHA는 별개다.

## 전체 집계

입력 **103개**(코드 62개, 문서·설정 41개), 노드 **1380개**, 원시 관계 **3717개**, 무방향 연결 **3506개**, 커뮤니티 **74개**다. 고립 노드 1개, 차수 0 또는 1인 노드 373개, 생성자 self-edge 1개다.

파일 hub·AST 멤버·외부 타입을 포함한 전체 membership을 사용하며 thin 필터는 없다. 응집도는 설치 Graphify score_all의 원값이다.

## 이번 증분 분석

이전 main `089b3ee2bffc2a4e0e7b018f3eee6a2916368666`의 94개 입력 해시와 완전한 원시 캐시를 검증했다. 81개 입력은 같고 22개를 갱신했다(기존 변경 13개·신규 9개·삭제 0개). 불변 원시 관계 2375개와 소유 node payload·방향을 그대로 유지했다. 변경 코드 15파일에서 AST 405개 node occurrence/1082개 관계를 재추출하고 현재 Codex가 변경 문서·코드 의미를 원문 앵커와 함께 통합했다.

#11은 계획/실행 독립 알림 설정, 명시 권한 요청, 시각 있는 회차와 날짜별 묶음, 계획 주간 반복, 수동 30분 재알림을 추가한다. 버전형 원자 JSON이 설정·원래 대상·고정 dueAt·세대·receipt를 소유한다. 앱 저장 성공 뒤 직렬 drain이 실제 OS pending/delivered와 조정하며 OS 실패는 별도 대기 상태로 남긴다. V1–V4와 기존 writer는 유지한다.

본문 탭은 보기이며 자동 실행이 아니다. 시작은 원래 버전과 단일 실행/교체 확인을 거친다. 계획 알림은 현재 주 Records로 열고 기존 다음 주 계획 동선을 쓴다. 편집 중 외부 요청은 초안·탭·날짜를 보존하고 닫은 뒤에도 명시 열기를 기다린다. Today 임시 원래 대상과 불투명 제목은 일반 당일 필터나 전역 토큰을 변경하지 않는다.

24개 실제 AST 동명/receiver 오인을 전후 payload·source_text와 함께 교정했다. 지역 draft/sources/changed 값은 INFERRED 타입 읽기로만 기술했다. 불변 receiver 54개/export 2개 보정은 보존했다. Records stub 6개/13개 관계의 ID·원문 이동과 qualified outer type 1개를 대응했으며 강제 export나 실제 소스 삭제는 없다. 새 74개 커뮤니티의 모든 구성원과 출처를 읽어 이름을 다시 정했다.

캘린더 #12와 실제 iPhone 잠금/종료 전달·Focus·iOS 17·전체 접근성·2주 인수 #13은 후속이다. 이 그래프 작업에서는 앱/네이티브 테스트나 원격 CI를 새로 실행하지 않았다. 이전 문서의 단계별 역사 설명을 현재 미구현 판정으로 사용하지 않는다. 전체 MVP 또는 AC13 완료가 아니다.

## 이전 결과와 대응

노드 1140→1380, 원시 관계 2983→3717, 무방향 연결 2798→3506, 커뮤니티 52→74다. 6개 제거 ID는 타입 사용 stub 정규화이며 모든 이전 incident 관계와 현재 근거를 provenance에 보존했다. 유효 endpoint·출처 줄·커뮤니티 membership·evidence Counter를 전수 확인한다.

## 커뮤니티 전체 목록

| ID | 이름 | 전체 노드 | 응집도 |
|---:|---|---:|---:|
| 0 | 계획 명령과 회차 이전 | 65 | 0.088462 |
| 1 | 이슈 연결과 Git 검증 | 52 | 0.074661 |
| 2 | 입력 탐색과 설정 UI 검증 | 43 | 0.122924 |
| 3 | 닫기 시도와 UIKit 위임 | 38 | 0.083926 |
| 4 | 알림 대상과 예약 계산 | 38 | 0.119488 |
| 5 | 실행 제어와 재실행 복구 | 34 | 0.117647 |
| 6 | 알림 저장과 전이 검증 | 33 | 0.242424 |
| 7 | 버전 스키마와 디스크 이전 | 32 | 0.090726 |
| 8 | 알림 조회와 화면 보호 | 30 | 0.119540 |
| 9 | 명령 오류와 입력 안내 | 29 | 0.068966 |
| 10 | 루틴 편집과 버리기 확인 | 27 | 0.116809 |
| 11 | 오늘 실행과 알림 선택 | 27 | 0.179487 |
| 12 | 화면 명세와 알림 진입 | 26 | 0.110769 |
| 13 | 기록 장부와 주 탐색 | 26 | 0.126154 |
| 14 | 주별 메모와 재시도 검증 | 26 | 0.246154 |
| 15 | 프로젝트 파일과 화면 연결 | 25 | 0.146667 |
| 16 | 제품 계약과 후속 연동 | 25 | 0.113333 |
| 17 | 주간 선택과 초안 상태 | 25 | 0.126667 |
| 18 | 완료 입력과 화면 차단 | 24 | 0.101449 |
| 19 | 실행 원본과 복구 계약 | 23 | 0.102767 |
| 20 | 시각 기반과 알림 저장 계약 | 23 | 0.150198 |
| 21 | 실행 명령과 원자 저장 | 23 | 0.343874 |
| 22 | 주간 목록과 실행 탐색 | 22 | 0.207792 |
| 23 | 기록 집계와 실패 검증 | 22 | 0.259740 |
| 24 | 루틴 입력과 저장 검증 | 21 | 0.171429 |
| 25 | 루틴 목록과 편집 진입 | 21 | 0.152381 |
| 26 | 루틴 저장과 복원 검증 | 21 | 0.223810 |
| 27 | 완료 시간과 날짜 검증 | 20 | 0.284211 |
| 28 | 계획 조정과 중립 건너뛰기 | 20 | 0.136842 |
| 29 | 실행 탐색과 완료 UI 검증 | 20 | 0.263158 |
| 30 | 제품 범위와 기록 정책 | 19 | 0.198830 |
| 31 | 메모 초안과 앱 수명 | 19 | 0.157895 |
| 32 | 재알림 의도와 파일 저장 | 18 | 0.156863 |
| 33 | 탐색 보존과 저장 경계 | 18 | 0.124183 |
| 34 | 지역 날짜와 주 경계 | 17 | 0.154412 |
| 35 | 구현 인계와 네이티브 CI | 17 | 0.132353 |
| 36 | 주간 기록과 이동 근거 | 17 | 0.169118 |
| 37 | 테스트 파일과 회귀 연결 | 16 | 0.166667 |
| 38 | 앱 시작과 알림 위임 | 16 | 0.150000 |
| 39 | 알림 응답과 유한 완료 | 16 | 0.208333 |
| 40 | 개발 협업과 리뷰 규칙 | 15 | 0.228571 |
| 41 | 하단 탭과 명시 요청 | 15 | 0.142857 |
| 42 | 알림 설정과 시간 입력 | 15 | 0.333333 |
| 43 | 주간 요청과 조정 종류 | 15 | 0.161905 |
| 44 | 실행 기록과 구간 모델 | 15 | 0.200000 |
| 45 | 저장과 OS 실패 주입 | 14 | 0.142857 |
| 46 | 루틴 행과 목록 조회 값 | 14 | 0.142857 |
| 47 | 주간 기록과 메모 조회 값 | 14 | 0.175824 |
| 48 | 기록 조회와 원문 저장 | 14 | 0.307692 |
| 49 | 현지 시각과 DST 해석 | 14 | 0.197802 |
| 50 | 주간 계획과 복원 UI 검증 | 14 | 0.340659 |
| 51 | 완료 기록과 수행일 편집 | 13 | 0.166667 |
| 52 | 실행 복귀와 알림 제목 | 12 | 0.181818 |
| 53 | V1 루틴 디스크 보존 | 12 | 0.212121 |
| 54 | 명시 목록과 타이머 보존 | 11 | 0.200000 |
| 55 | 실제 OS 알림 어댑터 | 11 | 0.218182 |
| 56 | V4 이전과 원본 검증 | 11 | 0.272727 |
| 57 | 실행 시계와 시간 계산 | 10 | 0.288889 |
| 58 | 회차 조회와 미완료 상태 | 10 | 0.200000 |
| 59 | 행동 우선 기록과 메모 | 9 | 0.250000 |
| 60 | 메모 저장 상태 표현 | 9 | 0.222222 |
| 61 | 날짜와 시각 입력 | 8 | 0.250000 |
| 62 | 실행 강조와 색상 에셋 | 8 | 0.250000 |
| 63 | 실제 예약과 테스트 클라이언트 | 8 | 0.285714 |
| 64 | 앱 저장소와 모델 구성 | 7 | 0.333333 |
| 65 | 기록 시간과 표시 형식 | 7 | 0.523810 |
| 66 | 계획 초안과 횟수 배분 | 7 | 0.619048 |
| 67 | OS 알림 권한 상태 | 7 | 0.285714 |
| 68 | 앱 환경과 공유 서비스 | 6 | 0.333333 |
| 69 | 계획 회차 상태 표현 | 6 | 0.333333 |
| 70 | 선호 요일과 날짜 계약 | 5 | 0.400000 |
| 71 | 주간 화면 접근성 초점 | 5 | 0.400000 |
| 72 | 네이티브 기반 기술 결정 | 4 | 0.833333 |
| 73 | 에셋 카탈로그 메타데이터 | 1 | 1.000000 |

### 0. 계획 명령과 회차 이전

전체 노드: **65개** · 응집도: **0.088462**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `HanjuTests/WeekPlanTests.swift`.

주요 구성: `.move()`, `.confirm()`, `PlanDraft`, `.skip()`, `.rest()`, `WeekPlanTests`, `.replan()`, `PlanWriter`. 전체 member_ids는 provenance.json에 있다.

### 1. 이슈 연결과 Git 검증

전체 노드: **52개** · 응집도: **0.074661**.

출처: `.githooks/commit-msg`, `.github/ISSUE_TEMPLATE/bug.md`, `.github/ISSUE_TEMPLATE/task.md`, `.github/scripts/pr-policy.cjs`, `.github/scripts/pr-policy.test.cjs`, `.github/scripts/test_commit_msg.py`, `.github/workflows/pr-policy.yml`, `CONTRIBUTING.md`, `docs/development/review-workflow.md`.

주요 구성: `CommitMessageHookTests`, `.git()`, `.commit()`, `.reword()`, `.assert_rejected()`, `이슈 연결 Git 규칙`, `.test_invalid_or_missing_rebase_head_name_rejected()`, `PR 정책과 main 보호`. 전체 member_ids는 provenance.json에 있다.

### 2. 입력 탐색과 설정 UI 검증

전체 노드: **43개** · 응집도: **0.122924**.

출처: `Hanju/Features/Records/RecordsView.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuUITests/NotificationUITests.swift`, `HanjuUITests/RecordsUITests.swift`, `HanjuUITests/RoutineLibraryUITests.swift`.

주요 구성: `RoutineLibraryUITests`, `RecordsUITests`, `.openEditor()`, `.routineRow()`, `.openLibrary()`, `.reveal()`, `.reveal()`, `.selectWeek()`. 전체 member_ids는 provenance.json에 있다.

### 3. 닫기 시도와 UIKit 위임

전체 노드: **38개** · 응집도: **0.083926**.

출처: `Hanju/Features/Library/UnsavedChangesGuard.swift`.

주요 구성: `Coordinator`, `UnsavedChangesGuard`, `ObserverController`, `.attach()`, `.forwardingTarget()`, `.presentationControllerShouldDismiss()`, `.responds()`, `.dismantleUIViewController()`. 전체 member_ids는 provenance.json에 있다.

### 4. 알림 대상과 예약 계산

전체 노드: **38개** · 응집도: **0.119488**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Models/LocalDate.swift`, `Hanju/Services/Notifications/NotificationPlan.swift`.

주요 구성: `NotificationTicket`, `NotificationEnvelope`, `.make()`, `NotificationPreferences`, `NotificationTarget`, `NotificationRoute`, `Kind`, `.ticket()`. 전체 member_ids는 provenance.json에 있다.

### 5. 실행 제어와 재실행 복구

전체 노드: **34개** · 응집도: **0.117647**.

출처: `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `HanjuTests/ExecutionMigrationTests.swift`.

주요 구성: `ExecutionSnapshot`, `.read()`, `ExecutionRecorder`, `.testDetectedColdUncertaintySurvivesDiskReopenAndFailedFlagSavePreservesRunning()`, `.refresh()`, `.testActualV2DiskMigrationPreservesPlansAndRunningRecordReopensInV3()`, `RunningRoutineView`, `.complete()`. 전체 member_ids는 provenance.json에 있다.

### 6. 알림 저장과 전이 검증

전체 노드: **33개** · 응집도: **0.242424**.

출처: `Hanju/Services/Notifications/NotificationCoordinator.swift`, `HanjuTests/NotificationTests.swift`.

주요 구성: `NotificationTests`, `.fixture()`, `.attach()`, `Client`, `.updatePreferences()`, `.preferences()`, `.testSaveFailureRetainsOriginalPendingAndReceiptDoesNotConsumeSchedule()`, `.idle()`. 전체 member_ids는 provenance.json에 있다.

### 7. 버전 스키마와 디스크 이전

전체 노드: **32개** · 응집도: **0.090726**.

출처: `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `HanjuTests/SchemaMigrationTests.swift`.

주요 구성: `.migrateAndAddPlan()`, `HanjuSchemaV1`, `HanjuSchemaV4`, `HanjuMigrationPlan`, `SchemaMigrationTests`, `.verifyRoutine()`, `.writeV1Fixture()`, `OccurrenceDateMove`. 전체 member_ids는 provenance.json에 있다.

### 8. 알림 조회와 화면 보호

전체 노드: **30개** · 응집도: **0.119540**.

출처: `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Services/Notifications/NotificationCoordinator.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `NotificationCoordinator`, `.drain()`, `NotificationClient`, `.targets()`, `.validTargets()`, `.setVisibleTargets()`, `.init()`, `.openPending()`. 전체 member_ids는 provenance.json에 있다.

### 9. 명령 오류와 입력 안내

전체 노드: **29개** · 응집도: **0.068966**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Services/Notifications/NotificationStateStore.swift`.

주요 구성: `PlanError`, `ExecutionError`, `NotificationFailure`, `WriteError`, `LocalizedError`, `String`, `anotherRunning`, `changed`. 전체 member_ids는 provenance.json에 있다.

### 10. 루틴 편집과 버리기 확인

전체 노드: **27개** · 응집도: **0.116809**.

출처: `Hanju/Features/Library/RoutineEditorSheet.swift`.

주요 구성: `RoutineEditorSheet`, `.archive()`, `SwiftUI DismissAction.callAsFunction`, `.dayName()`, `.init()`, `.save()`, `.toggleDay()`, `PendingAction`. 전체 member_ids는 provenance.json에 있다.

### 11. 오늘 실행과 알림 선택

전체 노드: **27개** · 응집도: **0.179487**.

출처: `Hanju/Features/Today/TodayView.swift`, `Hanju/Services/Notifications/NotificationCoordinator.swift`, `Hanju/Services/Notifications/NotificationPresentationGate.swift`.

주요 구성: `TodayView`, `.start()`, `View`, `.perform()`, `.startNotification()`, `Editor`, `.activeActions()`, `.load()`. 전체 member_ids는 provenance.json에 있다.

### 12. 화면 명세와 알림 진입

전체 노드: **26개** · 응집도: **0.110769**.

출처: `Hanju/Features/Settings/SettingsView.swift`, `Hanju/Features/Today/TodayView.swift`, `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/adr/0004-local-notifications-and-reconciliation.md`, `docs/product-plan.md`.

주요 구성: `04-screens.md`, `03-components.md`, `Week 이번 주 화면`, `Today 오늘 화면`, `PlannedOccurrence`, `Reschedule 일정 이동`, `WeekMemo 입력`, `CalendarSheet 주별 연결`. 전체 member_ids는 provenance.json에 있다.

### 13. 기록 장부와 주 탐색

전체 노드: **26개** · 응집도: **0.126154**.

출처: `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Records/RecordsView.swift`.

주요 구성: `RecordsView`, `.now()`, `.load()`, `.edit()`, `Focus`, `.changeWeek()`, `.recordsHeader()`, `.consumeNotificationRequest()`. 전체 member_ids는 provenance.json에 있다.

### 14. 주별 메모와 재시도 검증

전체 노드: **26개** · 응집도: **0.246154**.

출처: `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

주요 구성: `WeeklyMemoCoordinator`, `.flush()`, `.load()`, `.draft()`, `.update()`, `.retry()`, `.testFailedWeekDraftSurvivesOtherWeekSaveReloadAndRetry()`, `.testDebounceKeepsLatestTextAndCapturedWeekWithoutDuplicateFlush()`. 전체 member_ids는 provenance.json에 있다.

### 15. 프로젝트 파일과 화면 연결

전체 노드: **25개** · 응집도: **0.146667**.

출처: `Hanju.xcodeproj/project.pbxproj`, `Hanju/App/AppTabs.swift`, `Hanju/App/HanjuApp.swift`, `Hanju/Design/DesignTokens.swift`, `Hanju/Features/Library/LibraryView.swift`, `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Features/Library/RoutineEditorSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Features/Settings/SettingsView.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/RoutineTemplate.swift`, `Hanju/Services/Notifications/NotificationPresentationGate.swift`, `HanjuUITests/RoutineLibraryUITests.swift`.

주요 구성: `Hanju 네이티브 프로젝트`, `project.pbxproj`, `DesignTokens`, `날짜 시각 입력과 설명`, `알림 대상과 현재 장부`, `앱 수명 실행 환경 주입`, `편집 시트와 보관 UI 검증`, `SwiftUI`. 전체 member_ids는 provenance.json에 있다.

### 16. 제품 계약과 후속 연동

전체 노드: **25개** · 응집도: **0.113333**.

출처: `design/03-components.md`, `design/05-swiftui-handoff.md`, `docs/development/data-contracts.md`, `docs/development/implementation-plan.md`, `docs/development/planning-revision-1.3.md`, `docs/product-plan.md`.

주요 구성: `data-contracts.md`, `기획 1.3 변경 인계`, `V4 기록과 후속 연동 계약`, `Apple 캘린더 주별 연결`, `실제 공유 UI 추출`, `순차 기능 이슈와 의존성`, `실제 수행일 정정`, `놓친 일 다시 고르기`. 전체 member_ids는 provenance.json에 있다.

### 17. 주간 선택과 초안 상태

전체 노드: **25개** · 응집도: **0.126667**.

출처: `Hanju/Features/Week/WeeklySelectionSheet.swift`.

주요 구성: `WeeklySelectionSheet`, `.label()`, `.show()`, `.allocate()`, `.countBinding()`, `.loadPrevious()`, `.previousBinding()`, `.selectedBinding()`. 전체 member_ids는 provenance.json에 있다.

### 18. 완료 입력과 화면 차단

전체 노드: **24개** · 응집도: **0.101449**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Services/Notifications/NotificationPresentationGate.swift`.

주요 구성: `CompletionSheet`, `PlanDismissal`, `NotificationPresentationGate`, `.body()`, `.body()`, `.notificationPresentation()`, `.save()`, `.undo()`. 전체 member_ids는 provenance.json에 있다.

### 19. 실행 원본과 복구 계약

전체 노드: **23개** · 응집도: **0.102767**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Records/RecordsSnapshot.swift`, `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `Hanju/Services/Notifications/NotificationStateStore.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/WeekPlanTests.swift`, `docs/adr/0002-execution-time-and-recovery.md`, `docs/development/data-contracts.md`.

주요 구성: `재실행 시계 비교 한계`, `복구 불확실성 영속 보존`, `계획 항목의 영속 스냅샷`, `원본 구간과 복구 표식`, `회차별 실행 기록 모델`, `실행 시계와 복구 결정`, `V3 실행 저장 계약`, `계획 화면 값 복사`. 전체 member_ids는 provenance.json에 있다.

### 20. 시각 기반과 알림 저장 계약

전체 노드: **23개** · 응집도: **0.150198**.

출처: `DEVELOPMENT_HANDOFF.md`, `Hanju/Services/Notifications/NotificationStateStore.swift`, `HanjuTests/NotificationTests.swift`, `README.md`, `design/01-direction.md`, `design/02-foundations.md`, `design/contrast-report.json`, `design/preview/index.html`, `design/reference/user-design-brief.txt`, `design/tokens.json`, `docs/adr/0004-local-notifications-and-reconciliation.md`, `docs/development/implementation-plan.md`, `docs/development/local-development.md`.

주요 구성: `DEVELOPMENT_HANDOFF.md`, `README.md`, `tokens.json`, `02-foundations.md`, `ADR 0004 로컬 알림과 저장 후 재조정`, `implementation-plan.md`, `01-direction.md`, `정돈한 생활의 페이지`. 전체 member_ids는 provenance.json에 있다.

### 21. 실행 명령과 원자 저장

전체 노드: **23개** · 응집도: **0.343874**.

출처: `Hanju/Features/Execution/ExecutionWriter.swift`.

주요 구성: `.complete()`, `.snapshot()`, `.start()`, `ExecutionWriter`, `.pause()`, `.undo()`, `.closeRunning()`, `.find()`. 전체 member_ids는 provenance.json에 있다.

### 22. 주간 목록과 실행 탐색

전체 노드: **22개** · 응집도: **0.207792**.

출처: `Hanju/Features/Week/WeekView.swift`.

주요 구성: `WeekView`, `.load()`, `.rowActions()`, `.resume()`, `.show()`, `Editor`, `.editCompletion()`, `.rowDescription()`. 전체 member_ids는 provenance.json에 있다.

### 23. 기록 집계와 실패 검증

전체 노드: **22개** · 응집도: **0.259740**.

출처: `HanjuTests/RecordsTests.swift`.

주요 구성: `.fixture()`, `RecordsTests`, `.records()`, `.read()`, `.sample()`, `.testMixedDurationsExcludeUncertainPartialTimeAndKeepZeroAndSubminuteDistinct()`, `.testPerformedDateCorrectionMovesBothWeekAggregatesWithoutMovingMemoOrPlan()`, `.testCountsUseRoutineIdentityAndHistoricalNamesAfterArchiveAndRename()`. 전체 member_ids는 provenance.json에 있다.

### 24. 루틴 입력과 저장 검증

전체 노드: **21개** · 응집도: **0.171429**.

출처: `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `HanjuTests/RoutinePersistenceTests.swift`.

주요 구성: `RoutineDraft`, `Field`, `ValidationError`, `.create()`, `.optionalPositiveInteger()`, `RoutinePersistenceTests`, `.validate()`, `.validatedName()`. 전체 member_ids는 provenance.json에 있다.

### 25. 루틴 목록과 편집 진입

전체 노드: **21개** · 응집도: **0.152381**.

출처: `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`.

주요 구성: `RoutineListView`, `Focus`, `Editor`, `.changeArchive()`, `.load()`, `.edit()`, `.didDismiss()`, `.create()`. 전체 member_ids는 provenance.json에 있다.

### 26. 루틴 저장과 복원 검증

전체 노드: **21개** · 응집도: **0.223810**.

출처: `Hanju/Features/Library/RoutineWriter.swift`, `HanjuTests/RoutineLibraryTests.swift`.

주요 구성: `.persist()`, `.fetch()`, `.setArchived()`, `RoutineWriter`, `RoutineLibraryTests`, `.exerciseStore()`, `.find()`, `.testFailedEditAndArchiveLeavePersistentValuesAndOtherDraftAlone()`. 전체 member_ids는 provenance.json에 있다.

### 27. 완료 시간과 날짜 검증

전체 노드: **20개** · 응집도: **0.284211**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `HanjuTests/ExecutionTests.swift`.

주요 구성: `.edit()`, `CompletionDraft`, `.fixture()`, `ExecutionTests`, `.read()`, `.sample()`, `.testDirectCompletionNilZeroSubminuteAndDateLifecyclePreserveOriginalFacts()`, `.testClockChangeColdRecoveryUncertaintyAndExplicitCorrectionRetainRawIntervals()`. 전체 member_ids는 provenance.json에 있다.

### 28. 계획 조정과 중립 건너뛰기

전체 노드: **20개** · 응집도: **0.136842**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`.

주요 구성: `PlanAdjustmentSheet`, `Mode`, `.selectedBinding()`, `.init()`, `.skip()`, `SwiftUI DismissAction.callAsFunction`, `.body`, `Bool`. 전체 member_ids는 provenance.json에 있다.

### 29. 실행 탐색과 완료 UI 검증

전체 노드: **20개** · 응집도: **0.263158**.

출처: `HanjuUITests/ExecutionUITests.swift`.

주요 구성: `ExecutionUITests`, `.reveal()`, `.createTodayPlans()`, `.pickDate()`, `.cancel()`, `.testPastWeekPausedResumeConfirmsSwitchAndReturnsToSamePlan()`, `.testTodayMoveDraftSurvivesSkipCancellationAndSkipReturnsToToday()`, `.testExplicitWeekAgendaOpensMovedDateAndSameDayWithoutStoppingRunning()`. 전체 member_ids는 provenance.json에 있다.

### 30. 제품 범위와 기록 정책

전체 노드: **19개** · 응집도: **0.198830**.

출처: `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/product-plan.md`.

주요 구성: `한 주 iPhone MVP`, `product-plan.md`, `Records 행동 우선 기록`, `채택 기술 구성`, `단일 실행 시간 기록`, `기기 내 오프라인 저장`, `생활 시각과 수행일 보존`, `AC-05 직접 완료와 수행일 정정`. 전체 member_ids는 provenance.json에 있다.

### 31. 메모 초안과 앱 수명

전체 노드: **19개** · 응집도: **0.157895**.

출처: `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Persistence/PersistenceStore.swift`, `Hanju/Services/Notifications/NotificationCoordinator.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

주요 구성: `초안 변경 여부별 재시도`, `앱 수명 실행 명령`, `입력 세대 확인과 동기 저장`, `메모 재시도와 버튼 문구`, `주입 메모 쓰기 호출`, `이전 메모 재시도 안내`, `V4 저장소와 실행 수명`, `실패 뒤 편집 보존 검증`. 전체 member_ids는 provenance.json에 있다.

### 32. 재알림 의도와 파일 저장

전체 노드: **18개** · 응집도: **0.156863**.

출처: `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Services/Notifications/NotificationCoordinator.swift`, `Hanju/Services/Notifications/NotificationPlan.swift`, `Hanju/Services/Notifications/NotificationStateStore.swift`.

주요 구성: `NotificationPersistentState`, `.requestReconcile()`, `NotificationStateStore`, `.acceptSnooze()`, `.snooze()`, `.install()`, `.mark()`, `.reloadState()`. 전체 member_ids는 provenance.json에 있다.

### 33. 탐색 보존과 저장 경계

전체 노드: **18개** · 응집도: **0.124183**.

출처: `.github/copilot-instructions.md`, `Hanju/Services/Notifications/NotificationCoordinator.swift`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `design/preview/index.html`, `docs/adr/0004-local-notifications-and-reconciliation.md`, `docs/product-plan.md`.

주요 구성: `05-swiftui-handoff.md`, `Running Routine 실행 화면`, `네이티브 검증 계약`, `캘린더 해제와 외부 변경`, `copilot-instructions.md`, `저장 후 직렬 재조정`, `기획 1.2 프리뷰 경계`, `네이티브 탭과 시트 탐색`. 전체 member_ids는 provenance.json에 있다.

### 34. 지역 날짜와 주 경계

전체 노드: **17개** · 응집도: **0.154412**.

출처: `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/LocalDate.swift`, `HanjuTests/WeekPlanTests.swift`.

주요 구성: `LocalDate`, `.adding()`, `.calendar()`, `.testGregorianDatesWeekBoundariesAndDSTResolution()`, `.previousMemo`, `.nextWeek`, `.lastDay`, `.monday`. 전체 member_ids는 provenance.json에 있다.

### 35. 구현 인계와 네이티브 CI

전체 노드: **17개** · 응집도: **0.132353**.

출처: `.github/workflows/ios.yml`, `DEVELOPMENT_HANDOFF.md`, `Hanju.xcodeproj/xcshareddata/xcschemes/Hanju.xcscheme`, `Hanju/Features/Library/RoutineSnapshot.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Features/Library/UnsavedChangesGuard.swift`, `HanjuTests/RoutinePersistenceTests.swift`, `docs/development/implementation-plan.md`, `docs/development/local-development.md`, `docs/verification/2026-10-04-foundation.md`.

주요 구성: `주간 기록 구현과 후속 경계`, `Hanju 공유 실행 테스트 scheme`, `기반 네이티브 검증 기록`, `변경 초안 swipe 확인 구현`, `iOS 빌드와 테스트 CI`, `네이티브 닫기 시도 연결`, `실행과 주간 기록 구현 인계`, `공유 scheme과 로컬 테스트`. 전체 member_ids는 provenance.json에 있다.

### 36. 주간 기록과 이동 근거

전체 노드: **17개** · 응집도: **0.169118**.

출처: `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `docs/adr/0003-weekly-records-and-memo.md`, `docs/development/data-contracts.md`, `docs/development/implementation-plan.md`.

주요 구성: `수행일별 기록과 메모 결정`, `주간 기록과 메모 저장 계약`, `부담 없는 계획과 호출자 복귀`, `실제 첫 날짜 이동 근거`, `확정 시간과 합계 한계`, `주별 초안과 저장 세대`, `수행일 장부와 루틴 횟수`, `주별 메모 원문 보존`. 전체 member_ids는 provenance.json에 있다.

### 37. 테스트 파일과 회귀 연결

전체 노드: **16개** · 응집도: **0.166667**.

출처: `Hanju/Models/HanjuSchemaV4.swift`, `HanjuTests/NotificationTests.swift`, `HanjuTests/RecordsMigrationTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/SchemaMigrationTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuUITests/NotificationUITests.swift`, `HanjuUITests/WeekPlanUITests.swift`.

주요 구성: `주별 메모 원문 저장`, `실제 디스크 V4 이전 검증`, `기록 집계와 원자 저장 검증`, `루틴 저장 실패와 복원 검증`, `V1 디스크 이전 검증`, `계획과 실행 결합 회귀검증`, `권한과 설정 화면 검증`, `XCTest`. 전체 member_ids는 provenance.json에 있다.

### 38. 앱 시작과 알림 위임

전체 노드: **16개** · 응집도: **0.150000**.

출처: `Hanju/App/HanjuApp.swift`, `Hanju/Features/Library/UnsavedChangesGuard.swift`, `Hanju/Persistence/PersistenceStore.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `NotificationAppDelegate`, `.application()`, `.openServices()`, `.open()`, `전면 전환 없는 재알림`, `앱 시작 위임과 응답`, `단일 시각과 주간 반복`, `SystemNotificationClient.swift`. 전체 member_ids는 provenance.json에 있다.

### 39. 알림 응답과 유한 완료

전체 노드: **16개** · 응집도: **0.208333**.

출처: `Hanju/Services/Notifications/NotificationCoordinator.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `.userNotificationCenter()`, `NotificationInbox`, `NotificationPresentationCompletion`, `NotificationCompletion`, `.attach()`, `.receive()`, `.init()`, `.noteResponseTimeout()`. 전체 member_ids는 provenance.json에 있다.

### 40. 개발 협업과 리뷰 규칙

전체 노드: **15개** · 응집도: **0.228571**.

출처: `.github/pull_request_template.md`, `AGENTS.md`, `CONTRIBUTING.md`, `docs/development/graphify.md`, `docs/development/review-workflow.md`, `docs/product-plan.md`.

주요 구성: `AGENTS.md`, `CONTRIBUTING.md`, `graphify.md`, `독립 리뷰와 Copilot 대기`, `최신 Codex와 Copilot 리뷰`, `review-workflow.md`, `main 병합 후 그래프 갱신`, `pull_request_template.md`. 전체 member_ids는 provenance.json에 있다.

### 41. 하단 탭과 명시 요청

전체 노드: **15개** · 응집도: **0.142857**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Library/LibraryView.swift`, `Hanju/Services/Notifications/NotificationPresentationGate.swift`.

주요 구성: `AppTabs`, `Tab`, `LibraryView`, `RecordsNotificationRequest`, `Destination`, `.body`, `Hashable`, `.body`. 전체 member_ids는 provenance.json에 있다.

### 42. 알림 설정과 시간 입력

전체 노드: **15개** · 응집도: **0.333333**.

출처: `Hanju/Features/Settings/SettingsView.swift`.

주요 구성: `SettingsView`, `.time()`, `.save()`, `.toggle()`, `.value()`, `.minutes()`, `.pickerDate()`, `.body`. 전체 member_ids는 provenance.json에 있다.

### 43. 주간 요청과 조정 종류

전체 노드: **15개** · 응집도: **0.161905**.

출처: `Hanju/Features/Week/WeekView.swift`.

주요 구성: `Kind`, `WeekRequest`, `Caller`, `.init()`, `.saved()`, `LocalDate`, `ExecutionSnapshot`, `records`. 전체 member_ids는 provenance.json에 있다.

### 44. 실행 기록과 구간 모델

전체 노드: **15개** · 응집도: **0.200000**.

출처: `Hanju/Models/HanjuSchemaV3.swift`.

주요 구성: `ExecutionRecord`, `ExecutionInterval`, `HanjuSchemaV3`, `.init()`, `.init()`, `UUID`, `Int`, `Date`. 전체 member_ids는 provenance.json에 있다.

### 45. 저장과 OS 실패 주입

전체 노드: **14개** · 응집도: **0.142857**.

출처: `HanjuTests/ExecutionTests.swift`, `HanjuTests/NotificationTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

주요 구성: `Failure`, `Failure`, `Failure`, `Failure`, `Failure`, `Failure`, `Error`, `disk`. 전체 member_ids는 provenance.json에 있다.

### 46. 루틴 행과 목록 조회 값

전체 노드: **14개** · 응집도: **0.142857**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineSnapshot.swift`.

주요 구성: `RoutineSnapshot`, `RoutineRow`, `RoutineFieldError`, `.init()`, `View`, `.categories`, `.body`, `String`. 전체 member_ids는 provenance.json에 있다.

### 47. 주간 기록과 메모 조회 값

전체 노드: **14개** · 응집도: **0.175824**.

출처: `Hanju/Features/Records/RecordsSnapshot.swift`, `Hanju/Features/Records/RecordsView.swift`.

주요 구성: `WeeklyRecordsSnapshot`, `RoutineCount`, `RecordedTimeSummary`, `WeeklyMemoSnapshot`, `.didDismiss()`, `Int`, `LocalDate`, `String`. 전체 member_ids는 provenance.json에 있다.

### 48. 기록 조회와 원문 저장

전체 노드: **14개** · 응집도: **0.307692**.

출처: `Hanju/Features/Records/RecordsStore.swift`, `HanjuTests/RecordsMigrationTests.swift`.

주요 구성: `.saveMemo()`, `.fetchMemo()`, `.fetch()`, `.testMemoFailureAndSuccessfulMoveEvidenceSurviveDiskReopen()`, `.memo()`, `RecordsStore`, `.isolatedContext()`, `ModelContext.fetch 사용`. 전체 member_ids는 provenance.json에 있다.

### 49. 현지 시각과 DST 해석

전체 노드: **14개** · 응집도: **0.197802**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Models/LocalDate.swift`.

주요 구성: `LocalTime`, `.init()`, `.init()`, `.resolve()`, `.init()`, `Resolution`, `LocalDate.init(year:month:day:)`, `LocalTime.init(hour:minute:)`. 전체 member_ids는 provenance.json에 있다.

### 50. 주간 계획과 복원 UI 검증

전체 노드: **14개** · 응집도: **0.340659**.

출처: `HanjuUITests/WeekPlanUITests.swift`.

주요 구성: `WeekPlanUITests`, `.reveal()`, `.choose()`, `.createRoutine()`, `.testTodayRecoveryKeepsUnselectedAndReturnsToCallerOnCancel()`, `.pickDate()`, `.testCreateCancelSkipRestoreAndRelaunch()`, `.testPreviousPlanRequiresExplicitConfirmationAndExcludesArchivedRoutines()`. 전체 member_ids는 provenance.json에 있다.

### 51. 완료 기록과 수행일 편집

전체 노드: **13개** · 응집도: **0.166667**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Week/PlanWriter.swift`, `HanjuTests/ExecutionTests.swift`.

주요 구성: `단일 실행과 저장 원자성`, `시간대 변경과 수행일 보존`, `실행 시간과 날짜 회귀검증`, `원본 수행일의 선택 범위`, `쉬기 대상과 실행 보존`, `수행일과 선택 시간 편집`, `미기록과 불확실 시간 구분`, `수동 시간의 적용 경계`. 전체 member_ids는 provenance.json에 있다.

### 52. 실행 복귀와 알림 제목

전체 노드: **12개** · 응집도: **0.181818**.

출처: `Hanju/Features/Execution/RunningRoutineView.swift`, `Hanju/Features/Today/TodayView.swift`, `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/WeekView.swift`, `HanjuUITests/ExecutionUITests.swift`, `design/04-screens.md`.

주요 구성: `지난주 재개와 호출 복귀`, `실행 완료와 복원 UI 검증`, `실행 제어와 시간 표시`, `이동 초안과 중립 건너뛰기`, `지난 작업 재개 계약`, `오늘 실행과 수행일 완료`, `불투명 알림 목록 제목`, `계획 변경과 실행 갱신`. 전체 member_ids는 provenance.json에 있다.

### 53. V1 루틴 디스크 보존

전체 노드: **12개** · 응집도: **0.212121**.

출처: `Hanju/Models/HanjuSchemaV1.swift`, `HanjuTests/RoutinePersistenceTests.swift`.

주요 구성: `RoutineTemplate`, `.writeRoutine()`, `.init()`, `.testSaveAndReopenRetainsIdentityAndOptionalValues()`, `Date`, `String`, `UUID`, `Bool`. 전체 member_ids는 provenance.json에 있다.

### 54. 명시 목록과 타이머 보존

전체 노드: **11개** · 응집도: **0.200000**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Week/WeekView.swift`, `HanjuUITests/ExecutionUITests.swift`, `HanjuUITests/WeekPlanUITests.swift`.

주요 구성: `명시 agenda 목록과 타이머 보존`, `주간 계획과 늦은 완료`, `계획 취소 복원 UI 검증`, `탭 탐색과 실행 연결`, `같은 날짜의 명시 agenda 요청`, `현재 미완료와 쉬기 안내`, `성공 날짜 목록과 취소 상세 보존`, `명시 목록 전환 회귀 정의`. 전체 member_ids는 provenance.json에 있다.

### 55. 실제 OS 알림 어댑터

전체 노드: **11개** · 응집도: **0.218182**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `SystemNotificationClient`, `.summary()`, `UUID.init(uuidString:)`, `.add()`, `.snapshot()`, `UNUserNotificationCenter.add`, `.removeDelivered()`, `.removePending()`. 전체 member_ids는 provenance.json에 있다.

### 56. V4 이전과 원본 검증

전체 노드: **11개** · 응집도: **0.272727**.

출처: `HanjuTests/RecordsMigrationTests.swift`.

주요 구성: `.writeFixture()`, `.verifyFixture()`, `RecordsMigrationTests`, `.testActualV1V2V3DiskStoresMigrateToV4WithoutInventingMoveHistory()`, `Fixture`, `Int`, `ExecutionSnapshot`, `ModelContainer`. 전체 member_ids는 provenance.json에 있다.

### 57. 실행 시계와 시간 계산

전체 노드: **10개** · 응집도: **0.288889**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`.

주요 구성: `ExecutionClock`, `.duration()`, `Sample`, `.elapsed()`, `.now()`, `.init()`, `Date`, `Double`. 전체 member_ids는 provenance.json에 있다.

### 58. 회차 조회와 미완료 상태

전체 노드: **10개** · 응집도: **0.200000**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/WeekView.swift`.

주요 구성: `OccurrenceSnapshot`, `.recovery`, `.unfinished`, `.canReplan`, `.isUnfinished`, `.statusLabel`, `Bool`, `Date`. 전체 member_ids는 provenance.json에 있다.

### 59. 행동 우선 기록과 메모

전체 노드: **9개** · 응집도: **0.250000**.

출처: `Hanju/Features/Records/RecordsStore.swift`, `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `HanjuUITests/RecordsUITests.swift`.

주요 구성: `수행일별 완료와 실천 횟수`, `주별 메모 원문 원자 저장`, `행동 우선 기록 장부`, `주별 메모 초안과 재시도`, `메모 저장과 계획 호출 복귀`, `기록 편집과 메모 UI 검증`, `확정 시간 합계와 불확실 구분`, `RecordsStore.swift`. 전체 member_ids는 provenance.json에 있다.

### 60. 메모 저장 상태 표현

전체 노드: **9개** · 응집도: **0.222222**.

출처: `Hanju/Features/Records/WeeklyMemoCoordinator.swift`.

주요 구성: `Status`, `Draft`, `.isDirty`, `failed`, `idle`, `pending`, `saved`, `saving`. 전체 member_ids는 provenance.json에 있다.

### 61. 날짜와 시각 입력

전체 노드: **8개** · 응집도: **0.250000**.

출처: `Hanju/Features/Week/PlanDateFields.swift`.

주요 구성: `PlanDateFields`, `.body`, `.timeBinding`, `ClosedRange`, `.dateBinding`, `.hasTime`, `Binding`, `Date`. 전체 member_ids는 provenance.json에 있다.

### 62. 실행 강조와 색상 에셋

전체 노드: **8개** · 응집도: **0.250000**.

출처: `Hanju/Assets.xcassets/AccentColor.colorset/Contents.json`, `Hanju/Assets.xcassets/AccentSubtle.colorset/Contents.json`, `Hanju/Assets.xcassets/Background.colorset/Contents.json`, `Hanju/Assets.xcassets/OnAccent.colorset/Contents.json`, `Hanju/Assets.xcassets/Surface.colorset/Contents.json`, `Hanju/Assets.xcassets/TextPrimary.colorset/Contents.json`, `Hanju/Assets.xcassets/TextSecondary.colorset/Contents.json`, `Hanju/Design/DesignTokens.swift`.

주요 구성: `실행 강조와 대비 색상`, `실행 패널의 연한 강조색`, `강조 버튼의 전경 색상`, `AccentColor.colorset/Contents.json`, `Background.colorset/Contents.json`, `Surface.colorset/Contents.json`, `TextPrimary.colorset/Contents.json`, `TextSecondary.colorset/Contents.json`. 전체 member_ids는 provenance.json에 있다.

### 63. 실제 예약과 테스트 클라이언트

전체 노드: **8개** · 응집도: **0.285714**.

출처: `Hanju/Services/Notifications/SystemNotificationClient.swift`, `HanjuTests/NotificationTests.swift`.

주요 구성: `NotificationSystemSnapshot`, `Request`, `.add()`, `.removeDelivered()`, `.removePending()`, `String`, `.allowsScheduling`, `UUID`. 전체 member_ids는 provenance.json에 있다.

### 64. 앱 저장소와 모델 구성

전체 노드: **7개** · 응집도: **0.333333**.

출처: `Hanju/Persistence/PersistenceStore.swift`.

주요 구성: `.makeContainer()`, `PersistenceStore`, `ExecutionRecorder`, `ModelContainer`, `Bool`, `String`, `URL`. 전체 member_ids는 provenance.json에 있다.

### 65. 기록 시간과 표시 형식

전체 노드: **7개** · 응집도: **0.523810**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`.

주요 구성: `RecordedDuration`, `.format()`, `.timerLabel()`, `Double`, `String`, `.label`, `Bool`. 전체 member_ids는 provenance.json에 있다.

### 66. 계획 초안과 횟수 배분

전체 노드: **7개** · 응집도: **0.619048**.

출처: `Hanju/Features/Week/PlanDraft.swift`.

주요 구성: `Entry`, `.allocate()`, `.init()`, `.validateCounts()`, `String`, `Int`, `UUID`. 전체 member_ids는 provenance.json에 있다.

### 67. OS 알림 권한 상태

전체 노드: **7개** · 응집도: **0.285714**.

출처: `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `Authorization`, `authorized`, `denied`, `ephemeral`, `notDetermined`, `provisional`, `unknown`. 전체 member_ids는 provenance.json에 있다.

### 68. 앱 환경과 공유 서비스

전체 노드: **6개** · 응집도: **0.333333**.

출처: `Hanju/App/HanjuApp.swift`.

주요 구성: `HanjuApp`, `App`, `.notifications`, `.persistence`, `PersistenceStore`, `Scene`. 전체 member_ids는 provenance.json에 있다.

### 69. 계획 회차 상태 표현

전체 노드: **6개** · 응집도: **0.333333**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`.

주요 구성: `Status`, `completed`, `paused`, `planned`, `running`, `skipped`. 전체 member_ids는 provenance.json에 있다.

### 70. 선호 요일과 날짜 계약

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Models/LocalDate.swift`, `docs/development/data-contracts.md`.

주요 구성: `월요일 기준 선호 요일 계약`, `선택 입력과 선호 요일 검증`, `시간대 독립 계획 날짜`, `현지 시각과 DST 설명`, `LocalDate.swift`. 전체 member_ids는 provenance.json에 있다.

### 71. 주간 화면 접근성 초점

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Week/WeekView.swift`.

주요 구성: `Focus`, `day`, `plan`, `rest`, `row`. 전체 member_ids는 provenance.json에 있다.

### 72. 네이티브 기반 기술 결정

전체 노드: **4개** · 응집도: **0.833333**.

출처: `docs/adr/0001-native-ios-foundation.md`.

주요 구성: `0001-native-ios-foundation.md`, `iOS 17 Swift 6 기반 채택`, `버전 스키마와 로컬 저장`, `개인 기기 설치 범위`. 전체 member_ids는 provenance.json에 있다.

### 73. 에셋 카탈로그 메타데이터

전체 노드: **1개** · 응집도: **1.000000**.

출처: `Hanju/Assets.xcassets/Contents.json`.

주요 구성: `Assets.xcassets/Contents.json`. 전체 member_ids는 provenance.json에 있다.

## God Nodes

- `Hanju 네이티브 프로젝트` — 차수 52 · `Hanju.xcodeproj/project.pbxproj:L481`.
- `LocalDate` — 차수 49 · `Hanju/Models/LocalDate.swift:L4`.
- `NotificationCoordinator` — 차수 49 · `Hanju/Services/Notifications/NotificationCoordinator.swift:L5`.
- `ExecutionSnapshot` — 차수 41 · `Hanju/Features/Execution/ExecutionSnapshot.swift:L3`.
- `.makeContainer()` — 차수 33 · `Hanju/Persistence/PersistenceStore.swift:L24`.
- `Foundation` — 차수 32 · `HanjuTests/WeekPlanTests.swift:L1`.
- `WeekView` — 차수 31 · `Hanju/Features/Week/WeekView.swift:L16`.
- `SwiftData` — 차수 30 · `HanjuTests/WeekPlanTests.swift:L2`.

## Surprising Connections

알림 coordinator의 기존 ExecutionRecorder 호출과 NotificationStateStore 원자 파일 쓰기가 서로 다른 저장 경계를 잇는다. 이는 원본 함수·명시 receiver와 연결된 개념 경로이며 두 저장소의 원자 transaction 보장을 뜻하지 않는다.

## Suggested Questions

- 재알림 수락부터 실제 OS 예약 확인까지 고정 dueAt는 어떤 경계를 통과하는가?
- 편집 중 알림 응답이 Today 또는 현재 주 Records로 이동하는 조건은 무엇인가?
- 앱 저장 실패와 OS 예약 실패가 기록 보존에 서로 어떻게 다른 영향을 주는가?

## 건강 상태와 해석 한계

- 103개 main 추적 입력 중 81개는 동일하고 22개를 갱신했다(신규 9개 포함, 삭제 0개). 완전한 이전 원시 캐시의 불변 관계 2375개와 소유 노드를 전체 payload·방향 그대로 보존했다. 단순 export나 낡은 manifest로 원시 관계를 복원하지 않았다.
- 변경 코드 15파일 AST 405개 노드 occurrence/1082개 원시 관계를 설치 Graphify로 실제 재추출했다. receiver/동명 오인 24개 관계를 원문에 따라 교정하고 모든 fresh emission과 교정 payload를 보존했다. 지역 draft/sources/changed 값은 관련 타입 읽기로만 INFERRED 표시했다. 불변 receiver 교정 54개와 export 교정 2개는 그대로 유지했다.
- Records의 공통 사용 stub 6개/13개 incident 관계를 현재 파일별 ID와 옮겨진 원문 앵커로 대응했다. qualified WeeklyMemoCoordinator.Draft outer type 1개는 유일한 실제 외부 선언에 명시 정규화하고 fresh 원본을 보존했다. overload·closure·중첩 타입/함수, producer 내부 중복 억제 등 Swift AST 한계가 남으며 전체 컴파일러 타입 추론을 뜻하지 않는다.
- 무방향 topology는 여러 관계와 방향을 합친다. 각 link.evidence에 원시 3717개 관계의 모든 필드를 보존했고 endpoint 쌍별 Counter로 검증했다. 단일 link 속성 대신 evidence를 읽어야 한다.
- 에셋 카탈로그 루트 Contents.json 1개는 고립 상태다. NotificationInbox.shared = NotificationInbox()의 생성자 사용은 Graphify가 class→같은 class calls self-edge 1개로 방출했다. 원문 생성자 사용이며 재귀 메서드 호출을 뜻하지 않는다. 파일 hub·AST 멤버·외부 타입을 제외하지 않고 전체 응집도를 보고한다.
- 설치 detector는 design/tokens.json 파일명을 sensitive로 1개 표시했다. 현재 Codex가 색상·서체·간격 등 디자인 값만 있는 실제 내용을 확인해 명시 입력으로 유지했다. detector가 지원 분류하지 않은 pbxproj/scheme을 명시 포함하고 skills-lock.json은 외부 스킬 의존성 입력으로 제외했다. 비밀키나 사용자 데이터는 입력하지 않았다.
- #11 알림·설정·수동 재알림과 ADR 0004가 이번 병합 코드에 포함된다. V1–V4·기존 writer·기존 테스트는 그대로다. pending 존재나 OS readback은 전달 성공이 아니다. 이 그래프 작업은 네이티브 테스트나 원격 CI를 실행하지 않았으며 제품 PR42의 결과를 새 실행으로 주장하지 않는다. 캘린더 #12와 실제 iPhone 잠금/종료 전달·Focus·iOS 17 실행·전체 접근성/2주 인수 #13은 후속이다.
- 실제 모델명·입출력 토큰·비용은 확인할 수 없어 null이다. 현재 Codex 세션이 의미 추출과 전체 커뮤니티 라벨을 작성했으며 외부 LLM API를 사용하지 않았다. 비용 0을 뜻하지 않는다.

## 사용 기록

현재 Codex 세션에서 의미 추출·전체 한국어 커뮤니티 라벨을 작성했다. 모델명·입출력 토큰·비용은 알 수 없음(null). 외부 LLM API 없음. 네이티브 실행 결과는 제품 이슈/PR의 실제 검증 근거를 확인한다.
