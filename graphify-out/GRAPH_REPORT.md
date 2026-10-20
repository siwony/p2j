# 프로젝트 지식 그래프

분석 기준: main `089b3ee2bffc2a4e0e7b018f3eee6a2916368666` · 이슈 #37 · 코드 PR #40 · Graphify 0.9.68. 그래프 결과 PR의 병합 SHA와 이 분석 소스 SHA는 별개다.

## 전체 집계

입력 **94개**(코드 54개, 문서·설정 40개), 노드 **1140개**, 원시 관계 **2983개**, 무방향 연결 **2798개**, 커뮤니티 **52개**다. 고립 노드 1개, 차수 0 또는 1인 노드 316개다.

표와 각 커뮤니티는 graph.json 전체 membership 기준이다. 파일 hub·AST 멤버·외부 타입을 제외하는 thin 필터는 사용하지 않았다. 응집도는 설치 Graphify score_all의 원값이다.

## 이번 증분 분석

이전 main `d2bb9e5ffed7a55971fb395c7fd0de9b7e9d9069`의 완전한 원시 캐시와 94개 입력 해시를 검증했다. 93개 파일은 동일하고 RecordsView.swift 한 파일만 변경됐으며 추가·삭제 입력은 없다. 불변 관계 2901개의 모든 payload와 방향을 유지했다. 변경 파일은 AST 31개 노드 occurrence/72개 관계를 다시 추출하고 기존 의미 4개 노드/8개 관계를 원문 재확인해 유지했다. 현재 Codex가 헤더 의미 1개 노드/2개 관계만 추가했다.

#37 recordsHeader의 상하 padding을 아래쪽 DesignTokens.spacing/2만 남기도록 바꿨다. headline Text, 최대 가로 폭 leading 정렬, 가로 token 여백, 불투명 배경과 기본 List/Section 구조를 유지한다. 날짜·루틴 횟수·기록 시간·주간 메모 제목에 공통 적용된다. 스크롤 상태·offset·고정 높이·전역 토큰을 추가하지 않았으며 전체 행 탭·저장·집계·타이머·탐색은 그대로다. 소스 의미를 기술한 것으로 실제 스크롤·간격·접근성 실행 결과가 아니다.

#35 메모 clean/dirty 재시도와 #38 전체 행 탭 구현은 유지된다. V4 메모·이동 근거, 수행일 집계·원본 보존도 유지된다. iOS CI 정의의 제한은 55분이다. 알림 #11, 캘린더 #12, 실기기와 전체 인수 #13은 후속이다. 전체 MVP나 AC13 완료를 주장하지 않는다.

## 이전 결과와 정확한 대응

노드 1140→1140, 원시 관계 2981→2983, 연결 2796→2798, 커뮤니티 46→52다. 현재 구성원을 전부 읽어 새 커뮤니티 이름을 정했으며 이전 ID의 이름을 복사하지 않았다.

타입 사용 stub 6개를 이번 추출의 공통 ID로 대응했다. 이전 관련 15개 관계의 전체 payload·방향·원문 앵커가 provenance에 있다. L24 WeeklyMemoCoordinator.Draft의 outer type 참조가 사용 stub로 방출된 것은 실제 유일한 WeeklyMemoCoordinator 선언으로 명시 정규화했다. fresh 원본 node/edge·이전 관계·정규화 관계와 유일한 선언 앵커를 별도로 기록했다. receiver 교정이나 내부 Draft 전체 타입 추론과 구분한다. L164 memos.load 교정은 원래 오인 payload를 남겼고 불변 58개 receiver/2개 export 교정을 유지했다. 이전 실행의 stub/비방출 감사도 historical_extractor_audits에 보관한다. 입력 삭제나 강제 export는 없다.

## 커뮤니티 전체 목록

| ID | 이름 | 전체 노드 | 응집도 |
|---:|---|---:|---:|
| 0 | 실행 시간과 구간 검증 | 92 | 0.075012 |
| 1 | 루틴 입력과 저장 검증 | 67 | 0.056536 |
| 2 | 계획 명령과 회차 이전 | 65 | 0.088462 |
| 3 | 루틴 편집과 목록 상태 | 60 | 0.052542 |
| 4 | 닫기 시도와 UIKit 위임 | 39 | 0.080972 |
| 5 | 커밋 훅과 리베이스 검증 | 33 | 0.136364 |
| 6 | V3 V4 모델 이전 | 33 | 0.083333 |
| 7 | 기록 집계와 실패 검증 | 32 | 0.133065 |
| 8 | 주별 메모와 재시도 검증 | 29 | 0.206897 |
| 9 | 네이티브 파일과 프로젝트 연결 | 28 | 0.134921 |
| 10 | 실행 원본과 복구 계약 | 28 | 0.089947 |
| 11 | 제품 방향과 시각 기반 | 28 | 0.137566 |
| 12 | 제품 범위와 기록 정책 | 28 | 0.129630 |
| 13 | 주간 선택과 초안 상태 | 28 | 0.124339 |
| 14 | 기록 저장과 디스크 이전 | 26 | 0.147692 |
| 15 | 기록 제목과 화면 상태 | 25 | 0.126667 |
| 16 | 화면 계약과 실행 탐색 | 25 | 0.123333 |
| 17 | 이번 주 실행과 복귀 | 25 | 0.180000 |
| 18 | 개발 협업과 리뷰 규칙 | 22 | 0.151515 |
| 19 | 지역 날짜와 주 경계 | 22 | 0.134199 |
| 20 | 복귀 계획과 후속 연동 | 21 | 0.133333 |
| 21 | 메모 재시도와 기록 계약 | 21 | 0.119048 |
| 22 | 행 탭과 주 탐색 검증 | 20 | 0.215789 |
| 23 | 모델 파일과 회귀 연결 | 20 | 0.152632 |
| 24 | 계획 조정과 시트 동작 | 20 | 0.136842 |
| 25 | 실행 탐색 화면 검증 | 20 | 0.263158 |
| 26 | 루틴 편집 화면 검증 | 18 | 0.372549 |
| 27 | 구현 인계와 네이티브 CI | 17 | 0.139706 |
| 28 | 오늘 실행과 완료 동작 | 17 | 0.308824 |
| 29 | V4 기록과 메모 계약 | 16 | 0.183333 |
| 30 | 주간 집계와 조회 값 | 15 | 0.190476 |
| 31 | 이슈 연결과 PR 정책 | 14 | 0.197802 |
| 32 | 회차 상태와 화면 값 | 14 | 0.142857 |
| 33 | V1 디스크 이전 검증 | 14 | 0.241758 |
| 34 | 주간 계획 화면 검증 | 14 | 0.340659 |
| 35 | 날짜 입력과 닫기 동작 | 13 | 0.153846 |
| 36 | 실행 재개와 호출 복귀 | 13 | 0.179487 |
| 37 | 하단 탭과 루틴 진입 | 13 | 0.166667 |
| 38 | 앱 수명과 저장소 구성 | 12 | 0.212121 |
| 39 | 완료 기록과 수행일 편집 | 12 | 0.196970 |
| 40 | 현지 시각과 해석 값 | 11 | 0.218182 |
| 41 | 명시 목록과 타이머 보존 | 11 | 0.200000 |
| 42 | 계획 오류와 입력 제한 | 10 | 0.200000 |
| 43 | 실행 강조와 색상 에셋 | 8 | 0.250000 |
| 44 | 명시 요청과 조정 종류 | 8 | 0.250000 |
| 45 | 계획 초안과 횟수 배분 | 7 | 0.619048 |
| 46 | 메모 저장 상태 표현 | 6 | 0.333333 |
| 47 | 계획 회차 상태 표현 | 6 | 0.333333 |
| 48 | 선호 요일과 날짜 계약 | 5 | 0.400000 |
| 49 | 주간 화면 접근성 초점 | 5 | 0.400000 |
| 50 | 기록과 오늘 호출자 | 3 | 0.666667 |
| 51 | 에셋 카탈로그 메타데이터 | 1 | 1.000000 |

### 0. 실행 시간과 구간 검증

전체 노드: **92개** · 응집도: **0.075012**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/ExecutionTests.swift`, `HanjuTests/RecordsTests.swift`.

구성 예시: `ExecutionClock`, `.elapsed()`, `.now()`, `Sample`, `Date`, `Double`, `Int64`, `UUID`, `ExecutionRecorder`, `.complete()`. 전체 member_ids는 provenance.json에 있다.

### 1. 루틴 입력과 저장 검증

전체 노드: **67개** · 응집도: **0.056536**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Features/Library/RoutineSnapshot.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Models/HanjuSchemaV1.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/RoutinePersistenceTests.swift`.

구성 예시: `ExecutionError`, `anotherRunning`, `changed`, `.errorDescription`, `futureDate`, `invalidData`, `invalidMinutes`, `Field`, `expectedMinutes`, `firstAction`. 전체 member_ids는 provenance.json에 있다.

### 2. 계획 명령과 회차 이전

전체 노드: **65개** · 응집도: **0.088462**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `HanjuTests/WeekPlanTests.swift`.

구성 예시: `.save()`, `PlanDraft`, `.validate()`, `ModelContext.fetch`, `PlanWriter`, `.check()`, `.commit()`, `.confirm()`, `.fetch()`, `.find()`. 전체 member_ids는 provenance.json에 있다.

### 3. 루틴 편집과 목록 상태

전체 노드: **60개** · 응집도: **0.052542**.

출처: `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Library/RoutineEditorSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineSnapshot.swift`.

구성 예시: `SwiftUI DismissAction.callAsFunction`, `PendingAction`, `archive`, `dismiss`, `RecoveryAction`, `archive`, `save`, `RoutineEditorSheet`, `.archive()`, `.body`. 전체 member_ids는 provenance.json에 있다.

### 4. 닫기 시도와 UIKit 위임

전체 노드: **39개** · 응집도: **0.080972**.

출처: `Hanju/Features/Library/UnsavedChangesGuard.swift`.

구성 예시: `Any`, `Context`, `Coordinator`, `.attach()`, `.detach()`, `.forwardingTarget()`, `.presentationControllerDidAttemptToDismiss()`, `.presentationControllerDidDismiss()`, `.presentationControllerShouldDismiss()`, `.presentationControllerWillDismiss()`. 전체 member_ids는 provenance.json에 있다.

### 5. 커밋 훅과 리베이스 검증

전체 노드: **33개** · 응집도: **0.136364**.

출처: `.githooks/commit-msg`, `.github/scripts/test_commit_msg.py`.

구성 예시: `commit-msg`, `Validate project commit conventions without third-party dependencies.`, `rebase 원래 브랜치 검증`, `reject()`, `test_commit_msg.py`, `CommitMessageHookTests`, `.assert_rejected()`, `.commit()`, `.conflicting_history()`, `.git()`. 전체 member_ids는 provenance.json에 있다.

### 6. V3 V4 모델 이전

전체 노드: **33개** · 응집도: **0.083333**.

출처: `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `Hanju/Models/HanjuSchemaV4.swift`.

구성 예시: `HanjuMigrationPlan`, `.schemas`, `.stages`, `ExecutionInterval`, `.init()`, `ExecutionRecord`, `.init()`, `HanjuSchemaV3`, `.models`, `.versionIdentifier`. 전체 member_ids는 provenance.json에 있다.

### 7. 기록 집계와 실패 검증

전체 노드: **32개** · 응집도: **0.133065**.

출처: `HanjuTests/ExecutionTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

구성 예시: `Error`, `Failure`, `disk`, `Failure`, `disk`, `RecordsTests`, `.fixture()`, `.read()`, `.records()`, `.sample()`. 전체 member_ids는 provenance.json에 있다.

### 8. 주별 메모와 재시도 검증

전체 노드: **29개** · 응집도: **0.206897**.

출처: `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`.

구성 예시: `.memoBinding`, `Draft`, `.isDirty`, `주입 메모 읽기 호출`, `Bool`, `LocalDate`, `String`, `Void`, `취소 가능한 메모 저장 예약`, `WeeklyMemoCoordinator`. 전체 member_ids는 provenance.json에 있다.

### 9. 네이티브 파일과 프로젝트 연결

전체 노드: **28개** · 응집도: **0.134921**.

출처: `Hanju.xcodeproj/project.pbxproj`, `Hanju/App/AppTabs.swift`, `Hanju/App/HanjuApp.swift`, `Hanju/Design/DesignTokens.swift`, `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `Hanju/Features/Library/LibraryView.swift`, `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Features/Library/RoutineEditorSheet.swift`, `Hanju/Features/Library/RoutineFieldError.swift`, `Hanju/Features/Library/RoutineListView.swift`, `Hanju/Features/Library/RoutineRow.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `Hanju/Features/Library/UnsavedChangesGuard.swift`, `Hanju/Features/Today/TodayView.swift`, `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/HanjuSchemaV1.swift`, `Hanju/Models/RoutineTemplate.swift`.

구성 예시: `CGFloat`, `AppTabs.swift`, `HanjuApp.swift`, `앱 수명 실행 환경 주입`, `DesignTokens.swift`, `DesignTokens`, `CompletionSheet.swift`, `수행일과 선택 시간 편집`, `RunningRoutineView.swift`, `LibraryView.swift`. 전체 member_ids는 provenance.json에 있다.

### 10. 실행 원본과 복구 계약

전체 노드: **28개** · 응집도: **0.089947**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Execution/ExecutionSnapshot.swift`, `Hanju/Features/Execution/ExecutionWriter.swift`, `Hanju/Features/Records/RecordsSnapshot.swift`, `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/PlanDraft.swift`, `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV3.swift`, `HanjuTests/ExecutionTests.swift`, `HanjuTests/WeekPlanTests.swift`, `docs/adr/0002-execution-time-and-recovery.md`, `docs/development/data-contracts.md`.

구성 예시: `Darwin`, `실행 시계와 복구 결정`, `V3 실행 저장 계약`, `Foundation`, `ExecutionClock.swift`, `재실행 시계 비교 한계`, `수면 포함 실행 시계`, `ExecutionSnapshot.swift`, `미기록과 불확실 시간 구분`, `ExecutionWriter.swift`. 전체 member_ids는 provenance.json에 있다.

### 11. 제품 방향과 시각 기반

전체 노드: **28개** · 응집도: **0.137566**.

출처: `DEVELOPMENT_HANDOFF.md`, `README.md`, `design/01-direction.md`, `design/02-foundations.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `design/contrast-report.json`, `design/preview/index.html`, `design/reference/user-design-brief.txt`, `design/tokens.json`, `docs/adr/0001-native-ios-foundation.md`, `docs/development/local-development.md`, `docs/product-plan.md`.

구성 예시: `정돈한 생활의 페이지`, `01-direction.md`, `차분한 숲빛 강조색`, `처음부터 접근성 지원`, `의미 있는 대비 기준`, `02-foundations.md`, `한국어 시스템 서체`, `기획 1.2 프리뷰 경계`, `05-swiftui-handoff.md`, `저장 날짜의 자동변경 금지`. 전체 member_ids는 provenance.json에 있다.

### 12. 제품 범위와 기록 정책

전체 노드: **28개** · 응집도: **0.129630**.

출처: `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/development/data-contracts.md`, `docs/product-plan.md`.

구성 예시: `WeekMemo 입력`, `Records 행동 우선 기록`, `Settings 설정 화면`, `초안 보존과 저장 결과`, `캘린더 연결과 쓰기 직렬화`, `주 이동별 캘린더 조정`, `AC-05 직접 완료와 수행일 정정`, `AC-06 알림`, `AC-07 주별 캘린더 연결`, `AC-08 캘린더 중단과 외부 수정`. 전체 member_ids는 provenance.json에 있다.

### 13. 주간 선택과 초안 상태

전체 노드: **28개** · 응집도: **0.124339**.

출처: `Hanju/Features/Week/WeeklySelectionSheet.swift`.

구성 예시: `DayWorkload`, `.label()`, `SwiftUI DismissAction.callAsFunction`, `Binding`, `Bool`, `Error`, `LocalDate`, `String`, `UUID`, `Void`. 전체 member_ids는 provenance.json에 있다.

### 14. 기록 저장과 디스크 이전

전체 노드: **26개** · 응집도: **0.147692**.

출처: `Hanju/Features/Records/RecordsStore.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/RecordsMigrationTests.swift`.

구성 예시: `ModelContext.fetch 사용`, `RecordsStore`, `.fetch()`, `.fetchMemo()`, `.isolatedContext()`, `.memo()`, `.saveMemo()`, `주입 저장 또는 context 저장`, `ExecutionClock`, `LocalDate`. 전체 member_ids는 provenance.json에 있다.

### 15. 기록 제목과 화면 상태

전체 노드: **25개** · 응집도: **0.126667**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Week/OccurrenceSnapshot.swift`.

구성 예시: `Binding`, `Bool`, `ExecutionSnapshot`, `.latestAllowedDay`, `.now()`, `기록 제목 아래 여백`, `Focus`, `row`, `week`, `RecordsView`. 전체 member_ids는 provenance.json에 있다.

### 16. 화면 계약과 실행 탐색

전체 노드: **25개** · 응집도: **0.123333**.

출처: `design/03-components.md`, `design/04-screens.md`, `design/05-swiftui-handoff.md`, `docs/product-plan.md`.

구성 예시: `ActiveRoutinePanel`, `CalendarSyncState`, `03-components.md`, `WeekDaySelector`, `CalendarSheet 주별 연결`, `Routine Editor 편집 시트`, `ExecutionRecord`, `명시적 날짜 열기의 Week 목록 복귀`, `04-screens.md`, `Routine Library 루틴함`. 전체 member_ids는 provenance.json에 있다.

### 17. 이번 주 실행과 복귀

전체 노드: **25개** · 응집도: **0.180000**.

출처: `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Editor`, `RunningRoute`, `Focus`, `LocalDate`, `OccurrenceSnapshot`, `String`, `UUID`, `Void`, `WeekRequest`, `.init()`. 전체 member_ids는 provenance.json에 있다.

### 18. 개발 협업과 리뷰 규칙

전체 노드: **22개** · 응집도: **0.151515**.

출처: `.github/ISSUE_TEMPLATE/bug.md`, `.github/ISSUE_TEMPLATE/task.md`, `.github/copilot-instructions.md`, `.github/pull_request_template.md`, `AGENTS.md`, `CONTRIBUTING.md`, `docs/development/graphify.md`, `docs/development/review-workflow.md`, `docs/product-plan.md`.

구성 예시: `에이전트 파일 소유권`, `모든 PR 최신 Copilot 확인`, `AGENTS.md`, `중요 기술 결정 ADR`, `CONTRIBUTING.md`, `이슈 연결 Git 규칙`, `독립 리뷰와 Copilot 대기`, `이슈부터 시작`, `graphify.md`, `현재 AI 의미 추출과 라벨`. 전체 member_ids는 provenance.json에 있다.

### 19. 지역 날짜와 주 경계

전체 노드: **22개** · 응집도: **0.134199**.

출처: `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Week/PlanDateFields.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `Hanju/Models/LocalDate.swift`, `HanjuTests/WeekPlanTests.swift`.

구성 예시: `Calendar`, `Comparable`, `.nextWeek`, `.body`, `.lastDay`, `.previousMemo`, `LocalDate`, `.adding()`, `.calendar()`, `LocalDate.init(year:month:day:)`. 전체 member_ids는 provenance.json에 있다.

### 20. 복귀 계획과 후속 연동

전체 노드: **21개** · 응집도: **0.133333**.

출처: `design/03-components.md`, `design/05-swiftui-handoff.md`, `docs/development/data-contracts.md`, `docs/development/implementation-plan.md`, `docs/development/planning-revision-1.3.md`, `docs/product-plan.md`.

구성 예시: `CompletionSheet 수행일 편집`, `ReplanEntry 복귀 진입`, `RestWeekAction 쉬기 확인`, `실제 공유 UI 추출`, `기능별 폴더 구조`, `캘린더 중단 후 복구 계약`, `LocalDate와 DST 해석`, `data-contracts.md`, `V4 기록과 후속 연동 계약`, `알림 예약과 종료 중 한계`. 전체 member_ids는 provenance.json에 있다.

### 21. 메모 재시도와 기록 계약

전체 노드: **21개** · 응집도: **0.119048**.

출처: `Hanju/Features/Records/RecordsStore.swift`, `Hanju/Features/Records/RecordsView.swift`, `Hanju/Features/Records/WeeklyMemoCoordinator.swift`, `Hanju/Features/Week/WeeklySelectionSheet.swift`, `HanjuTests/WeeklyMemoCoordinatorTests.swift`, `HanjuUITests/RecordsUITests.swift`.

구성 예시: `RecordsStore.swift`, `확정 시간 합계와 불확실 구분`, `주별 메모 원문 원자 저장`, `수행일별 완료와 실천 횟수`, `RecordsView.swift`, `행동 우선 기록 장부`, `메모 저장과 계획 호출 복귀`, `메모 재시도와 버튼 문구`, `WeeklyMemoCoordinator.swift`, `입력 세대 확인과 동기 저장`. 전체 member_ids는 provenance.json에 있다.

### 22. 행 탭과 주 탐색 검증

전체 노드: **20개** · 응집도: **0.215789**.

출처: `Hanju/Features/Records/RecordsView.swift`, `HanjuUITests/RecordsUITests.swift`.

구성 예시: `Date`, `완료 기록 전체 행 탭`, `RecordsUITests.swift`, `완료 행 빈 공간 검증`, `입력과 주별 보존 검증`, `RecordsUITests`, `.application()`, `.completedRow()`, `.createTodayPlan()`, `.pickDate()`. 전체 member_ids는 provenance.json에 있다.

### 23. 모델 파일과 회귀 연결

전체 노드: **20개** · 응집도: **0.152632**.

출처: `Hanju/Models/HanjuSchemaV2.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `HanjuTests/ExecutionMigrationTests.swift`, `HanjuTests/RecordsMigrationTests.swift`, `HanjuTests/RecordsTests.swift`, `HanjuTests/RoutineLibraryTests.swift`, `HanjuTests/SchemaMigrationTests.swift`, `HanjuTests/WeekPlanTests.swift`, `HanjuUITests/RoutineLibraryUITests.swift`, `HanjuUITests/WeekPlanUITests.swift`.

구성 예시: `Hanju`, `HanjuSchemaV2.swift`, `동결 모델과 V4 이전`, `주별 메모 원문 저장`, `ExecutionMigrationTests.swift`, `V2 이전과 복구 영속 검증`, `RecordsMigrationTests.swift`, `실제 디스크 V4 이전 검증`, `RecordsTests.swift`, `기록 집계와 원자 저장 검증`. 전체 member_ids는 provenance.json에 있다.

### 24. 계획 조정과 시트 동작

전체 노드: **20개** · 응집도: **0.136842**.

출처: `Hanju/Features/Week/PlanAdjustmentSheet.swift`.

구성 예시: `SwiftUI DismissAction.callAsFunction`, `Mode`, `move`, `recovery`, `rest`, `PlanAdjustmentSheet`, `.body`, `.canSave`, `.dirty`, `.init()`. 전체 member_ids는 provenance.json에 있다.

### 25. 실행 탐색 화면 검증

전체 노드: **20개** · 응집도: **0.263158**.

출처: `HanjuUITests/ExecutionUITests.swift`.

구성 예시: `ExecutionUITests`, `.cancel()`, `.createTodayPlans()`, `.pickDate()`, `.reveal()`, `.testDirectCompletionEditCancellationZeroTimeAndUndo()`, `.testExplicitWeekAgendaOpensMovedDateAndSameDayWithoutStoppingRunning()`, `.testPastWeekPausedResumeConfirmsSwitchAndReturnsToSamePlan()`, `.testPriorWeekDirectCompletionAndPerformedDateCorrectionKeepPlanInPlace()`, `.testRecoveryFromRunningWeekKeepsDetailOnCancelAndOpensAgendaOnSave()`. 전체 member_ids는 provenance.json에 있다.

### 26. 루틴 편집 화면 검증

전체 노드: **18개** · 응집도: **0.372549**.

출처: `HanjuUITests/RoutineLibraryUITests.swift`.

구성 예시: `RoutineLibraryUITests`, `.enter()`, `.finishInput()`, `.openEditor()`, `.openLibrary()`, `.reveal()`, `.routineRow()`, `.swipeEditor()`, `.testCategoryChangeRemainsVisibleAndRevertedEditSwipesCleanly()`, `.testDirtySwipeKeepsInputThenDiscardsAndCleanSwipeDismisses()`. 전체 member_ids는 provenance.json에 있다.

### 27. 구현 인계와 네이티브 CI

전체 노드: **17개** · 응집도: **0.139706**.

출처: `.github/workflows/ios.yml`, `DEVELOPMENT_HANDOFF.md`, `Hanju.xcodeproj/xcshareddata/xcschemes/Hanju.xcscheme`, `Hanju/Features/Library/RoutineSnapshot.swift`, `Hanju/Features/Library/RoutineWriter.swift`, `HanjuTests/RoutinePersistenceTests.swift`, `docs/development/implementation-plan.md`, `docs/development/local-development.md`, `docs/verification/2026-10-04-foundation.md`.

구성 예시: `실행과 주간 기록 구현 인계`, `변경 초안 swipe 확인 구현`, `implementation-plan.md`, `주간 기록 구현과 후속 경계`, `기록 구현 소유권과 검증`, `공유 scheme과 로컬 테스트`, `2026-10-04-foundation.md`, `기반 네이티브 검증 기록`, `ios.yml`, `iOS 빌드와 테스트 CI`. 전체 member_ids는 provenance.json에 있다.

### 28. 오늘 실행과 완료 동작

전체 노드: **17개** · 응집도: **0.308824**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Today/TodayView.swift`.

구성 예시: `.read()`, `UUID`, `RunningRoute`, `Bool`, `String`, `UUID`, `Void`, `TodayView`, `.activeActions()`, `.body`. 전체 member_ids는 provenance.json에 있다.

### 29. V4 기록과 메모 계약

전체 노드: **16개** · 응집도: **0.183333**.

출처: `Hanju/Features/Week/PlanWriter.swift`, `Hanju/Models/HanjuSchemaV4.swift`, `docs/adr/0003-weekly-records-and-memo.md`, `docs/development/data-contracts.md`.

구성 예시: `부담 없는 계획과 호출자 복귀`, `실제 첫 날짜 이동 근거`, `확정 시간과 합계 한계`, `주별 초안과 저장 세대`, `주별 메모 원문 보존`, `수행일 장부와 루틴 횟수`, `수행일별 기록과 메모 결정`, `동결 모델과 V4 이전`, `기록 기능 검증 문서 근거`, `주간 기록과 메모 저장 계약`. 전체 member_ids는 provenance.json에 있다.

### 30. 주간 집계와 조회 값

전체 노드: **15개** · 응집도: **0.190476**.

출처: `Hanju/Features/Execution/ExecutionClock.swift`, `Hanju/Features/Records/RecordsSnapshot.swift`, `Hanju/Features/Records/RecordsView.swift`.

구성 예시: `Equatable`, `RecordedTimeSummary`, `RoutineCount`, `.id`, `Bool`, `Double`, `ExecutionSnapshot`, `Int`, `LocalDate`, `Set`. 전체 member_ids는 provenance.json에 있다.

### 31. 이슈 연결과 PR 정책

전체 노드: **14개** · 응집도: **0.197802**.

출처: `.github/scripts/pr-policy.cjs`, `.github/scripts/pr-policy.test.cjs`, `.github/workflows/pr-policy.yml`.

구성 예시: `pr-policy.cjs`, `branchPattern`, `run()`, `pr-policy.test.cjs`, `assert`, `fixture()`, `{ test }`, `{ validate }`, `titlePattern`, `validate()`. 전체 member_ids는 provenance.json에 있다.

### 32. 회차 상태와 화면 값

전체 노드: **14개** · 응집도: **0.142857**.

출처: `Hanju/Features/Today/TodayView.swift`, `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Editor`, `completion`, `.id`, `move`, `OccurrenceSnapshot`, `.canReplan`, `.isUnfinished`, `.statusLabel`, `Bool`, `Date`. 전체 member_ids는 provenance.json에 있다.

### 33. V1 디스크 이전 검증

전체 노드: **14개** · 응집도: **0.241758**.

출처: `Hanju/Models/HanjuSchemaV1.swift`, `HanjuTests/SchemaMigrationTests.swift`.

구성 예시: `HanjuSchemaV1`, `.models`, `.versionIdentifier`, `PersistentModel`, `Schema`, `SchemaMigrationTests`, `.migrateAndAddPlan()`, `.testRealV1DiskStoreMigratesToV3AndReopensWithAllRoutineValues()`, `.verifyRoutine()`, `.writeV1Fixture()`. 전체 member_ids는 provenance.json에 있다.

### 34. 주간 계획 화면 검증

전체 노드: **14개** · 응집도: **0.340659**.

출처: `HanjuUITests/WeekPlanUITests.swift`.

구성 예시: `Bool`, `Date`, `String`, `XCUIApplication`, `XCUIElement`, `WeekPlanUITests`, `.choose()`, `.createRoutine()`, `.pickDate()`, `.reveal()`. 전체 member_ids는 provenance.json에 있다.

### 35. 날짜 입력과 닫기 동작

전체 노드: **13개** · 응집도: **0.153846**.

출처: `Hanju/Features/Week/PlanDateFields.swift`.

구성 예시: `ClosedRange`, `Content`, `PlanDateFields`, `.dateBinding`, `.hasTime`, `.timeBinding`, `PlanDismissal`, `.body()`, `Binding`, `Bool`. 전체 member_ids는 provenance.json에 있다.

### 36. 실행 재개와 호출 복귀

전체 노드: **13개** · 응집도: **0.179487**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`, `Hanju/Features/Execution/ExecutionRecorder.swift`, `Hanju/Features/Execution/RunningRoutineView.swift`, `Hanju/Features/Today/TodayView.swift`, `Hanju/Features/Week/PlanAdjustmentSheet.swift`, `Hanju/Features/Week/WeekView.swift`, `Hanju/Persistence/PersistenceStore.swift`, `HanjuUITests/ExecutionUITests.swift`, `design/04-screens.md`.

구성 예시: `지난 작업 재개 계약`, `원본 수행일의 선택 범위`, `ExecutionRecorder.swift`, `앱 수명 실행 명령`, `실행 제어와 시간 표시`, `오늘 실행과 수행일 완료`, `이동 초안과 중립 건너뛰기`, `지난주 재개와 호출 복귀`, `PersistenceStore.swift`, `V4 저장소와 실행 수명`. 전체 member_ids는 provenance.json에 있다.

### 37. 하단 탭과 루틴 진입

전체 노드: **13개** · 응집도: **0.166667**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Library/LibraryView.swift`.

구성 예시: `AppTabs`, `.body`, `Tab`, `library`, `records`, `settings`, `today`, `week`, `Destination`, `archive`. 전체 member_ids는 provenance.json에 있다.

### 38. 앱 수명과 저장소 구성

전체 노드: **12개** · 응집도: **0.212121**.

출처: `Hanju/App/HanjuApp.swift`, `Hanju/Persistence/PersistenceStore.swift`.

구성 예시: `App`, `ExecutionRecorder`, `HanjuApp`, `.body`, `PersistenceStore`, `.makeContainer()`, `.open()`, `Bool`, `ModelContainer`, `String`. 전체 member_ids는 provenance.json에 있다.

### 39. 완료 기록과 수행일 편집

전체 노드: **12개** · 응집도: **0.196970**.

출처: `Hanju/Features/Execution/CompletionSheet.swift`.

구성 예시: `CompletionSheet`, `.body`, `.dateBinding`, `.dirty`, `.init()`, `.save()`, `.undo()`, `SwiftUI DismissAction.callAsFunction`, `Binding`, `Bool`. 전체 member_ids는 provenance.json에 있다.

### 40. 현지 시각과 해석 값

전체 노드: **11개** · 응집도: **0.218182**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`, `Hanju/Models/LocalDate.swift`.

구성 예시: `Codable`, `.init()`, `LocalTime`, `LocalTime.init(hour:minute:)`, `.init()`, `.label`, `.minutes`, `Resolution`, `Date`, `Int`. 전체 member_ids는 provenance.json에 있다.

### 41. 명시 목록과 타이머 보존

전체 노드: **11개** · 응집도: **0.200000**.

출처: `Hanju/App/AppTabs.swift`, `Hanju/Features/Week/WeekView.swift`, `HanjuUITests/ExecutionUITests.swift`, `HanjuUITests/WeekPlanUITests.swift`.

구성 예시: `탭 탐색과 실행 연결`, `같은 날짜의 명시 agenda 요청`, `WeekView.swift`, `명시 agenda 목록과 타이머 보존`, `주간 계획과 늦은 완료`, `현재 미완료와 쉬기 안내`, `성공 날짜 목록과 취소 상세 보존`, `명시 목록 전환 회귀 정의`, `WeekPlanUITests.swift`, `실제 native switch 선택`. 전체 member_ids는 provenance.json에 있다.

### 42. 계획 오류와 입력 제한

전체 노드: **10개** · 응집도: **0.200000**.

출처: `Hanju/Features/Week/PlanDraft.swift`.

구성 예시: `PlanError`, `batchLimit`, `changedOccurrence`, `.errorDescription`, `inactiveRoutine`, `invalidDate`, `invalidDraft`, `invalidStoredData`, `missingOccurrence`, `runningNeedsRecorder`. 전체 member_ids는 provenance.json에 있다.

### 43. 실행 강조와 색상 에셋

전체 노드: **8개** · 응집도: **0.250000**.

출처: `Hanju/Assets.xcassets/AccentColor.colorset/Contents.json`, `Hanju/Assets.xcassets/AccentSubtle.colorset/Contents.json`, `Hanju/Assets.xcassets/Background.colorset/Contents.json`, `Hanju/Assets.xcassets/OnAccent.colorset/Contents.json`, `Hanju/Assets.xcassets/Surface.colorset/Contents.json`, `Hanju/Assets.xcassets/TextPrimary.colorset/Contents.json`, `Hanju/Assets.xcassets/TextSecondary.colorset/Contents.json`, `Hanju/Design/DesignTokens.swift`.

구성 예시: `실행 패널의 연한 강조색`, `강조 버튼의 전경 색상`, `AccentColor.colorset/Contents.json`, `Background.colorset/Contents.json`, `Surface.colorset/Contents.json`, `TextPrimary.colorset/Contents.json`, `TextSecondary.colorset/Contents.json`, `실행 강조와 대비 색상`. 전체 member_ids는 provenance.json에 있다.

### 44. 명시 요청과 조정 종류

전체 노드: **8개** · 응집도: **0.250000**.

출처: `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Kind`, `adjustment`, `agenda`, `completion`, `plan`, `recovery`, `ExecutionSnapshot`, `PlanAdjustmentSheet`. 전체 member_ids는 provenance.json에 있다.

### 45. 계획 초안과 횟수 배분

전체 노드: **7개** · 응집도: **0.619048**.

출처: `Hanju/Features/Week/PlanDraft.swift`.

구성 예시: `Entry`, `.init()`, `.allocate()`, `.validateCounts()`, `Int`, `String`, `UUID`. 전체 member_ids는 provenance.json에 있다.

### 46. 메모 저장 상태 표현

전체 노드: **6개** · 응집도: **0.333333**.

출처: `Hanju/Features/Records/WeeklyMemoCoordinator.swift`.

구성 예시: `Status`, `failed`, `idle`, `pending`, `saved`, `saving`. 전체 member_ids는 provenance.json에 있다.

### 47. 계획 회차 상태 표현

전체 노드: **6개** · 응집도: **0.333333**.

출처: `Hanju/Features/Week/OccurrenceSnapshot.swift`.

구성 예시: `Status`, `completed`, `paused`, `planned`, `running`, `skipped`. 전체 member_ids는 provenance.json에 있다.

### 48. 선호 요일과 날짜 계약

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Library/RoutineDraft.swift`, `Hanju/Models/LocalDate.swift`, `docs/development/data-contracts.md`.

구성 예시: `월요일 기준 선호 요일 계약`, `선택 입력과 선호 요일 검증`, `LocalDate.swift`, `시간대 독립 계획 날짜`, `현지 시각과 DST 설명`. 전체 member_ids는 provenance.json에 있다.

### 49. 주간 화면 접근성 초점

전체 노드: **5개** · 응집도: **0.400000**.

출처: `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Focus`, `day`, `plan`, `rest`, `row`. 전체 member_ids는 provenance.json에 있다.

### 50. 기록과 오늘 호출자

전체 노드: **3개** · 응집도: **0.666667**.

출처: `Hanju/Features/Week/WeekView.swift`.

구성 예시: `Caller`, `records`, `today`. 전체 member_ids는 provenance.json에 있다.

### 51. 에셋 카탈로그 메타데이터

전체 노드: **1개** · 응집도: **1.000000**.

출처: `Hanju/Assets.xcassets/Contents.json`.

구성 예시: `Assets.xcassets/Contents.json`. 전체 member_ids는 provenance.json에 있다.

## 건강 상태와 해석 한계

- 94개 main 추적 입력 중 93개는 SHA256이 동일하며 RecordsView.swift 한 파일만 변경됐다. 완전한 원시 캐시의 불변 관계 2901개와 출처 소유 노드를 전체 payload·방향 그대로 보존했다. 오래된 native manifest 또는 단순 graph export로 원시 캐시를 복원하지 않았다.
- 변경 파일 AST 31개 노드 occurrence/72개 관계를 불변 문맥과 함께 재추출했다. 타입 사용 stub 6개의 ID 정규화와 관련 15개 관계의 모든 전후 payload·원문 앵커를 대응했다. L24 qualified outer type 참조 1개가 사용 stub로 방출된 것은 유일한 WeeklyMemoCoordinator 선언으로 명시 정규화했다. fresh 원본 node/edge와 유일한 선언 앵커·대응 관계를 별도로 보존했다. receiver 호출 교정과 다르며 내부 Draft의 전체 타입 해석을 주장하지 않는다.
- L164 memos.load 호출의 동명 self-load 오인을 원문 receiver에 맞게 다시 교정했다. 교정 전 전체 payload를 extraction_before_correction에 보존했다. 불변 receiver 교정 58개와 export 교정 2개도 그대로 유지한다. 정적 AST의 동명·closure·중첩 타입/함수 및 producer 내부 중복 억제 한계가 남는다.
- 무방향 연결은 여러 관계와 방향을 합친다. 각 link.evidence에 원시 2983개 관계의 모든 필드를 보존했고 순서 없는 endpoint 쌍별 Counter로 검증했다. 탐색 시 단일 link 속성 대신 evidence를 읽어야 한다.
- 에셋 카탈로그 루트 Contents.json 1개는 고립 상태로 보존한다. 모든 파일 hub·AST 멤버·외부 타입을 커뮤니티 전체 노드 수에 포함하며 낮은 응집도를 숨기지 않는다.
- #37 공통 기록 제목은 아래쪽 기존 token/2 여백만 유지한다. 불투명 배경과 네이티브 List/Section, 다중행 Text 구조를 유지하며 별도 스크롤 상태·offset·고정 높이를 추가하지 않았다. 그래프는 실제 시각 간격·VoiceOver·스크롤 동작의 실행 검증을 대신하지 않는다.
- 이 작업은 앱 테스트·원격 CI를 새로 실행하거나 재확인하지 않았다. 테스트와 CI 노드는 현재 소스 정의이며 제품 PR40의 검증 결과를 새 실행으로 주장하지 않는다. 알림 #11·캘린더 #12·실기기/iOS17/전체 인수 #13은 후속이다. 전체 MVP 또는 AC13 완료를 뜻하지 않는다.
- 실제 모델명·토큰 사용량·비용은 확인할 수 없어 null이다. 현재 Codex 세션이 의미 추출과 커뮤니티 라벨을 작성했으며 외부 LLM API를 사용하지 않았다. 이것은 비용 0을 뜻하지 않는다.
- 공유 import/type hub의 기존 불변 파일 소유 metadata 보존 및 빈 stub 출처의 실제 사용 앵커 보완을 ast_node_reconciliation에 fresh/current 전체 node payload로 기록했다. 각 import/reference 관계의 출처와 방향은 그대로 보존한다.

## 사용 기록

현재 Codex 세션에서 의미 추출·한국어 라벨 작성. 모델명·입출력 토큰·비용은 알 수 없음(null). 외부 LLM API 없음. 이번 그래프 작업에서 네이티브 테스트·원격 CI를 실행하지 않았다.
