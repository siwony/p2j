# 프로젝트 지식 그래프

분석 기준: main `d2bb9e5ffed7a55971fb395c7fd0de9b7e9d9069` · 이슈 #35, #38 · PR #36 · Graphify 0.9.68.

## 전체 집계

입력 **94개**(코드 54개, 문서·설정 40개), 노드 **1140개**, 원시 관계 **2981개**, 무방향 연결 **2796개**, 커뮤니티 **46개**다. 고립 노드 1개, 차수 0 또는 1인 노드 316개다.

표와 각 커뮤니티의 노드 수는 graph.json의 전체 membership 기준이다. 파일 hub·AST 멤버·외부 타입을 제외하는 기본 thin 필터는 사용하지 않았다. 응집도는 설치 Graphify score_all의 전체 membership 계산값이다.

## 이번 분석의 의미

이전 main `cd3cc7359cf2410980a276319a83e08bd9341675`의 완전한 원시 캐시와 입력 SHA256을 확인해 증분 분석했다. 파일 89개는 동일하고 Swift 5개가 수정됐다. 추가·삭제는 없다. 불변 원시 관계 2613개의 모든 필드와 방향을 보존했고, 변경 파일은 불변 AST 문맥을 제공해 다시 추출했다. 문서·설정 40개는 모두 동일하며 오래된 native manifest는 사용하지 않았다.

#35 메모 재시도는 isLoaded 대신 isDirty를 따른다. clean 재조회 실패는 다시 읽고 성공 시 오류를 해제한다. dirty 편집과 빈 clear의 저장 실패는 쓰기로 재시도하며 재조회로 원문을 버리지 않는다. 첫 읽기 실패의 미로딩 초안을 저장하지 않는 보호는 유지한다. 기록 화면과 이전 메모 참고 화면의 오류 안내·버튼도 같은 분기에 맞춘다.

#38 완료 행은 기존 edit action을 유지하면서 label의 최대 가로 폭 frame과 Rectangle contentShape로 빈 영역까지 탭할 수 있게 한다. UI 테스트는 최초 일반 탭을 유지하고 0분 저장 뒤 오른쪽 85% 지점 탭의 실행 기록 sheet를 명시 확인한다. 주 탐색 helper는 lazy range 행과 버튼이 실제 보이는지 확인하고 저장한 정확한 주 범위를 기다린다. 최초 지난주 입력 확인, 탭·background·재실행·계획 취소·최종 메모 보존 검증을 유지한다. 이 문단은 테스트 정의의 의미이며 새 테스트 실행 결과가 아니다.

V4 주별 메모와 최초 날짜 이동 근거, 수행일 집계, 원본 snapshot·시간 미기록/0분/불확실 구분 계약은 유지된다. #37 기록 헤더 간격은 수정하지 않았다. iOS CI 정의의 제한은 55분이다. 알림 #11, 캘린더 #12, 실기기와 전체 인수 #13은 후속이며 전체 MVP 완료를 뜻하지 않는다.

## 이전 결과와 대응

노드 1125→1140개(+15), 원시 관계 2935→2981개(+46), 연결 2752→2796개(+44), 커뮤니티 54→46개다. 23개 노드를 추가했고 타입 참조 stub 8개는 현재 문맥의 ID로 정규화했다. 이전 18개 관련 관계와 새 관계의 전체 payload·원문 앵커를 provenance.json에 대응시켰다. 동일 파일 2613개 관계는 어떤 endpoint도 바꾸지 않았다. 새 AST 330개는 교정 전 payload까지 모두 보존하며 강제 export는 사용하지 않았다.

이전 교정 53개는 보존하고 변경 파일의 5개는 재적용했다. 기존 read 오인 관계는 현재 AST가 방출하지 않아 명시 semantic indirect_call로 실제 호출만 표현했다. Task 생성이 Status.pending 호출로 오인된 새 1개는 원본 payload를 남겨 교정했다. 현재 교정 59개와 기존 exports 2개를 추적한다. 중첩 visible 함수와 호출도 AST가 빠뜨려 현재 Codex가 원문 근거로 의미 관계를 보완했다.

## 커뮤니티 전체 목록

| ID | 이름 | 전체 노드 | 응집도 |
|---:|---|---:|---:|
| 0 | 실행 시간과 기록 회귀 | 92 | 0.075012 |
| 1 | 주간 저장과 메모 수명 | 88 | 0.053292 |
| 2 | 루틴 입력과 저장 검증 | 67 | 0.056988 |
| 3 | 계획 명령과 회차 이전 | 65 | 0.088462 |
| 4 | 루틴 편집과 목록 상태 | 60 | 0.051977 |
| 5 | 동결 스키마와 데이터 이전 | 47 | 0.061980 |
| 6 | 닫기 시도와 UIKit 위임 | 39 | 0.080972 |
| 7 | 완료 편집과 행 탭 | 39 | 0.076923 |
| 8 | 이슈 커밋과 PR 정책 | 35 | 0.077311 |
| 9 | 화면 계약과 실행 탐색 | 33 | 0.094697 |
| 10 | 기록 집계와 저장 실패 | 32 | 0.133065 |
| 11 | 네이티브 파일과 프로젝트 연결 | 29 | 0.125616 |
| 12 | 주간 선택과 초안 상태 | 28 | 0.124339 |
| 13 | 지역 날짜와 시각 해석 | 27 | 0.125356 |
| 14 | 복귀 계획과 후속 연동 | 25 | 0.113333 |
| 15 | 제품 범위와 기록 정책 | 25 | 0.143333 |
| 16 | 모델 파일과 회귀 검증 | 25 | 0.166667 |
| 17 | 회차 상태와 화면 값 | 23 | 0.098814 |
| 18 | 제품 방향과 기술 기반 | 22 | 0.173160 |
| 19 | 이번 주 실행과 복귀 | 22 | 0.212121 |
| 20 | 계획 조정과 시트 동작 | 20 | 0.136842 |
| 21 | 실행 탐색 화면 검증 | 20 | 0.263158 |
| 22 | 실행 원본과 복구 계약 | 19 | 0.116959 |
| 23 | 주 탐색과 메모 검증 | 18 | 0.254902 |
| 24 | 호출자 복귀와 실행 환경 | 18 | 0.124183 |
| 25 | 루틴 편집 화면 검증 | 18 | 0.372549 |
| 26 | V4 기록과 메모 계약 | 17 | 0.169118 |
| 27 | 커밋 훅과 리베이스 검증 | 17 | 0.382353 |
| 28 | 오늘 실행과 완료 동작 | 17 | 0.308824 |
| 29 | 개발 협업과 리뷰 규칙 | 15 | 0.228571 |
| 30 | 명시 요청과 호출자 구분 | 14 | 0.175824 |
| 31 | 주간 계획 화면 검증 | 14 | 0.340659 |
| 32 | 하단 탭과 루틴 진입 | 13 | 0.166667 |
| 33 | 수행일 기록과 메모 안내 | 13 | 0.166667 |
| 34 | 날짜 입력과 닫기 동작 | 12 | 0.166667 |
| 35 | 메모 재시도와 초안 보존 | 11 | 0.236364 |
| 36 | 계획 오류와 입력 제한 | 10 | 0.200000 |
| 37 | 구현 인계와 루틴 값 | 8 | 0.285714 |
| 38 | 실행 강조와 색상 에셋 | 8 | 0.250000 |
| 39 | 계획 초안과 횟수 배분 | 7 | 0.619048 |
| 40 | 네이티브 CI와 공유 scheme | 6 | 0.400000 |
| 41 | 주간 날짜와 이전 메모 | 6 | 0.333333 |
| 42 | 선호 요일과 날짜 계약 | 5 | 0.400000 |
| 43 | 계획 조정과 실행 검증 | 5 | 0.400000 |
| 44 | 주간 화면 접근성 초점 | 5 | 0.400000 |
| 45 | 에셋 카탈로그 메타데이터 | 1 | 1.000000 |

### 0. 실행 시간과 기록 회귀

전체 노드: **92개** · 응집도: **0.075012**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/ExecutionTests.swift`, `HanjuTests/RecordsTests.swift`.

구성 예시: `ExecutionClock`, `.elapsed()`, `.now()`, `Sample`, `Date`, `Double`, `Int64`, `UUID`, `ExecutionRecorder`, `.complete()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 1. 주간 저장과 메모 수명

전체 노드: **88개** · 응집도: **0.053292**.

출처: `Hanju/App/HanjuApp.swift`, `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Records/RecordsSnapshot.swift`, `Hanju/Features/Records/RecordsStore.swift`, `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Persistence/PersistenceStore.swift`, `HanjuTests/RecordsMigrationTests.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

구성 예시: `App`, `Equatable`, `ExecutionRecorder`, `HanjuApp`, `.body`, `RecordsSnapshot.swift`, `RecordedTimeSummary`, `RoutineCount`, `.id`, `Bool`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 2. 루틴 입력과 저장 검증

전체 노드: **67개** · 응집도: **0.056988**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Models/HanjuSchemaV1.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/RoutinePersistenceTests.swift`.

구성 예시: `ExecutionError`, `anotherRunning`, `changed`, `.errorDescription`, `futureDate`, `invalidData`, `invalidMinutes`, `Field`, `expectedMinutes`, `firstAction`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 3. 계획 명령과 회차 이전

전체 노드: **65개** · 응집도: **0.088462**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `HanjuTests/WeekPlanTests.swift`.

구성 예시: `.save()`, `PlanDraft`, `.validate()`, `ModelContext.fetch`, `PlanWriter`, `.check()`, `.commit()`, `.confirm()`, `.fetch()`, `.find()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 4. 루틴 편집과 목록 상태

전체 노드: **60개** · 응집도: **0.051977**.

출처: `Hanju/Features/Library/RoutineEditorSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineSnapshot.swift`.

구성 예시: `SwiftUI DismissAction.callAsFunction`, `PendingAction`, `archive`, `dismiss`, `RecoveryAction`, `archive`, `save`, `RoutineEditorSheet`, `.archive()`, `.body`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 5. 동결 스키마와 데이터 이전

전체 노드: **47개** · 응집도: **0.061980**.

출처: `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `HanjuTests/SchemaMigrationTests.swift`.

구성 예시: `HanjuSchemaV1`, `.models`, `.versionIdentifier`, `PersistentModel`, `Schema`, `HanjuMigrationPlan`, `.schemas`, `.stages`, `ExecutionInterval`, `.init()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 6. 닫기 시도와 UIKit 위임

전체 노드: **39개** · 응집도: **0.080972**.

출처: `Hanju/Features/Library/UnsavedChangesGuard.swift`.

구성 예시: `Any`, `Context`, `Coordinator`, `.attach()`, `.detach()`, `.forwardingTarget()`, `.presentationControllerDidAttemptToDismiss()`, `.presentationControllerDidDismiss()`, `.presentationControllerShouldDismiss()`, `.presentationControllerWillDismiss()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 7. 완료 편집과 행 탭

전체 노드: **39개** · 응집도: **0.076923**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Records/RecordsView.swift`, `HanjuUITests/RecordsUITests.swift`.

구성 예시: `ExecutionSnapshot`, `CompletionSheet`, `.body`, `.dateBinding`, `.dirty`, `.init()`, `.latestAllowedDay`, `.save()`, `.undo()`, `SwiftUI DismissAction.callAsFunction`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 8. 이슈 커밋과 PR 정책

전체 노드: **35개** · 응집도: **0.077311**.

출처: `.githooks/commit-msg`, `.github/ISSUE_TEMPLATE/bug.md`, `.github/ISSUE_TEMPLATE/task.md`, `.github/scripts/pr-policy.cjs`, `.github/scripts/pr-policy.test.cjs`, `.github/scripts/test_commit_msg.py`, `.github/workflows/pr-policy.yml`, `CONTRIBUTING.md`, `docs/development/review-workflow.md`.

구성 예시: `이슈 연결 Git 규칙`, `이슈부터 시작`, `PR 정책과 main 보호`, `commit-msg`, `Validate project commit conventions without third-party dependencies.`, `rebase 원래 브랜치 검증`, `reject()`, `bug.md`, `task.md`, `pr-policy.cjs`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 9. 화면 계약과 실행 탐색

전체 노드: **33개** · 응집도: **0.094697**.

출처: `.github/copilot-instructions.md`, `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `design/preview/index.html`, `docs/product-plan.md`.

구성 예시: `ActiveRoutinePanel`, `CalendarSyncState`, `03-components.md`, `WeekDaySelector`, `CalendarSheet 주별 연결`, `Routine Editor 편집 시트`, `ExecutionRecord`, `명시적 날짜 열기의 Week 목록 복귀`, `04-screens.md`, `Routine Library 루틴함`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 10. 기록 집계와 저장 실패

전체 노드: **32개** · 응집도: **0.133065**.

출처: `HanjuTests/ExecutionTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

구성 예시: `Error`, `Failure`, `disk`, `Failure`, `disk`, `RecordsTests`, `.fixture()`, `.read()`, `.records()`, `.sample()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 11. 네이티브 파일과 프로젝트 연결

전체 노드: **29개** · 응집도: **0.125616**.

출처: `Hanju.xcodeproj/project.pbxproj`, `Hanju/App/AppTabs.swift`, `Hanju/App/HanjuApp.swift`, `Hanju/Design/DesignTokens.swift`, `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `Hanju/Features/Library/LibraryView.swift`, `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Features/Library/RoutineEditorSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Features/Library/UnsavedChangesGuard.swift`, `Hanju/Features/Today/TodayView.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/RoutineTemplate.swift`, `HanjuUITests/RoutineLibraryUITests.swift`.

구성 예시: `CGFloat`, `AppTabs.swift`, `HanjuApp.swift`, `앱 수명 실행 환경 주입`, `DesignTokens.swift`, `DesignTokens`, `수행일과 선택 시간 편집`, `RunningRoutineView.swift`, `실행 제어와 시간 표시`, `LibraryView.swift`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 12. 주간 선택과 초안 상태

전체 노드: **28개** · 응집도: **0.124339**.

출처: `Hanju/Features/Week/WeeklySelectionSheet.swift`.

구성 예시: `DayWorkload`, `.label()`, `SwiftUI DismissAction.callAsFunction`, `Binding`, `Bool`, `Error`, `LocalDate`, `String`, `UUID`, `Void`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 13. 지역 날짜와 시각 해석

전체 노드: **27개** · 응집도: **0.125356**.

출처: `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Models/LocalDate.swift`, `HanjuTests/WeekPlanTests.swift`.

구성 예시: `Calendar`, `Codable`, `Comparable`, `.body`, `.timeBinding`, `LocalDate`, `.calendar()`, `LocalDate.init(year:month:day:)`, `.fullLabel`, `.id`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 14. 복귀 계획과 후속 연동

전체 노드: **25개** · 응집도: **0.113333**.

출처: `design/03-components.md`, `design/05-swiftui-handoff.md`, `docs/development/data-contracts.md`, `docs/development/implementation-plan.md`, `docs/development/planning-revision-1.3.md`, `docs/product-plan.md`.

구성 예시: `CompletionSheet 수행일 편집`, `ReplanEntry 복귀 진입`, `RestWeekAction 쉬기 확인`, `실제 공유 UI 추출`, `기능별 폴더 구조`, `캘린더 연결과 쓰기 직렬화`, `캘린더 중단 후 복구 계약`, `LocalDate와 DST 해석`, `주 이동별 캘린더 조정`, `data-contracts.md`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 15. 제품 범위와 기록 정책

전체 노드: **25개** · 응집도: **0.143333**.

출처: `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/product-plan.md`.

구성 예시: `WeekMemo 입력`, `Records 행동 우선 기록`, `Settings 설정 화면`, `초안 보존과 저장 결과`, `채택 기술 구성`, `AC-05 직접 완료와 수행일 정정`, `AC-06 알림`, `AC-08 캘린더 중단과 외부 수정`, `AC-09 주간 메모`, `AC-10 행동 우선 기록과 주 경계`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 16. 모델 파일과 회귀 검증

전체 노드: **25개** · 응집도: **0.166667**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/ExecutionTests.swift`, `HanjuTests/RecordsMigrationTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/RoutinePersistenceTests.swift`, `HanjuTests/SchemaMigrationTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuUITests/WeekPlanUITests.swift`.

구성 예시: `Foundation`, `Hanju`, `OccurrenceSnapshot.swift`, `계획 화면 값 복사`, `PlanDraft.swift`, `횟수 배분과 확정 초안`, `HanjuSchemaV2.swift`, `동결 모델과 V4 이전`, `계획 항목의 영속 스냅샷`, `HanjuSchemaV3.swift`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 17. 회차 상태와 화면 값

전체 노드: **23개** · 응집도: **0.098814**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Today/TodayView.swift`, `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Editor`, `completion`, `.id`, `move`, `OccurrenceSnapshot`, `.canReplan`, `.init()`, `.isUnfinished`, `.statusLabel`, `Status`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 18. 제품 방향과 기술 기반

전체 노드: **22개** · 응집도: **0.173160**.

출처: `DEVELOPMENT_HANDOFF.md`, `README.md`, `design/01-direction.md`, `design/02-foundations.md`, `design/contrast-report.json`, `design/preview/index.html`, `design/reference/user-design-brief.txt`, `design/tokens.json`, `docs/adr/0001-native-ios-foundation.md`, `docs/development/implementation-plan.md`, `docs/development/local-development.md`.

구성 예시: `정돈한 생활의 페이지`, `01-direction.md`, `차분한 숲빛 강조색`, `처음부터 접근성 지원`, `의미 있는 대비 기준`, `02-foundations.md`, `한국어 시스템 서체`, `지정 색 조합 대비 결과`, `contrast-report.json`, `index.html`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 19. 이번 주 실행과 복귀

전체 노드: **22개** · 응집도: **0.212121**.

출처: `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Editor`, `RunningRoute`, `ExecutionSnapshot`, `Focus`, `OccurrenceSnapshot`, `String`, `UUID`, `Void`, `WeekView`, `.body`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 20. 계획 조정과 시트 동작

전체 노드: **20개** · 응집도: **0.136842**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`.

구성 예시: `SwiftUI DismissAction.callAsFunction`, `Mode`, `move`, `recovery`, `rest`, `PlanAdjustmentSheet`, `.body`, `.canSave`, `.dirty`, `.init()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 21. 실행 탐색 화면 검증

전체 노드: **20개** · 응집도: **0.263158**.

출처: `HanjuUITests/ExecutionUITests.swift`.

구성 예시: `ExecutionUITests`, `.cancel()`, `.createTodayPlans()`, `.pickDate()`, `.reveal()`, `.testDirectCompletionEditCancellationZeroTimeAndUndo()`, `.testExplicitWeekAgendaOpensMovedDateAndSameDayWithoutStoppingRunning()`, `.testPastWeekPausedResumeConfirmsSwitchAndReturnsToSamePlan()`, `.testPriorWeekDirectCompletionAndPerformedDateCorrectionKeepPlanInPlace()`, `.testRecoveryFromRunningWeekKeepsDetailOnCancelAndOpensAgendaOnSave()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 22. 실행 원본과 복구 계약

전체 노드: **19개** · 응집도: **0.116959**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `HanjuTests/ExecutionTests.swift`, `docs/adr/0002-execution-time-and-recovery.md`, `docs/development/data-contracts.md`.

구성 예시: `Darwin`, `실행 시계와 복구 결정`, `V3 실행 저장 계약`, `CompletionSheet.swift`, `원본 수행일의 선택 범위`, `ExecutionClock.swift`, `재실행 시계 비교 한계`, `수면 포함 실행 시계`, `ExecutionSnapshot.swift`, `미기록과 불확실 시간 구분`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 23. 주 탐색과 메모 검증

전체 노드: **18개** · 응집도: **0.254902**.

출처: `HanjuUITests/RecordsUITests.swift`.

구성 예시: `Date`, `RecordsUITests.swift`, `입력과 주별 보존 검증`, `RecordsUITests`, `.application()`, `.completedRow()`, `.createTodayPlan()`, `.pickDate()`, `.reveal()`, `.selectWeek()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 24. 호출자 복귀와 실행 환경

전체 노드: **18개** · 응집도: **0.124183**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Week/WeekView.swift`, `Hanju/Persistence/PersistenceStore.swift`, `HanjuUITests/ExecutionUITests.swift`, `HanjuUITests/WeekPlanUITests.swift`, `design/04-screens.md`.

구성 예시: `지난 작업 재개 계약`, `탭 탐색과 실행 연결`, `ExecutionRecorder.swift`, `앱 수명 실행 명령`, `같은 날짜의 명시 agenda 요청`, `WeekView.swift`, `명시 agenda 목록과 타이머 보존`, `주간 계획과 늦은 완료`, `현재 미완료와 쉬기 안내`, `지난주 재개와 호출 복귀`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 25. 루틴 편집 화면 검증

전체 노드: **18개** · 응집도: **0.372549**.

출처: `HanjuUITests/RoutineLibraryUITests.swift`.

구성 예시: `RoutineLibraryUITests`, `.enter()`, `.finishInput()`, `.openEditor()`, `.openLibrary()`, `.reveal()`, `.routineRow()`, `.swipeEditor()`, `.testCategoryChangeRemainsVisibleAndRevertedEditSwipesCleanly()`, `.testDirtySwipeKeepsInputThenDiscardsAndCleanSwipeDismisses()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 26. V4 기록과 메모 계약

전체 노드: **17개** · 응집도: **0.169118**.

출처: `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `docs/adr/0003-weekly-records-and-memo.md`, `docs/development/data-contracts.md`, `docs/development/implementation-plan.md`.

구성 예시: `부담 없는 계획과 호출자 복귀`, `실제 첫 날짜 이동 근거`, `확정 시간과 합계 한계`, `주별 초안과 저장 세대`, `주별 메모 원문 보존`, `수행일 장부와 루틴 횟수`, `수행일별 기록과 메모 결정`, `동결 모델과 V4 이전`, `기록 기능 검증 문서 근거`, `주간 기록과 메모 저장 계약`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 27. 커밋 훅과 리베이스 검증

전체 노드: **17개** · 응집도: **0.382353**.

출처: `.github/scripts/test_commit_msg.py`.

구성 예시: `CommitMessageHookTests`, `.assert_rejected()`, `.commit()`, `.conflicting_history()`, `.git()`, `.invoke_hook()`, `.reword()`, `.setUp()`, `.test_apply_rebase_uses_original_branch()`, `.test_direct_main_detached_and_invalid_branch_rejected()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 28. 오늘 실행과 완료 동작

전체 노드: **17개** · 응집도: **0.308824**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Today/TodayView.swift`.

구성 예시: `.read()`, `UUID`, `RunningRoute`, `Bool`, `String`, `UUID`, `Void`, `TodayView`, `.activeActions()`, `.body`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 29. 개발 협업과 리뷰 규칙

전체 노드: **15개** · 응집도: **0.228571**.

출처: `.github/pull_request_template.md`, `AGENTS.md`, `CONTRIBUTING.md`, `docs/development/graphify.md`, `docs/development/review-workflow.md`, `docs/product-plan.md`.

구성 예시: `에이전트 파일 소유권`, `모든 PR 최신 Copilot 확인`, `AGENTS.md`, `중요 기술 결정 ADR`, `CONTRIBUTING.md`, `독립 리뷰와 Copilot 대기`, `graphify.md`, `현재 AI 의미 추출과 라벨`, `main 병합 후 그래프 갱신`, `그래프 출처와 무결성`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 30. 명시 요청과 호출자 구분

전체 노드: **14개** · 응집도: **0.175824**.

출처: `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Caller`, `records`, `today`, `Kind`, `adjustment`, `agenda`, `completion`, `plan`, `recovery`, `LocalDate`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 31. 주간 계획 화면 검증

전체 노드: **14개** · 응집도: **0.340659**.

출처: `HanjuUITests/WeekPlanUITests.swift`.

구성 예시: `Bool`, `Date`, `String`, `XCUIApplication`, `XCUIElement`, `WeekPlanUITests`, `.choose()`, `.createRoutine()`, `.pickDate()`, `.reveal()`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 32. 하단 탭과 루틴 진입

전체 노드: **13개** · 응집도: **0.166667**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Library/LibraryView.swift`.

구성 예시: `AppTabs`, `.body`, `Tab`, `library`, `records`, `settings`, `today`, `week`, `Destination`, `archive`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 33. 수행일 기록과 메모 안내

전체 노드: **13개** · 응집도: **0.166667**.

출처: `Hanju/Features/Records/RecordsStore.swift`, `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `HanjuTests/RecordsMigrationTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuUITests/RecordsUITests.swift`.

구성 예시: `RecordsStore.swift`, `확정 시간 합계와 불확실 구분`, `주별 메모 원문 원자 저장`, `수행일별 완료와 실천 횟수`, `RecordsView.swift`, `행동 우선 기록 장부`, `메모 저장과 계획 호출 복귀`, `메모 재시도와 버튼 문구`, `주별 메모 초안과 재시도`, `주별 메모 원문 저장`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 34. 날짜 입력과 닫기 동작

전체 노드: **12개** · 응집도: **0.166667**.

출처: `Hanju/Features/Week/PlanDateFields.swift`.

구성 예시: `ClosedRange`, `Content`, `PlanDateFields`, `.dateBinding`, `.hasTime`, `PlanDismissal`, `.body()`, `Binding`, `Bool`, `Date`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 35. 메모 재시도와 초안 보존

전체 노드: **11개** · 응집도: **0.236364**.

출처: `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

구성 예시: `WeeklyMemoCoordinator.swift`, `입력 세대 확인과 동기 저장`, `초안 변경 여부별 재시도`, `주입 메모 쓰기 호출`, `WeeklySelectionSheet.swift`, `명시 선택과 초안 보호`, `이전 메모 재시도 안내`, `WeeklyMemoCoordinatorTests.swift`, `실패 뒤 편집 보존 검증`, `메모 세대와 실패 보존 검증`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 36. 계획 오류와 입력 제한

전체 노드: **10개** · 응집도: **0.200000**.

출처: `Hanju/Features/Week/PlanDraft.swift`.

구성 예시: `PlanError`, `batchLimit`, `changedOccurrence`, `.errorDescription`, `inactiveRoutine`, `invalidDate`, `invalidDraft`, `invalidStoredData`, `missingOccurrence`, `runningNeedsRecorder`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 37. 구현 인계와 루틴 값

전체 노드: **8개** · 응집도: **0.285714**.

출처: `DEVELOPMENT_HANDOFF.md`, `Hanju/Features/Library/RoutineSnapshot.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `docs/development/implementation-plan.md`, `docs/verification/2026-10-04-foundation.md`.

구성 예시: `실행과 주간 기록 구현 인계`, `변경 초안 swipe 확인 구현`, `주간 기록 구현과 후속 경계`, `2026-10-04-foundation.md`, `기반 네이티브 검증 기록`, `RoutineSnapshot.swift`, `루틴 목록과 편집 값 복사`, `루틴 저장과 보관 명령`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 38. 실행 강조와 색상 에셋

전체 노드: **8개** · 응집도: **0.250000**.

출처: `Hanju/Assets.xcassets/AccentColor.colorset/Contents.json`, `Hanju/Assets.xcassets/AccentSubtle.colorset/Contents.json`, `Hanju/Assets.xcassets/Background.colorset/Contents.json`, `Hanju/Assets.xcassets/OnAccent.colorset/Contents.json`, `Hanju/Assets.xcassets/Surface.colorset/Contents.json`, `Hanju/Assets.xcassets/TextPrimary.colorset/Contents.json`, `Hanju/Assets.xcassets/TextSecondary.colorset/Contents.json`, `Hanju/Design/DesignTokens.swift`.

구성 예시: `실행 패널의 연한 강조색`, `강조 버튼의 전경 색상`, `AccentColor.colorset/Contents.json`, `Background.colorset/Contents.json`, `Surface.colorset/Contents.json`, `TextPrimary.colorset/Contents.json`, `TextSecondary.colorset/Contents.json`, `실행 강조와 대비 색상`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 39. 계획 초안과 횟수 배분

전체 노드: **7개** · 응집도: **0.619048**.

출처: `Hanju/Features/Week/PlanDraft.swift`.

구성 예시: `Entry`, `.init()`, `.allocate()`, `.validateCounts()`, `Int`, `String`, `UUID`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 40. 네이티브 CI와 공유 scheme

전체 노드: **6개** · 응집도: **0.400000**.

출처: `.github/workflows/ios.yml`, `Hanju.xcodeproj/xcshareddata/xcschemes/Hanju.xcscheme`, `docs/development/local-development.md`.

구성 예시: `공유 scheme과 로컬 테스트`, `ios.yml`, `iOS 빌드와 테스트 CI`, `네이티브 CI 시간 제한`, `Hanju.xcscheme`, `Hanju 공유 실행 테스트 scheme`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 41. 주간 날짜와 이전 메모

전체 노드: **6개** · 응집도: **0.333333**.

출처: `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/LocalDate.swift`.

구성 예시: `.nextWeek`, `.lastDay`, `.previousMemo`, `.adding()`, `.monday`, `.weekDays`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 42. 선호 요일과 날짜 계약

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Models/LocalDate.swift`, `docs/development/data-contracts.md`.

구성 예시: `월요일 기준 선호 요일 계약`, `선택 입력과 선호 요일 검증`, `LocalDate.swift`, `시간대 독립 계획 날짜`, `현지 시각과 DST 설명`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 43. 계획 조정과 실행 검증

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `HanjuUITests/ExecutionUITests.swift`.

구성 예시: `PlanAdjustmentSheet.swift`, `계획 변경과 실행 갱신`, `이동 초안과 중립 건너뛰기`, `ExecutionUITests.swift`, `실행 완료와 복원 UI 검증`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 44. 주간 화면 접근성 초점

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Focus`, `day`, `plan`, `rest`, `row`. 전체 member_ids와 출처는 provenance.json에 보존했다.

### 45. 에셋 카탈로그 메타데이터

전체 노드: **1개** · 응집도: **1.000000**.

출처: `Hanju/Assets.xcassets/Contents.json`.

구성 예시: `Assets.xcassets/Contents.json`. 전체 member_ids와 출처는 provenance.json에 보존했다.

## 건강 상태와 해석 한계

- 증분 입력은 이전 main 원문의 SHA256과 완전한 원시 추출 캐시로 확인했다. 오래된 native manifest는 사용하지 않았다. 동일 파일 89개의 원시 관계 2613개는 모든 payload·방향 그대로 유지하고 변경 Swift 5개만 불변 AST 문맥과 함께 재추출했다. 문서·설정 입력은 모두 동일하다.
- 타입 사용 stub 8개가 이번 추출 문맥에서 공통 타입 ID 또는 실제 Focus enum ID로 정규화됐다. 원문 삭제가 아니다. 이전 18개 관련 원시 관계와 현재 관계의 모든 payload·원문 앵커를 previous_published_comparison에서 대응하고, 불변 파일 관계는 ID를 바꾸지 않았다. 공통 타입 ID가 반드시 실제 선언을 뜻하지는 않는다. 강제 export는 사용하지 않았다.
- 무방향 link는 여러 방향·관계를 축약한다. link.evidence의 모든 source/target/relation과 전체 필드를 사용해야 한다. 원시 2981개를 순서 없는 endpoint 쌍별 Counter로 검증한다.
- 이전 receiver 교정 53개는 동일 원문과 함께 보존했다. 변경 파일의 기존 6개 중 5개는 재적용했고 read closure 오인 관계 1개는 이번 AST에서 방출되지 않았다. 원래 payload와 비방출 이유를 남기고 실제 read 호출만 semantic indirect_call로 보완했다. 새로 확인한 Task 생성→Status.pending 오인 1개를 보정했다. 현재 교정 59개와 기존 exports 2개를 보존하며 새 AST 교정 전 payload를 extraction_before_correction에 남겼다.
- 정적 AST는 동명 심볼·오버로드·closure·중첩 함수를 완전히 해석하지 못한다. selectWeek의 중첩 visible 함수/호출은 원문 기반 의미 관계로 보완했다. 주입 read와 Task 생성의 해석은 런타임 실행을 확정하지 않는다. producer 내부 중복 억제 때문에 모든 방출 관계 보존은 소스의 모든 호출 발견을 보장하지 않는다.
- 에셋 카탈로그 루트 Contents.json 1개는 고립 상태로 보존했다. 모든 파일 hub·AST 멤버·외부 타입을 전체 커뮤니티 수치에 포함한다. 낮은 응집도와 미해결 호출 진단을 숨기지 않는다.
- 테스트와 CI 관계는 현재 소스 정의를 읽은 것이다. 이번 그래프 작업은 네이티브 테스트나 원격 CI를 실행·재확인하지 않았다. 제품 PR36의 검증 결과를 새 실행 결과로 보고하지 않는다. 실제 기기와 전체 MVP 인수는 미검증이다.
- #35 메모 재조회/저장 재시도 분기와 #38 완료행 빈 영역 탭 수정은 구현되었다. #37 기록 헤더 간격은 이번 범위 밖의 미해결 후속이며 알림 #11·캘린더 #12·실기기/전체 인수 #13도 후속이다. V4/수행일 집계와 원문 보존 계약은 유지된다. 메모는 debounce 이전 강제 종료까지 보장하는 영속 초안 journal이 없다.
- 실제 모델명·토큰 사용량·비용은 관측되지 않아 null이다. 외부 LLM API를 사용하지 않았다는 사실은 비용 0을 뜻하지 않는다.

## 사용 기록

의미 추출과 전체 커뮤니티 라벨은 현재 Codex 세션이 담당했다. 외부 LLM API 호출 없음. 모델명·입력 토큰·출력 토큰·비용은 알 수 없음(null)이다. 앱 테스트·원격 CI를 이번 작업에서 실행하지 않았다. 다음 갱신도 제품 변경의 main 병합 후 고정 SHA에서 수행한다.
