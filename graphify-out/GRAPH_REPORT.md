# 프로젝트 지식 그래프

분석 기준: main `c047e6cd98b0e15f7a215635dcae12d8deba51f5` · 이슈 #44 · 코드 PR #48 · Graphify 0.9.68. 결과 PR의 병합 SHA와 분석 대상 SHA는 별개다.

## 전체 집계

입력 **105개**(코드 64개, 문서·설정 41개), 노드 **1434개**, 원시 관계 **3821개**, 무방향 연결 **3597개**, 커뮤니티 **73개**다. 고립 노드 1개, 차수 0 또는 1인 노드 395개, self-edge 2개다.

파일 hub·AST 멤버·외부 타입을 포함한 전체 membership을 사용한다. 응집도는 설치 Graphify score_all의 원값이며 thin 필터나 낮은 점수 숨김은 없다.

## 이번 증분 분석

이전 main `af82a53c8c2d6cc5107e83499d3eae78a21a2665`의 103개 입력 해시와 완전한 원시 캐시를 확인했다. 100개 입력은 같고 5개를 갱신했다(기존 workflow/docs 3개·신규 CJS 2개·삭제 0개). 불변 3705개 관계와 소유 node payload·방향을 그대로 유지했다. 신규 코드 2파일에서 AST 38개 node occurrence/82개 관계를 실제 추출했다. 현재 Codex가 새 CJS와 workflow/docs 원문을 읽어 의미와 연결을 추가하고 모든 커뮤니티 구성원을 재검토했다.

#44는 PR에서 앱 빌드·모든 단위·영향 UI를 선택하고, 공용·알 수 없는 native 입력·삭제·불완전 diff/inventory에는 전체 검사로 폴백한다. 문서·Graphify-only는 명시 native skip이다. main native push와 수동 실행은 별도 iOS full regression이며 PR의 iOS build and tests와 구분한다. main 전체 회귀를 새 PR/push로 취소하지 않는다. 55분 제한과 Xcode26.2/macOS15 환경은 유지한다.

선택기는 전체 Git 이력의 merge-base/before-after NUL diff와 고정 identifier를 사용한다. 선택 suite의 실제 실행 사례를 xcresult에서 확인하고 checkout SHA·PR head·비교 base·모드·대상·실행 URL을 artifact/요약에 남긴다. PR 선별 성공이나 docs-only skip을 전체 회귀 통과로 보고하지 않는다. 다음 병합 전 실제 main 회귀 상태를 확인하며 확인된 회귀 실패는 수정·재검증을 우선한다. 최신 Copilot와 독립 코드 리뷰 규칙은 그대로다.

CJS 대소문자 심볼 FULL 배열/full 함수 충돌 1개를 분리하고 AST 관계 11개를 교정했다(선언 대상 1·배열 값 읽기 1·export 나열 9). 교정 전후 전체 payload와 실제 L5/L15/L86/L143 원문을 보관한다. 기존 receiver 78개/export 2개와 Swift qualified type·stub 보정 이력은 재해석 없이 유지한다. 이전 workflow 인라인 명령 관계 1개만 새 workflow→execute→buildArguments→Hanju scheme 경로로 대체하며 전체 근거를 기록한다.

앱 소스·모델·기존 테스트 정의는 바뀌지 않았다. 이 그래프 작업에서는 Node self-check·네이티브 테스트·원격 CI를 새로 실행하거나 main 전체 회귀 완료를 확인하지 않았다. 제품 PR48의 검증과 별도 전체 회귀 상태는 해당 실행 근거에서 확인해야 한다. 캘린더 #12와 실기기/iOS17/전체 접근성·2주 인수 #13은 후속이다.

## 이전 결과와 대응

노드 1380→1434, 원시 관계 3717→3821, 무방향 연결 3506→3597, 커뮤니티 74→73다. 제거 node ID와 입력 삭제는 없고 force export는 사용하지 않았다. 새 73개 커뮤니티의 실제 전체 membership을 읽어 한국어 이름을 다시 정했다.

## 커뮤니티 전체 목록

| ID | 이름 | 전체 노드 | 응집도 |
|---:|---|---:|---:|
| 0 | 계획 명령과 회차 이전 | 65 | 0.088462 |
| 1 | 하단 탭과 주간 실행 탐색 | 61 | 0.054098 |
| 2 | 알림 응답과 영속 상태 | 41 | 0.096341 |
| 3 | 원래 알림 대상과 예약 계산 | 39 | 0.112011 |
| 4 | 프로젝트 파일과 화면 연결 | 37 | 0.094595 |
| 5 | 실행 제어와 시계 복구 | 37 | 0.103604 |
| 6 | 오늘 실행과 편집 차단 | 35 | 0.122689 |
| 7 | 알림 저장과 전이 검증 | 34 | 0.237077 |
| 8 | 모델 파일과 회귀 연결 | 33 | 0.113636 |
| 9 | 커밋 훅과 리베이스 검증 | 33 | 0.136364 |
| 10 | 버전 스키마와 디스크 이전 | 32 | 0.090726 |
| 11 | 제품 범위와 기록 정책 | 29 | 0.123153 |
| 12 | 명령 오류와 입력 안내 | 29 | 0.068966 |
| 13 | PR 영향별 테스트 선택 | 27 | 0.113960 |
| 14 | 시각 기반과 알림 저장 계약 | 27 | 0.131054 |
| 15 | 루틴 편집과 버리기 확인 | 27 | 0.116809 |
| 16 | 기록 장부와 주 탐색 | 27 | 0.113960 |
| 17 | 제품 계약과 후속 인수 | 26 | 0.101538 |
| 18 | 주간 선택과 초안 상태 | 26 | 0.138462 |
| 19 | 기록 저장과 디스크 이전 | 25 | 0.156667 |
| 20 | 화면 명세와 알림 진입 | 24 | 0.123188 |
| 21 | 지역 날짜와 주 경계 | 23 | 0.130435 |
| 22 | 기록과 알림 UI 검증 | 23 | 0.201581 |
| 23 | 주별 메모와 재시도 검증 | 23 | 0.300395 |
| 24 | 실행 명령과 원자 저장 | 22 | 0.363636 |
| 25 | 루틴 저장과 복원 검증 | 22 | 0.220779 |
| 26 | 기록 집계와 실패 검증 | 22 | 0.259740 |
| 27 | 완료 시간과 날짜 검증 | 21 | 0.261905 |
| 28 | 루틴 목록과 편집 진입 | 21 | 0.157143 |
| 29 | 개발 협업과 리뷰 규칙 | 20 | 0.173684 |
| 30 | 테스트 선택기 자체 검증 | 20 | 0.105263 |
| 31 | 계획 조정과 중립 건너뛰기 | 20 | 0.136842 |
| 32 | 실행 탐색과 완료 UI 검증 | 20 | 0.263158 |
| 33 | 닫기 보호와 UIKit 연결 | 19 | 0.187135 |
| 34 | 루틴 편집과 복원 UI 검증 | 18 | 0.372549 |
| 35 | 알림 설정과 시간 입력 | 17 | 0.301471 |
| 36 | 실행 조회와 시간 표시 | 16 | 0.216667 |
| 37 | 루틴 입력과 검증 오류 | 16 | 0.216667 |
| 38 | 계획 회차와 미완료 상태 | 16 | 0.125000 |
| 39 | 알림 조회와 OS 조정 | 16 | 0.158333 |
| 40 | 실행 복귀와 알림 저장 경계 | 15 | 0.142857 |
| 41 | 구현 인계와 원자 저장 | 15 | 0.142857 |
| 42 | 실행 기록과 구간 모델 | 15 | 0.200000 |
| 43 | 저장소 구성과 루틴 보존 | 15 | 0.190476 |
| 44 | 실제 OS 알림 어댑터 | 15 | 0.171429 |
| 45 | 저장과 OS 실패 주입 | 14 | 0.142857 |
| 46 | 이슈 연결과 PR 정책 검증 | 14 | 0.197802 |
| 47 | 주간 기록과 메모 조회 값 | 14 | 0.175824 |
| 48 | 주간 계획과 복원 UI 검증 | 14 | 0.340659 |
| 49 | 행동 우선 기록과 이동 근거 | 13 | 0.166667 |
| 50 | 알림 응답과 유한 완료 | 13 | 0.256410 |
| 51 | 실행 원본과 복구 계약 | 12 | 0.166667 |
| 52 | 완료 기록과 수행일 편집 | 12 | 0.181818 |
| 53 | PR 검사와 main 전체 회귀 | 11 | 0.181818 |
| 54 | 탐색 보존과 저장 경계 | 11 | 0.200000 |
| 55 | 주간 기록과 메모 저장 계약 | 11 | 0.290909 |
| 56 | 메모 재시도와 실패 보존 | 11 | 0.200000 |
| 57 | 앱 시작과 알림 위임 | 11 | 0.200000 |
| 58 | 원래 위임과 응답 전달 | 10 | 0.200000 |
| 59 | 실행 복귀와 알림 제목 | 10 | 0.200000 |
| 60 | 닫기 시도와 위임 전달 | 9 | 0.222222 |
| 61 | 메모 저장 상태 표현 | 9 | 0.222222 |
| 62 | 현지 시각과 해석 값 | 9 | 0.277778 |
| 63 | 실행 강조와 색상 에셋 | 8 | 0.250000 |
| 64 | 루틴 행과 입력 오류 | 8 | 0.250000 |
| 65 | 날짜와 시각 입력 | 7 | 0.285714 |
| 66 | 계획 초안과 횟수 배분 | 7 | 0.619048 |
| 67 | V1 루틴 영속 필드 | 7 | 0.428571 |
| 68 | OS 알림 권한 상태 | 7 | 0.285714 |
| 69 | 명시 목록과 타이머 보존 | 6 | 0.400000 |
| 70 | 루틴 목록 접근성 초점 | 6 | 0.333333 |
| 71 | 선호 요일과 날짜 계약 | 5 | 0.400000 |
| 72 | 에셋 카탈로그 메타데이터 | 1 | 1.000000 |

### 0. 계획 명령과 회차 이전

전체 노드: **65개** · 응집도: **0.088462**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `HanjuTests/WeekPlanTests.swift`.

주요 구성: `.move()`, `.confirm()`, `PlanDraft`, `.skip()`, `.rest()`, `WeekPlanTests`, `.replan()`, `PlanWriter`. 전체 member_ids는 provenance.json에 있다.

### 1. 하단 탭과 주간 실행 탐색

전체 노드: **61개** · 응집도: **0.054098**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/App/HanjuApp.swift`, `Hanju/Features/Library/LibraryView.swift`, `Hanju/Features/Week/WeekView.swift`, `Hanju/Services/Notifications/NotificationPresentationGate.swift`.

주요 구성: `WeekView`, `Kind`, `.load()`, `HanjuApp`, `WeekRequest`, `.rowActions()`, `Focus`, `AppTabs`. 전체 member_ids는 provenance.json에 있다.

### 2. 알림 응답과 영속 상태

전체 노드: **41개** · 응집도: **0.096341**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Persistence/PersistenceStore.swift`, `Hanju/Services/Notifications/NotificationCoordinator.swift`, `Hanju/Services/Notifications/NotificationPlan.swift`, `Hanju/Services/Notifications/NotificationStateStore.swift`.

주요 구성: `NotificationCoordinator`, `NotificationPersistentState`, `.start()`, `.requestReconcile()`, `NotificationStateStore`, `.targets()`, `.validTargets()`, `.setVisibleTargets()`. 전체 member_ids는 provenance.json에 있다.

### 3. 원래 알림 대상과 예약 계산

전체 노드: **39개** · 응집도: **0.112011**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Models/LocalDate.swift`, `Hanju/Services/Notifications/NotificationPlan.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `NotificationTicket`, `NotificationEnvelope`, `.make()`, `NotificationTarget`, `NotificationRoute`, `Kind`, `.ticket()`, `.waitingCount()`. 전체 member_ids는 provenance.json에 있다.

### 4. 프로젝트 파일과 화면 연결

전체 노드: **37개** · 응집도: **0.094595**.

출처: `Hanju.xcodeproj/project.pbxproj`, `Hanju.xcodeproj/xcshareddata/xcschemes/Hanju.xcscheme`, `Hanju/App/AppTabs.swift`, `Hanju/App/HanjuApp.swift`, `Hanju/Design/DesignTokens.swift`, `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Library/LibraryView.swift`, `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Features/Library/RoutineEditorSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Features/Library/UnsavedChangesGuard.swift`, `Hanju/Features/Settings/SettingsView.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/RoutineTemplate.swift`, `Hanju/Services/Notifications/NotificationPresentationGate.swift`, `HanjuTests/RoutinePersistenceTests.swift`, `HanjuUITests/NotificationUITests.swift`, `HanjuUITests/RoutineLibraryUITests.swift`.

주요 구성: `Hanju 네이티브 프로젝트`, `project.pbxproj`, `Hanju 공유 실행 테스트 scheme`, `네이티브 닫기 시도 연결`, `원본 수행일의 선택 범위`, `DesignTokens`, `수행일과 선택 시간 편집`, `날짜 시각 입력과 설명`. 전체 member_ids는 provenance.json에 있다.

### 5. 실행 제어와 시계 복구

전체 노드: **37개** · 응집도: **0.103604**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `HanjuTests/ExecutionMigrationTests.swift`.

주요 구성: `ExecutionClock`, `.read()`, `ExecutionRecorder`, `.testDetectedColdUncertaintySurvivesDiskReopenAndFailedFlagSavePreservesRunning()`, `.refresh()`, `.testActualV2DiskMigrationPreservesPlansAndRunningRecordReopensInV3()`, `RunningRoutineView`, `.complete()`. 전체 member_ids는 provenance.json에 있다.

### 6. 오늘 실행과 편집 차단

전체 노드: **35개** · 응집도: **0.122689**.

출처: `Hanju/Features/Today/TodayView.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Services/Notifications/NotificationPresentationGate.swift`.

주요 구성: `TodayView`, `View`, `.perform()`, `.startNotification()`, `Editor`, `.activeActions()`, `.load()`, `PlanDismissal`. 전체 member_ids는 provenance.json에 있다.

### 7. 알림 저장과 전이 검증

전체 노드: **34개** · 응집도: **0.237077**.

출처: `Hanju/Services/Notifications/NotificationCoordinator.swift`, `HanjuTests/NotificationTests.swift`.

주요 구성: `NotificationTests`, `.fixture()`, `.attach()`, `Client`, `.updatePreferences()`, `.preferences()`, `.testSaveFailureRetainsOriginalPendingAndReceiptDoesNotConsumeSchedule()`, `.idle()`. 전체 member_ids는 provenance.json에 있다.

### 8. 모델 파일과 회귀 연결

전체 노드: **33개** · 응집도: **0.113636**.

출처: `Hanju/Features/Records/RecordsSnapshot.swift`, `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `Hanju/Services/Notifications/NotificationStateStore.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/ExecutionTests.swift`, `HanjuTests/NotificationTests.swift`, `HanjuTests/RecordsMigrationTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/SchemaMigrationTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`, `HanjuUITests/WeekPlanUITests.swift`.

주요 구성: `실행 시간과 날짜 회귀검증`, `계획 항목의 영속 스냅샷`, `원본 구간과 복구 표식`, `회차별 실행 기록 모델`, `계획 화면 값 복사`, `V2 이전과 복구 영속 검증`, `실제 디스크 V4 이전 검증`, `기록 집계와 원자 저장 검증`. 전체 member_ids는 provenance.json에 있다.

### 9. 커밋 훅과 리베이스 검증

전체 노드: **33개** · 응집도: **0.136364**.

출처: `.githooks/commit-msg`, `.github/scripts/test_commit_msg.py`.

주요 구성: `CommitMessageHookTests`, `.git()`, `.commit()`, `.reword()`, `.assert_rejected()`, `.test_invalid_or_missing_rebase_head_name_rejected()`, `.conflicting_history()`, `.test_git_am_is_not_rebase()`. 전체 member_ids는 provenance.json에 있다.

### 10. 버전 스키마와 디스크 이전

전체 노드: **32개** · 응집도: **0.090726**.

출처: `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `HanjuTests/SchemaMigrationTests.swift`.

주요 구성: `.migrateAndAddPlan()`, `HanjuSchemaV1`, `HanjuSchemaV4`, `HanjuMigrationPlan`, `SchemaMigrationTests`, `.verifyRoutine()`, `.writeV1Fixture()`, `OccurrenceDateMove`. 전체 member_ids는 provenance.json에 있다.

### 11. 제품 범위와 기록 정책

전체 노드: **29개** · 응집도: **0.123153**.

출처: `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/development/data-contracts.md`, `docs/product-plan.md`.

주요 구성: `한 주 iPhone MVP`, `product-plan.md`, `Apple 캘린더 주별 연결`, `Records 행동 우선 기록`, `채택 기술 구성`, `캘린더 해제와 외부 변경`, `단일 실행 시간 기록`, `기기 내 오프라인 저장`. 전체 member_ids는 provenance.json에 있다.

### 12. 명령 오류와 입력 안내

전체 노드: **29개** · 응집도: **0.068966**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Services/Notifications/NotificationStateStore.swift`.

주요 구성: `PlanError`, `ExecutionError`, `NotificationFailure`, `WriteError`, `LocalizedError`, `String`, `anotherRunning`, `changed`. 전체 member_ids는 provenance.json에 있다.

### 13. PR 영향별 테스트 선택

전체 노드: **27개** · 응집도: **0.113960**.

출처: `.github/scripts/ios-test-plan.cjs`, `docs/development/local-development.md`.

주요 구성: `run()`, `selectPlan()`, `buildArguments()`, `changedFiles()`, `parseDiff()`, `withInventory()`, `PR 영향별 테스트 선택`, `inventory()`. 전체 member_ids는 provenance.json에 있다.

### 14. 시각 기반과 알림 저장 계약

전체 노드: **27개** · 응집도: **0.131054**.

출처: `DEVELOPMENT_HANDOFF.md`, `Hanju/Services/Notifications/NotificationStateStore.swift`, `HanjuTests/NotificationTests.swift`, `README.md`, `design/01-direction.md`, `design/02-foundations.md`, `design/contrast-report.json`, `design/preview/index.html`, `design/reference/user-design-brief.txt`, `design/tokens.json`, `docs/adr/0001-native-ios-foundation.md`, `docs/adr/0004-local-notifications-and-reconciliation.md`, `docs/development/implementation-plan.md`, `docs/development/local-development.md`.

주요 구성: `DEVELOPMENT_HANDOFF.md`, `README.md`, `tokens.json`, `02-foundations.md`, `0001-native-ios-foundation.md`, `ADR 0004 로컬 알림과 저장 후 재조정`, `implementation-plan.md`, `01-direction.md`. 전체 member_ids는 provenance.json에 있다.

### 15. 루틴 편집과 버리기 확인

전체 노드: **27개** · 응집도: **0.116809**.

출처: `Hanju/Features/Library/RoutineEditorSheet.swift`.

주요 구성: `RoutineEditorSheet`, `.archive()`, `SwiftUI DismissAction.callAsFunction`, `.dayName()`, `.init()`, `.save()`, `.toggleDay()`, `PendingAction`. 전체 member_ids는 provenance.json에 있다.

### 16. 기록 장부와 주 탐색

전체 노드: **27개** · 응집도: **0.113960**.

출처: `Hanju/Features/Records/RecordsView.swift`, `HanjuUITests/RecordsUITests.swift`.

주요 구성: `RecordsView`, `.load()`, `.edit()`, `Focus`, `.changeWeek()`, `.recordsHeader()`, `.consumeNotificationRequest()`, `.leaveForPlan()`. 전체 member_ids는 provenance.json에 있다.

### 17. 제품 계약과 후속 인수

전체 노드: **26개** · 응집도: **0.101538**.

출처: `Hanju/Features/Execution/ExecutionWriter.swift`, `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `design/preview/index.html`, `docs/development/data-contracts.md`, `docs/development/implementation-plan.md`, `docs/development/planning-revision-1.3.md`, `docs/product-plan.md`.

주요 구성: `data-contracts.md`, `기획 1.3 변경 인계`, `V4 기록과 후속 연동 계약`, `실제 공유 UI 추출`, `네이티브 검증 계약`, `순차 기능 이슈와 의존성`, `실제 수행일 정정`, `놓친 일 다시 고르기`. 전체 member_ids는 provenance.json에 있다.

### 18. 주간 선택과 초안 상태

전체 노드: **26개** · 응집도: **0.138462**.

출처: `Hanju/Features/Week/WeeklySelectionSheet.swift`.

주요 구성: `WeeklySelectionSheet`, `.label()`, `.show()`, `.allocate()`, `.countBinding()`, `.loadPrevious()`, `.previousBinding()`, `.selectedBinding()`. 전체 member_ids는 provenance.json에 있다.

### 19. 기록 저장과 디스크 이전

전체 노드: **25개** · 응집도: **0.156667**.

출처: `Hanju/Features/Records/RecordsStore.swift`, `HanjuTests/RecordsMigrationTests.swift`.

주요 구성: `.saveMemo()`, `.fetchMemo()`, `.fetch()`, `.testMemoFailureAndSuccessfulMoveEvidenceSurviveDiskReopen()`, `.writeFixture()`, `.verifyFixture()`, `.memo()`, `RecordsMigrationTests`. 전체 member_ids는 provenance.json에 있다.

### 20. 화면 명세와 알림 진입

전체 노드: **24개** · 응집도: **0.123188**.

출처: `Hanju/Features/Settings/SettingsView.swift`, `Hanju/Features/Today/TodayView.swift`, `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/adr/0004-local-notifications-and-reconciliation.md`, `docs/product-plan.md`.

주요 구성: `04-screens.md`, `03-components.md`, `Week 이번 주 화면`, `Today 오늘 화면`, `PlannedOccurrence`, `Reschedule 일정 이동`, `CalendarSheet 주별 연결`, `Routine Editor 편집 시트`. 전체 member_ids는 provenance.json에 있다.

### 21. 지역 날짜와 주 경계

전체 노드: **23개** · 응집도: **0.130435**.

출처: `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/LocalDate.swift`, `HanjuTests/WeekPlanTests.swift`.

주요 구성: `LocalDate`, `.adding()`, `.calendar()`, `.init()`, `.resolve()`, `.testGregorianDatesWeekBoundariesAndDSTResolution()`, `LocalDate.init(year:month:day:)`, `.body`. 전체 member_ids는 provenance.json에 있다.

### 22. 기록과 알림 UI 검증

전체 노드: **23개** · 응집도: **0.201581**.

출처: `HanjuTests/ExecutionMigrationTests.swift`, `HanjuUITests/NotificationUITests.swift`, `HanjuUITests/RecordsUITests.swift`.

주요 구성: `RecordsUITests`, `.reveal()`, `.selectWeek()`, `.testCompletionCorrectionMovesSameRecordBetweenWeeksAndUndoRecompleteRefreshes()`, `NotificationUITests`, `.reveal()`, `.tapSwitch()`, `.completedRow()`. 전체 member_ids는 provenance.json에 있다.

### 23. 주별 메모와 재시도 검증

전체 노드: **23개** · 응집도: **0.300395**.

출처: `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

주요 구성: `WeeklyMemoCoordinator`, `.flush()`, `.load()`, `.draft()`, `.update()`, `.retry()`, `.testFailedWeekDraftSurvivesOtherWeekSaveReloadAndRetry()`, `.testDebounceKeepsLatestTextAndCapturedWeekWithoutDuplicateFlush()`. 전체 member_ids는 provenance.json에 있다.

### 24. 실행 명령과 원자 저장

전체 노드: **22개** · 응집도: **0.363636**.

출처: `Hanju/Features/Execution/ExecutionWriter.swift`.

주요 구성: `.snapshot()`, `.start()`, `.edit()`, `ExecutionWriter`, `.pause()`, `.undo()`, `.closeRunning()`, `.find()`. 전체 member_ids는 provenance.json에 있다.

### 25. 루틴 저장과 복원 검증

전체 노드: **22개** · 응집도: **0.220779**.

출처: `Hanju/Features/Library/RoutineWriter.swift`, `HanjuTests/RoutineLibraryTests.swift`.

주요 구성: `.persist()`, `.fetch()`, `.setArchived()`, `RoutineWriter`, `RoutineLibraryTests`, `.exerciseStore()`, `.create()`, `.find()`. 전체 member_ids는 provenance.json에 있다.

### 26. 기록 집계와 실패 검증

전체 노드: **22개** · 응집도: **0.259740**.

출처: `HanjuTests/RecordsTests.swift`.

주요 구성: `.fixture()`, `RecordsTests`, `.records()`, `.read()`, `.sample()`, `.testMixedDurationsExcludeUncertainPartialTimeAndKeepZeroAndSubminuteDistinct()`, `.testPerformedDateCorrectionMovesBothWeekAggregatesWithoutMovingMemoOrPlan()`, `.testCountsUseRoutineIdentityAndHistoricalNamesAfterArchiveAndRename()`. 전체 member_ids는 provenance.json에 있다.

### 27. 완료 시간과 날짜 검증

전체 노드: **21개** · 응집도: **0.261905**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `HanjuTests/ExecutionTests.swift`.

주요 구성: `.complete()`, `CompletionDraft`, `.fixture()`, `ExecutionTests`, `.read()`, `.sample()`, `.testDirectCompletionNilZeroSubminuteAndDateLifecyclePreserveOriginalFacts()`, `.testClockChangeColdRecoveryUncertaintyAndExplicitCorrectionRetainRawIntervals()`. 전체 member_ids는 provenance.json에 있다.

### 28. 루틴 목록과 편집 진입

전체 노드: **21개** · 응집도: **0.157143**.

출처: `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineSnapshot.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`.

주요 구성: `RoutineListView`, `RoutineSnapshot`, `Editor`, `.changeArchive()`, `.load()`, `.edit()`, `.didDismiss()`, `.create()`. 전체 member_ids는 provenance.json에 있다.

### 29. 개발 협업과 리뷰 규칙

전체 노드: **20개** · 응집도: **0.173684**.

출처: `.github/ISSUE_TEMPLATE/bug.md`, `.github/ISSUE_TEMPLATE/task.md`, `.github/pull_request_template.md`, `AGENTS.md`, `CONTRIBUTING.md`, `docs/development/graphify.md`, `docs/development/review-workflow.md`, `docs/product-plan.md`.

주요 구성: `AGENTS.md`, `CONTRIBUTING.md`, `graphify.md`, `이슈 연결 Git 규칙`, `독립 리뷰와 Copilot 대기`, `최신 Codex와 Copilot 리뷰`, `review-workflow.md`, `PR 정책과 main 보호`. 전체 member_ids는 provenance.json에 있다.

### 30. 테스트 선택기 자체 검증

전체 노드: **20개** · 응집도: **0.105263**.

출처: `.github/scripts/ios-test-plan.test.cjs`.

주요 구성: `plan()`, `change()`, `선택 규칙과 실패 검증`, `addHeading()`, `addTable()`, `info()`, `setOutput()`, `warning()`. 전체 member_ids는 provenance.json에 있다.

### 31. 계획 조정과 중립 건너뛰기

전체 노드: **20개** · 응집도: **0.136842**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`.

주요 구성: `PlanAdjustmentSheet`, `Mode`, `.selectedBinding()`, `.init()`, `.skip()`, `SwiftUI DismissAction.callAsFunction`, `.body`, `Bool`. 전체 member_ids는 provenance.json에 있다.

### 32. 실행 탐색과 완료 UI 검증

전체 노드: **20개** · 응집도: **0.263158**.

출처: `HanjuUITests/ExecutionUITests.swift`.

주요 구성: `ExecutionUITests`, `.reveal()`, `.createTodayPlans()`, `.pickDate()`, `.cancel()`, `.testPastWeekPausedResumeConfirmsSwitchAndReturnsToSamePlan()`, `.testTodayMoveDraftSurvivesSkipCancellationAndSkipReturnsToToday()`, `.testExplicitWeekAgendaOpensMovedDateAndSameDayWithoutStoppingRunning()`. 전체 member_ids는 provenance.json에 있다.

### 33. 닫기 보호와 UIKit 연결

전체 노드: **19개** · 응집도: **0.187135**.

출처: `Hanju/Features/Library/UnsavedChangesGuard.swift`.

주요 구성: `Coordinator`, `UnsavedChangesGuard`, `ObserverController`, `.attach()`, `.dismantleUIViewController()`, `.makeUIViewController()`, `.updateUIViewController()`, `.detach()`. 전체 member_ids는 provenance.json에 있다.

### 34. 루틴 편집과 복원 UI 검증

전체 노드: **18개** · 응집도: **0.372549**.

출처: `HanjuUITests/RoutineLibraryUITests.swift`.

주요 구성: `RoutineLibraryUITests`, `.openEditor()`, `.routineRow()`, `.openLibrary()`, `.reveal()`, `.enter()`, `.finishInput()`, `.testCategoryChangeRemainsVisibleAndRevertedEditSwipesCleanly()`. 전체 member_ids는 provenance.json에 있다.

### 35. 알림 설정과 시간 입력

전체 노드: **17개** · 응집도: **0.301471**.

출처: `Hanju/Features/Settings/SettingsView.swift`, `Hanju/Services/Notifications/NotificationPlan.swift`.

주요 구성: `NotificationPreferences`, `SettingsView`, `.time()`, `.save()`, `.toggle()`, `.value()`, `.minutes()`, `.pickerDate()`. 전체 member_ids는 provenance.json에 있다.

### 36. 실행 조회와 시간 표시

전체 노드: **16개** · 응집도: **0.216667**.

출처: `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`.

주요 구성: `ExecutionSnapshot`, `Interval`, `RecordedDuration`, `.completed()`, `.completed()`, `.format()`, `.timerLabel()`, `Double`. 전체 member_ids는 provenance.json에 있다.

### 37. 루틴 입력과 검증 오류

전체 노드: **16개** · 응집도: **0.216667**.

출처: `Hanju/Features/Library/RoutineDraft.swift`.

주요 구성: `RoutineDraft`, `Field`, `ValidationError`, `.optionalPositiveInteger()`, `.validate()`, `.validatedName()`, `String`, `Int`. 전체 member_ids는 provenance.json에 있다.

### 38. 계획 회차와 미완료 상태

전체 노드: **16개** · 응집도: **0.125000**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/WeekView.swift`.

주요 구성: `OccurrenceSnapshot`, `Status`, `.recovery`, `.unfinished`, `.canReplan`, `.isUnfinished`, `.statusLabel`, `completed`. 전체 member_ids는 provenance.json에 있다.

### 39. 알림 조회와 OS 조정

전체 노드: **16개** · 응집도: **0.158333**.

출처: `Hanju/Services/Notifications/NotificationCoordinator.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`, `HanjuTests/NotificationTests.swift`.

주요 구성: `NotificationSystemSnapshot`, `.drain()`, `NotificationClient`, `.sources()`, `Request`, `.add()`, `.removeDelivered()`, `.removePending()`. 전체 member_ids는 provenance.json에 있다.

### 40. 실행 복귀와 알림 저장 경계

전체 노드: **15개** · 응집도: **0.142857**.

출처: `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Week/WeekView.swift`, `Hanju/Persistence/PersistenceStore.swift`, `Hanju/Services/Notifications/NotificationCoordinator.swift`, `HanjuUITests/WeekPlanUITests.swift`, `design/04-screens.md`.

주요 구성: `지난주 재개와 호출 복귀`, `앱 수명 실행 명령`, `계획 취소 복원 UI 검증`, `지난 작업 재개 계약`, `현재 미완료와 쉬기 안내`, `V4 저장소와 실행 수명`, `고정 시각 재알림 의도`, `응답 수락과 실행 경계`. 전체 member_ids는 provenance.json에 있다.

### 41. 구현 인계와 원자 저장

전체 노드: **15개** · 응집도: **0.142857**.

출처: `DEVELOPMENT_HANDOFF.md`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Library/LibraryView.swift`, `Hanju/Features/Library/RoutineSnapshot.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Features/Week/PlanWriter.swift`, `docs/development/implementation-plan.md`, `docs/verification/2026-10-04-foundation.md`.

주요 구성: `주간 기록 구현과 후속 경계`, `LibraryView`, `기반 네이티브 검증 기록`, `변경 초안 swipe 확인 구현`, `단일 실행과 저장 원자성`, `실행과 주간 기록 구현 인계`, `쉬기 대상과 실행 보존`, `루틴 목록과 편집 값 복사`. 전체 member_ids는 provenance.json에 있다.

### 42. 실행 기록과 구간 모델

전체 노드: **15개** · 응집도: **0.200000**.

출처: `Hanju/Models/HanjuSchemaV3.swift`.

주요 구성: `ExecutionRecord`, `ExecutionInterval`, `HanjuSchemaV3`, `.init()`, `.init()`, `UUID`, `Int`, `Date`. 전체 member_ids는 provenance.json에 있다.

### 43. 저장소 구성과 루틴 보존

전체 노드: **15개** · 응집도: **0.190476**.

출처: `Hanju/Persistence/PersistenceStore.swift`, `HanjuTests/RoutinePersistenceTests.swift`.

주요 구성: `.makeContainer()`, `PersistenceStore`, `RoutinePersistenceTests`, `.writeRoutine()`, `.testBlankNameCannotCreateRoutine()`, `.testInMemoryContainersDoNotShareData()`, `.testSaveFailurePreservesDraftAndRetryCreatesOnlyOneRoutine()`, `.testSaveAndReopenRetainsIdentityAndOptionalValues()`. 전체 member_ids는 provenance.json에 있다.

### 44. 실제 OS 알림 어댑터

전체 노드: **15개** · 응집도: **0.171429**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `SystemNotificationClient`, `.summary()`, `UUID.init(uuidString:)`, `.add()`, `.snapshot()`, `UNUserNotificationCenter.add`, `.removeDelivered()`, `.removePending()`. 전체 member_ids는 provenance.json에 있다.

### 45. 저장과 OS 실패 주입

전체 노드: **14개** · 응집도: **0.142857**.

출처: `HanjuTests/ExecutionTests.swift`, `HanjuTests/NotificationTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

주요 구성: `Failure`, `Failure`, `Failure`, `Failure`, `Failure`, `Failure`, `Error`, `disk`. 전체 member_ids는 provenance.json에 있다.

### 46. 이슈 연결과 PR 정책 검증

전체 노드: **14개** · 응집도: **0.197802**.

출처: `.github/scripts/pr-policy.cjs`, `.github/scripts/pr-policy.test.cjs`, `.github/workflows/pr-policy.yml`.

주요 구성: `PR 정책 검사 CI`, `validate()`, `pr-policy.yml`, `run()`, `ref_node_assert`, `ref_node_test`, `fixture()`, `pr-policy.test.cjs`. 전체 member_ids는 provenance.json에 있다.

### 47. 주간 기록과 메모 조회 값

전체 노드: **14개** · 응집도: **0.175824**.

출처: `Hanju/Features/Records/RecordsSnapshot.swift`, `Hanju/Features/Records/RecordsView.swift`.

주요 구성: `WeeklyRecordsSnapshot`, `RoutineCount`, `RecordedTimeSummary`, `WeeklyMemoSnapshot`, `.didDismiss()`, `Int`, `LocalDate`, `String`. 전체 member_ids는 provenance.json에 있다.

### 48. 주간 계획과 복원 UI 검증

전체 노드: **14개** · 응집도: **0.340659**.

출처: `HanjuUITests/WeekPlanUITests.swift`.

주요 구성: `WeekPlanUITests`, `.reveal()`, `.choose()`, `.createRoutine()`, `.testTodayRecoveryKeepsUnselectedAndReturnsToCallerOnCancel()`, `.pickDate()`, `.testCreateCancelSkipRestoreAndRelaunch()`, `.testPreviousPlanRequiresExplicitConfirmationAndExcludesArchivedRoutines()`. 전체 member_ids는 provenance.json에 있다.

### 49. 행동 우선 기록과 이동 근거

전체 노드: **13개** · 응집도: **0.166667**.

출처: `Hanju/Features/Records/RecordsStore.swift`, `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `HanjuUITests/RecordsUITests.swift`.

주요 구성: `수행일별 완료와 실천 횟수`, `주별 메모 원문 원자 저장`, `행동 우선 기록 장부`, `주별 메모 초안과 재시도`, `주별 메모 원문 저장`, `메모 저장과 계획 호출 복귀`, `날짜 이동과 근거 원자 저장`, `최초 실제 날짜 이동 근거`. 전체 member_ids는 provenance.json에 있다.

### 50. 알림 응답과 유한 완료

전체 노드: **13개** · 응집도: **0.256410**.

출처: `Hanju/Services/Notifications/NotificationCoordinator.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `.userNotificationCenter()`, `NotificationPresentationCompletion`, `NotificationCompletion`, `.init()`, `.noteResponseTimeout()`, `.finish()`, `.init()`, `.finish()`. 전체 member_ids는 provenance.json에 있다.

### 51. 실행 원본과 복구 계약

전체 노드: **12개** · 응집도: **0.166667**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `docs/adr/0002-execution-time-and-recovery.md`, `docs/development/data-contracts.md`.

주요 구성: `재실행 시계 비교 한계`, `복구 불확실성 영속 보존`, `실행 시계와 복구 결정`, `V3 실행 저장 계약`, `미기록과 불확실 시간 구분`, `수동 시간의 적용 경계`, `수면 포함 실행 시계`, `완료 날짜와 재완료 수명`. 전체 member_ids는 provenance.json에 있다.

### 52. 완료 기록과 수행일 편집

전체 노드: **12개** · 응집도: **0.181818**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`.

주요 구성: `CompletionSheet`, `.save()`, `.undo()`, `SwiftUI DismissAction.callAsFunction`, `.init()`, `.latestAllowedDay`, `.dateBinding`, `.dirty`. 전체 member_ids는 provenance.json에 있다.

### 53. PR 검사와 main 전체 회귀

전체 노드: **11개** · 응집도: **0.181818**.

출처: `.github/scripts/ios-test-plan.cjs`, `.github/workflows/ios.yml`, `docs/development/local-development.md`, `docs/development/review-workflow.md`.

주요 구성: `iOS 빌드와 테스트 CI`, `verifyResults()`, `execute()`, `공유 scheme과 로컬 테스트`, `visit()`, `ios.yml`, `PR 검사와 main 회귀`, `선택 suite 실행 확인`. 전체 member_ids는 provenance.json에 있다.

### 54. 탐색 보존과 저장 경계

전체 노드: **11개** · 응집도: **0.200000**.

출처: `.github/copilot-instructions.md`, `Hanju/Services/Notifications/NotificationCoordinator.swift`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/adr/0004-local-notifications-and-reconciliation.md`, `docs/product-plan.md`.

주요 구성: `05-swiftui-handoff.md`, `Running Routine 실행 화면`, `copilot-instructions.md`, `저장 후 직렬 재조정`, `화면 독립 실행 기록기`, `AC-04 기록 시작과 중단`, `편집 보호와 명시 열기`, `저장 성공 후 명시적 agenda 요청`. 전체 member_ids는 provenance.json에 있다.

### 55. 주간 기록과 메모 저장 계약

전체 노드: **11개** · 응집도: **0.290909**.

출처: `docs/adr/0003-weekly-records-and-memo.md`, `docs/development/data-contracts.md`, `docs/development/implementation-plan.md`.

주요 구성: `수행일별 기록과 메모 결정`, `주간 기록과 메모 저장 계약`, `부담 없는 계획과 호출자 복귀`, `실제 첫 날짜 이동 근거`, `확정 시간과 합계 한계`, `주별 초안과 저장 세대`, `수행일 장부와 루틴 횟수`, `주별 메모 원문 보존`. 전체 member_ids는 provenance.json에 있다.

### 56. 메모 재시도와 실패 보존

전체 노드: **11개** · 응집도: **0.200000**.

출처: `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

주요 구성: `초안 변경 여부별 재시도`, `입력 세대 확인과 동기 저장`, `메모 재시도와 버튼 문구`, `주입 메모 읽기 호출`, `취소 가능한 메모 저장 예약`, `주입 메모 쓰기 호출`, `이전 메모 재시도 안내`, `실패 뒤 편집 보존 검증`. 전체 member_ids는 provenance.json에 있다.

### 57. 앱 시작과 알림 위임

전체 노드: **11개** · 응집도: **0.200000**.

출처: `Hanju/Features/Library/UnsavedChangesGuard.swift`, `Hanju/Persistence/PersistenceStore.swift`, `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `NotificationAppDelegate`, `.application()`, `.openServices()`, `.open()`, `전면 전환 없는 재알림`, `앱 시작 위임과 응답`, `Bool`, `NSObject`. 전체 member_ids는 provenance.json에 있다.

### 58. 원래 위임과 응답 전달

전체 노드: **10개** · 응집도: **0.200000**.

출처: `Hanju/Features/Library/UnsavedChangesGuard.swift`.

주요 구성: `.forwardingTarget()`, `.responds()`, `.viewDidAppear()`, `NSObject.forwardingTarget`, `NSObject.responds`, `original delegate.responds`, `UIViewController.viewdidappear`, `Bool`. 전체 member_ids는 provenance.json에 있다.

### 59. 실행 복귀와 알림 제목

전체 노드: **10개** · 응집도: **0.200000**.

출처: `Hanju/Features/Execution/RunningRoutineView.swift`, `Hanju/Features/Today/TodayView.swift`, `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `HanjuUITests/ExecutionUITests.swift`.

주요 구성: `실행 완료와 복원 UI 검증`, `실행 제어와 시간 표시`, `이동 초안과 중립 건너뛰기`, `오늘 실행과 수행일 완료`, `불투명 알림 목록 제목`, `계획 변경과 실행 갱신`, `TodayView.swift`, `PlanAdjustmentSheet.swift`. 전체 member_ids는 provenance.json에 있다.

### 60. 닫기 시도와 위임 전달

전체 노드: **9개** · 응집도: **0.222222**.

출처: `Hanju/Features/Library/UnsavedChangesGuard.swift`.

주요 구성: `.presentationControllerShouldDismiss()`, `.presentationControllerDidAttemptToDismiss()`, `.presentationControllerDidDismiss()`, `.presentationControllerWillDismiss()`, `original delegate.presentationcontrollerdidattempttodismiss`, `original delegate.presentationcontrollerdiddismiss`, `original delegate.presentationcontrollershoulddismiss`, `original delegate.presentationcontrollerwilldismiss`. 전체 member_ids는 provenance.json에 있다.

### 61. 메모 저장 상태 표현

전체 노드: **9개** · 응집도: **0.222222**.

출처: `Hanju/Features/Records/WeeklyMemoCoordinator.swift`.

주요 구성: `Status`, `Draft`, `.isDirty`, `failed`, `idle`, `pending`, `saved`, `saving`. 전체 member_ids는 provenance.json에 있다.

### 62. 현지 시각과 해석 값

전체 노드: **9개** · 응집도: **0.277778**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Models/LocalDate.swift`.

주요 구성: `LocalTime`, `.init()`, `.init()`, `Resolution`, `LocalTime.init(hour:minute:)`, `Int`, `String`, `.label`. 전체 member_ids는 provenance.json에 있다.

### 63. 실행 강조와 색상 에셋

전체 노드: **8개** · 응집도: **0.250000**.

출처: `Hanju/Assets.xcassets/AccentColor.colorset/Contents.json`, `Hanju/Assets.xcassets/AccentSubtle.colorset/Contents.json`, `Hanju/Assets.xcassets/Background.colorset/Contents.json`, `Hanju/Assets.xcassets/OnAccent.colorset/Contents.json`, `Hanju/Assets.xcassets/Surface.colorset/Contents.json`, `Hanju/Assets.xcassets/TextPrimary.colorset/Contents.json`, `Hanju/Assets.xcassets/TextSecondary.colorset/Contents.json`, `Hanju/Design/DesignTokens.swift`.

주요 구성: `실행 강조와 대비 색상`, `실행 패널의 연한 강조색`, `강조 버튼의 전경 색상`, `AccentColor.colorset/Contents.json`, `Background.colorset/Contents.json`, `Surface.colorset/Contents.json`, `TextPrimary.colorset/Contents.json`, `TextSecondary.colorset/Contents.json`. 전체 member_ids는 provenance.json에 있다.

### 64. 루틴 행과 입력 오류

전체 노드: **8개** · 응집도: **0.250000**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineRow.swift`.

주요 구성: `RoutineRow`, `RoutineFieldError`, `View`, `.body`, `String`, `.body`, `.details`, `String`. 전체 member_ids는 provenance.json에 있다.

### 65. 날짜와 시각 입력

전체 노드: **7개** · 응집도: **0.285714**.

출처: `Hanju/Features/Week/PlanDateFields.swift`.

주요 구성: `PlanDateFields`, `.timeBinding`, `ClosedRange`, `.dateBinding`, `.hasTime`, `Binding`, `Date`. 전체 member_ids는 provenance.json에 있다.

### 66. 계획 초안과 횟수 배분

전체 노드: **7개** · 응집도: **0.619048**.

출처: `Hanju/Features/Week/PlanDraft.swift`.

주요 구성: `Entry`, `.allocate()`, `.init()`, `.validateCounts()`, `String`, `Int`, `UUID`. 전체 member_ids는 provenance.json에 있다.

### 67. V1 루틴 영속 필드

전체 노드: **7개** · 응집도: **0.428571**.

출처: `Hanju/Models/HanjuSchemaV1.swift`.

주요 구성: `RoutineTemplate`, `.init()`, `Date`, `String`, `UUID`, `Bool`, `Int`. 전체 member_ids는 provenance.json에 있다.

### 68. OS 알림 권한 상태

전체 노드: **7개** · 응집도: **0.285714**.

출처: `Hanju/Services/Notifications/SystemNotificationClient.swift`.

주요 구성: `Authorization`, `authorized`, `denied`, `ephemeral`, `notDetermined`, `provisional`, `unknown`. 전체 member_ids는 provenance.json에 있다.

### 69. 명시 목록과 타이머 보존

전체 노드: **6개** · 응집도: **0.400000**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Week/WeekView.swift`, `HanjuUITests/ExecutionUITests.swift`.

주요 구성: `명시 agenda 목록과 타이머 보존`, `주간 계획과 늦은 완료`, `탭 탐색과 실행 연결`, `같은 날짜의 명시 agenda 요청`, `성공 날짜 목록과 취소 상세 보존`, `명시 목록 전환 회귀 정의`. 전체 member_ids는 provenance.json에 있다.

### 70. 루틴 목록 접근성 초점

전체 노드: **6개** · 응집도: **0.333333**.

출처: `Hanju/Features/Library/RoutineListView.swift`.

주요 구성: `Focus`, `archive`, `empty`, `filter`, `newRoutine`, `routine`. 전체 member_ids는 provenance.json에 있다.

### 71. 선호 요일과 날짜 계약

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Models/LocalDate.swift`, `docs/development/data-contracts.md`.

주요 구성: `월요일 기준 선호 요일 계약`, `선택 입력과 선호 요일 검증`, `시간대 독립 계획 날짜`, `현지 시각과 DST 설명`, `LocalDate.swift`. 전체 member_ids는 provenance.json에 있다.

### 72. 에셋 카탈로그 메타데이터

전체 노드: **1개** · 응집도: **1.000000**.

출처: `Hanju/Assets.xcassets/Contents.json`.

주요 구성: `Assets.xcassets/Contents.json`. 전체 member_ids는 provenance.json에 있다.

## God Nodes

- `Hanju 네이티브 프로젝트` — 차수 52 · `Hanju.xcodeproj/project.pbxproj:L481`.
- `LocalDate` — 차수 49 · `Hanju/Models/LocalDate.swift:L4`.
- `NotificationCoordinator` — 차수 49 · `Hanju/Services/Notifications/NotificationCoordinator.swift:L5`.
- `ExecutionSnapshot` — 차수 41 · `Hanju/Features/Execution/ExecutionSnapshot.swift:L3`.
- `ios-test-plan.test.cjs` — 차수 34 · `.github/scripts/ios-test-plan.test.cjs:L1`.
- `.makeContainer()` — 차수 33 · `Hanju/Persistence/PersistenceStore.swift:L24`.
- `Foundation` — 차수 32 · `HanjuTests/WeekPlanTests.swift:L1`.
- `WeekView` — 차수 31 · `Hanju/Features/Week/WeekView.swift:L16`.

## Surprising Connections

PR 경로 선택기는 기존 XCTest 소스 inventory와 실제 xcresult suite 확인을 연결한다. workflow의 테스트 선택·실행·검증 단계는 같은 plan JSON을 사용하며, 문서의 main 회귀 확인 정책은 선별 검사와 전체 회귀를 별개로 해석하게 한다. 이 연결은 소스 정의이며 실제 실행 성공을 뜻하지 않는다.

## Suggested Questions

- 변경 경로에서 실행 UI suite와 실제 결과 검증까지 어떤 근거로 이어지는가?
- PR의 선별 성공과 main 전체 회귀 결과를 어떤 SHA와 artifact로 구분하는가?
- Git diff나 XCTest inventory가 불완전할 때 전체 검사로 폴백하는 경로는 어디인가?

## 건강 상태와 해석 한계

- 105개 main 추적 입력 중 100개는 동일하고 5개를 갱신했다(신규 CJS 2개·기존 workflow/docs 3개·삭제 0개). 불변 관계 3705개와 소유 노드의 전체 payload·방향을 보존했다. 단순 graph export나 오래된 manifest로 원시 관계를 복원하지 않았다.
- 신규 CJS 2파일에서 설치 Graphify AST 38개 node occurrence/82개 원시 관계를 실제 추출했다. 대소문자를 구별하는 FULL 배열과 full(reason) 함수의 ID 충돌 1개를 원문 L5/L15로 분리했다. 선언 대상 1개·배열 값 읽기 1개·exports 객체 9개 관계를 교정하고 원래 방출·현재 payload를 모두 보존했다. export 나열이나 JSON.stringify(FULL)을 함수 실행으로 해석하지 않는다.
- 기존 Swift는 재추출하지 않았다. receiver 교정 78개·export 교정 2개·qualified type 및 stub 보정 이력을 그대로 보존한다. Swift 동명·overload·closure·중첩 타입/함수와 CJS 대소문자 ID·callback/고차함수·producer 내부 중복 억제 한계가 남는다. 전체 컴파일러 타입·런타임 흐름을 보장하지 않는다.
- workflow의 이전 인라인 xcodebuild 관계 1개는 새 workflow→CJS execute→buildArguments→공유 scheme의 명시 경로로 대체했다. 이전 관계와 새 전체 payload·출처 앵커를 별도로 보존했다. 나머지 변경 문서의 유지 관계는 현재 원문/이동 줄을 재검증했다. 실제 앱/테스트 소스는 이번 변경에 없다.
- 무방향 topology는 여러 관계와 방향을 합친다. 각 link.evidence에 원시 3821개 관계의 모든 필드를 보존했고 endpoint 쌍별 Counter로 검증했다. 단일 link 속성 대신 evidence를 읽어야 한다.
- 고립 에셋 카탈로그 Contents.json 1개를 보존했다. self-edge 2개 중 기존 NotificationInbox.shared 생성자 표현은 메서드 재귀가 아니며, 새 verifyResults.visit의 자식 순회 호출은 원문에 있는 의도된 재귀다. 전체 hub·AST 멤버·외부 타입을 응집도 계산에서 제외하지 않았다.
- 설치 detector는 design/tokens.json 파일명을 sensitive로 1개 표시하지만 실제 색상·서체·간격 디자인 값임을 원문 확인해 명시 입력으로 유지했다. 미분류 pbxproj/scheme을 포함하고 skills-lock.json은 외부 스킬 의존성 입력으로 제외했다. 비밀키나 사용자 데이터는 입력하지 않았다.
- #44의 PR 선별 검사와 main 전체 회귀는 별도 결과다. 문서 전용 native skip SUCCESS는 전체 회귀 통과가 아니다. 그래프 생성은 Node self-check·네이티브 앱 테스트·원격 CI를 실행하지 않았으며 main 전체 회귀 완료나 제품 인수를 새로 확인하지 않았다. 실제 실패 시 다음 기능 병합을 보류한다는 현재 리뷰 정책을 확인해야 한다. 캘린더 #12·실기기/iOS17/전체 접근성·2주 인수 #13은 후속이다.
- 실제 모델명·입출력 토큰·비용은 확인할 수 없어 null이다. 현재 Codex 세션이 의미 추출과 모든 커뮤니티 라벨을 작성했으며 외부 LLM API를 사용하지 않았다. 비용 0을 뜻하지 않는다.

## 사용 기록

현재 Codex 세션이 의미 추출·전체 한국어 라벨을 작성했다. 모델명·입출력 토큰·비용은 알 수 없음(null). 외부 LLM API 없음. 네이티브/원격 CI 상태는 이 그래프가 새로 실행하거나 판정하지 않았다.
