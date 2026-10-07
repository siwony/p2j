# 기능 간 데이터 계약

이슈 #4 / 개정 #18 · 기획 1.3 원본: `docs/product-plan.md`, 화면 상태 원본: `design/04-screens.md`. Delta/owners: `docs/development/planning-revision-1.3.md`.
아래는 구현 순서를 정하는 계약이며 모두 구현됐다는 의미가 아니다. 각 기능 PR에서 모델을 추가하고 저장/이전 테스트를 함께 만든다.

| 개념 | 소유 데이터와 불변 조건 | 구현 순서 |
| --- | --- | --- |
| RoutineTemplate | 안정적인 UUID, 이름, 분류, 선택적 예상분·횟수·선호요일·메모·시작행동, 보관 여부. 루틴 수정·보관은 과거 snapshot을 바꾸지 않는다 | 기반 → 루틴 편집 |
| WeekPlan | Monday LocalDate; explicit confirmed week; per-week calendar intent + destination. New/copied week connection off; no auto carryover | 계획 |
| PlannedOccurrence | 고유 UUID, week/routine 참조, 해당 회차 이름·예상분 snapshot, 계획 LocalDate·선택적 local time, planned/running/paused/completed/skipped | 계획 → 실행 |
| ExecutionRecord | occurrence ref; interval instants; optional duration; `completedAt` + `completionLocalDate` capture completion entry; editable `performedOn` defaults to that date. nil ≠ 0 | 실행 |
| WeeklyMemo | 월요일 시작 local date로 주 식별, 자유 본문. 공란 허용, 저장 실패 시 원문 보존 | 기록 |
| CalendarLink | occurrence UUID, event 식별자·캘린더·마지막 내보낸 내용과 상태. 외부 변경 감지 뒤 명시적 선택, 중복 재시도 방지 | 캘린더 |

LocalDate는 Gregorian year/month/day로 표현한다. 계획을 자정 Date instant로 영속화하지 않는다. 주 계산은 월요일 기준이다. 생활 시각을 Date로 해석할 때 Calendar와 TimeZone을 명시하고 DST 결과를 표시한다. 실제 interval instant·완료 입력 당시 날짜·수행일은 시간대 변경으로 다시 쓰지 않는다. `performedOn`만 사용자의 명시적 정정으로 변경한다.

RoutineTemplate의 `preferredWeekdays`는 월요일 1~일요일 7이며 중복 없이 저장한다(#7). Foundation `Calendar`의 weekday 값은 일요일부터 시작하므로 #8의 실제 날짜 배치에서 명시적으로 변환한다. 선택하지 않은 예상분·횟수는 nil이며 입력한 값은 양의 정수다. 이름을 제외한 입력은 선택 사항이다.

화면이 draft를 소유하고 명령 계층이 저장을 확정한다. 공용 저장소가 동시에 수행하는 명령을 직렬화한다. 저장 성공 뒤 알림·캘린더 부수 작업을 요청한다. OS 작업 실패는 pending/retry이며 앱 저장을 되돌리지 않는다. 모델 ID와 명령 ID는 렌더링마다 만들지 않는다.

주간 확정은 draft에서 생성한 안정적인 occurrence ID를 재사용한다. #8의 신규 회차 저장은 한 명령당 총 100회까지 처리한다. 배열을 생성하기 전에 합계·범위를 검증하며 초과 입력은 보존하고 나누어 추가하도록 안내한다. 이는 메모리 보호를 위한 명령 단위 제한이며 루틴의 기본 주간 횟수나 한 주 전체 회차 수를 제한하지 않는다. 실행 서비스는 화면과 독립적인 앱 수명이며 동시에 running 하나를 보장한다. 경과 시간은 저장한 실행 구간과 단조 시계 샘플로 계산하며 UI tick은 표시 용도다. 캘린더 작업은 event 저장과 앱 연결 저장 사이의 중단도 다루는 재시도 계약을 기능 구현 전에 확정한다.

공용 모델·저장소·프로젝트 파일은 기반 담당이 단독 소유한다. 기능 담당은 이를 임의 확장하지 않고 필요한 변경을 개발총괄에게 전달한다. 프로토콜은 실제 OS 경계와 테스트 대역이 필요한 곳에만 도입한다.

## 기획 1.3 명령·집계 계약

- RestWeek: current week; confirmed stable ID set with planned/running/paused only. Atomically close target active interval + mark skipped. Failure preserves all state + running. Completed/prior skipped/other weeks untouched; keep snapshots/intervals. Idempotent command; no persistent ban on later additions. Restore selected skipped occurrence under same ID → planned, or paused if prior intervals exist.
- Replan: current-week past planned/paused; no default selection. Reuse ID + intervals; change selected date only. Current-week remaining days by default. Skip/completed/prior weeks excluded. Prior-week import remains explicit new occurrence creation.
- Late completion: Week past-date/prior-week planned/paused action completes same occurrence; no move/copy. Preserve measured intervals/time; nil only without history. Undo removes aggregation + clears active completedAt/completionLocalDate/performedOn, retaining intervals/time. Recomplete captures new instant/local date and defaults performedOn to that date; no stale completed-date reuse. Atomic save; failure preserves prior state.
- Performed date: `performedOn` groups completed rows/counts/known durations; date edits cannot exceed current local today. Keep `completedAt`, `completionLocalDate`, intervals, duration, planned date. Save edits atomically; failure preserves draft + old aggregation. Refresh source/target week; memo stays. No new occurrence/completion or calendar update. Nil/zero/subminute retain distinction.
- Calendar: WeekPlan connection intent separate from per-occurrence CalendarLink export status. Connected week additions/edits/rest/restore enqueue work after app save; off cancels/suspends queued writes, retaining links/events. New/copied week off. Before each write, recheck current intent + occurrence state/version; serialize disconnect with in-flight writes, then reconcile actual result. Never show off while a new automatic write can still start.
- Cross-week move: both on → update existing event into destination calendar/date; source only on → remove source event; destination only on → recover/reuse existing link or create if none. Source off retained event requires explicit consent before reuse/change; do not silently duplicate. Both off → no OS write. All branches preserve external changes pending user choice.
- Rest/restore/replan trigger notification replacement + active-calendar reconciliation after app commit. Cancel stale normal/group/snooze requests; keep weekly planning preference. Integration failure ≠ failed app save. No recovery-entry notification.
- Records: completed rows → counts → optional time → memo. All nil durations: no aggregate row. Otherwise sum only known duration; include unrecorded count as secondary detail. Rest/skipped excluded from completed metrics.

These contracts span #8–#12. #8 adds V2 WeekPlan/PlannedOccurrence and reuses the unchanged V1 RoutineTemplate. V1/V2 persisted definitions stay frozen after release; later model additions/changes require a new schema and disk-fixture migration checks. No application implementation in #18.

## #9 실행 저장 계약

기능 검증·병합 근거는 #9 PR과 구현 순서에서 추적한다. 결정 근거는 [ADR 0002](../adr/0002-execution-time-and-recovery.md)다.

V3는 기존 V1/V2 저장 모델을 재사용하며 occurrence별 고유 ExecutionRecord와 여러 ExecutionInterval을 추가한다. record는 완료 입력 instant·당시 LocalDate·수행일을 각각 저장하고, 선택적 수동 총초/적용 sequence와 revision을 갖는다. interval은 시작/종료 Date, 단조 시계 샘플, 프로세스 식별자, 순서, 확정 경과초를 보존한다. 프로세스 식별자는 부팅 식별자가 아니다.

ExecutionRecorder는 앱 수명의 MainActor 명령 소유자다. start/pause/complete/undo/edit는 await 없는 별도 context 명령으로 확정한다. snapshot의 revision과 회차 상태로 변경된 화면 명령을 거절한다. 조회와 UI tick은 저장하지 않는다. start 전 다른 running을 확인하고 사용자 선택 뒤 기존 pause+새 start를 원자 저장한다. 날짜/주와 관계없이 running은 최대 하나다. PlanWriter의 running 이동/쉬기/건너뛰기도 같은 context에서 구간을 닫고 한 번에 저장하며 실패하면 모두 유지한다.

시간은 Date 차이 대신 수면을 포함한 단조 시계 차이로 계산한다. cold launch는 새 프로세스 시작 샘플을 기준으로 복구 판정을 고정한다. 샘플 감소/시계 불일치는 미확정 구간으로 보존하고 ‘시간 확인 필요’를 표시한다. 전체 시간이 불확실하면 전체 duration은 nil, 확인된 부분합은 별도이며 전체 시간으로 집계하지 않는다. 측정 이력 없는 nil(시간 미기록), 확정 0, 0초 초과 1분 미만을 구별한다. 불확실성을 해결하기 위해 시간 입력을 강요하지 않는다.

수동 총시간은 manualThroughSequence까지의 원본 시간을 대체하며 이후 구간만 더한다. 구간/시각은 삭제하지 않는다. 입력 비우기는 측정 원본 또는 확인 필요로 복원한다. 수행일만 정정하면 exact seconds·수동값·적용 경계·입력 사실을 유지한다. 완료 취소/재완료도 구간·수동값은 보존한다. 종료/재부팅과 수동 시계 변경의 모든 조합을 판별할 수 있다는 보장은 없으며 실제 기기 확인은 #13에 남긴다.

## 병렬 기술 조사에서 확정한 경계

`technology_research`가 Apple 공식 문서와 설치된 SDK를 확인했다. iOS 17에서 기본 SwiftData/Observation API를 사용할 수 있으며, Swift 6 언어 모드는 deployment target과 별개다. 이후 버전의 `#Unique`, `#Index`, History API를 가정하지 않는다.

- **저장**: 최초 실사용 전에 `VersionedSchema` V1을 고정한다. 새 모델을 추가할 때 기존 V1을 수정하지 않고 새 schema와 필요한 migration을 정의한다. 이전 디스크 store fixture를 열어 ID·값 보존을 검증한다. `rollback()`은 context 전체에 영향을 주므로 서로 다른 draft의 미저장 변경을 같은 transaction에 섞지 않는다.
- **단일 실행**: `@MainActor`만으로 `await` 사이의 재진입을 막을 수 없다. 명령 진행 상태를 검사하고 기존 pause와 새 start를 동일 저장 단위로 확정한다. 실패하면 이전 상태를 유지한다.
- **DST**: 계획 시각 해석 기본은 `Calendar.MatchingPolicy.nextTime`, `RepeatedTimePolicy.first`다. 존재하지 않는 시각은 다음 유효 시각, 중복 시각은 첫 번째를 사용하고 실제 해석 결과를 사용자에게 표시한다. 날짜 이동에 86,400초 덧셈을 사용하지 않는다.
- **캘린더**: occurrence UUID·작업 UUID·export snapshot·pending을 앱에 먼저 저장하고 EventKit 저장 후 event ID와 성공 상태를 확정한다. `eventIdentifier`는 이동/동기화로 변할 수 있으므로 단독 동일성 기준으로 사용하지 않는다. `EKEvent.url`의 안정적 occurrence 표식과 기존 ID를 이용하는 복구 방안을 #12에서 실제 검증한다. 표식 소실·복수 일치·성공 여부 불명확 시 자동 새 이벤트를 만들지 않고 확인 대기로 둔다. 두 저장소 간 완전한 원자성은 보장할 수 없다.
- **외부 변경**: 마지막 export의 제목·시각·종일 여부·캘린더·알림·URL snapshot과 새로 읽은 event를 비교한다. 외부 삭제/수정은 사용자 선택 전까지 보존한다. 기존 일정 조회·갱신을 위해 명시적 사용 시 전체 접근 권한을 요청한다.
- **알림**: occurrence/날짜별 묶음/snooze에 안정적인 별도 식별자를 부여하고 기존 요청을 교체한다. 실행 알림은 개별 날짜에 예약하고 계획 알림만 주간 반복한다. 64개 이하를 보수적 예산으로 삼되 이는 현대 UN API의 확정 보장이 아니다. 가까운 일정 우선·재알림 여유·예약 대기 표시와 실제 pending 조회를 #11에서 검증한다.
- **앱 종료 중 한계**: 임의 시각의 백그라운드 실행을 전제로 하지 않는다. 실행·복귀·시간대 변경 통지 수신 때 미래 알림/캘린더를 재조정한다. 종료 중 즉시 갱신을 보장한다고 표시하지 않는다.

우선 실험은 저장소 V1→다음 버전 이전, EventKit 저장 직후 강제 중단/재시작, 실제 iPhone에서 예약 한도·권한·시간대 변경이다. 조사에서 macOS Foundation의 LA 2026-03-08 02:30→03:00과 2026-11-01 01:30의 반복 선택 간 1시간 차이를 확인했지만 iOS 실기기 인수를 대신하지 않는다.

근거: [SwiftData rollback](https://developer.apple.com/documentation/swiftdata/modelcontext/rollback()), [마이그레이션](https://developer.apple.com/documentation/swiftdata/schemamigrationplan), [Calendar 매칭](https://developer.apple.com/documentation/foundation/calendar/matchingpolicy), [EventKit 식별자](https://developer.apple.com/documentation/eventkit/ekevent/eventidentifier), [EventKit URL](https://developer.apple.com/documentation/eventkit/ekcalendaritem/url), [알림 식별자](https://developer.apple.com/documentation/usernotifications/unnotificationrequest/identifier), [기존 예약 제한 문서](https://developer.apple.com/documentation/uikit/uilocalnotification).
