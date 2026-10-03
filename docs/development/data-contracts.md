# 기능 간 데이터 계약

이슈 #4 · 기획 원본: `docs/product-plan.md`, 화면 상태 원본: `design/04-screens.md`.
아래는 구현 순서를 정하는 계약이며 모두 구현됐다는 의미가 아니다. 각 기능 PR에서 모델을 추가하고 저장/이전 테스트를 함께 만든다.

| 개념 | 소유 데이터와 불변 조건 | 구현 순서 |
| --- | --- | --- |
| RoutineTemplate | 안정적인 UUID, 이름, 분류, 선택적 예상분·횟수·선호요일·메모·시작행동, 보관 여부. 루틴 수정·보관은 과거 snapshot을 바꾸지 않는다 | 기반 → 루틴 편집 |
| WeekPlan | 월요일 시작 LocalDate, 명시적 확정의 대상 주. 주를 시작해도 자동 이월하지 않는다 | 계획 |
| PlannedOccurrence | 고유 UUID, week/routine 참조, 해당 회차 이름·예상분 snapshot, 계획 LocalDate·선택적 local time, planned/running/paused/completed/skipped | 계획 → 실행 |
| ExecutionRecord | occurrence 참조, 실제 interval의 Date instant들, 선택적 실제 duration, 완료 instant와 당시 local date. nil은 미기록, 0과 다르다 | 실행 |
| WeeklyMemo | 월요일 시작 local date로 주 식별, 자유 본문. 공란 허용, 저장 실패 시 원문 보존 | 기록 |
| CalendarLink | occurrence UUID, event 식별자·캘린더·마지막 내보낸 내용과 상태. 외부 변경 감지 뒤 명시적 선택, 중복 재시도 방지 | 캘린더 |

LocalDate는 Gregorian year/month/day로 표현한다. 계획을 자정 Date instant로 영속화하지 않는다. 주 계산은 월요일 기준이다. 생활 시각을 Date로 해석할 때 Calendar와 TimeZone을 명시하고 DST 결과를 표시한다. 실제 interval instant와 완료 당시 local date는 시간대 변경 후 다시 쓰지 않는다.

화면이 draft를 소유하고 명령 계층이 저장을 확정한다. 공용 저장소가 동시에 수행하는 명령을 직렬화한다. 저장 성공 뒤 알림·캘린더 부수 작업을 요청한다. OS 작업 실패는 pending/retry이며 앱 저장을 되돌리지 않는다. 모델 ID와 명령 ID는 렌더링마다 만들지 않는다.

주간 확정은 draft에서 생성한 안정적인 occurrence ID를 재사용한다. 실행 서비스는 화면과 독립적인 앱 수명이며 동시에 running 하나를 보장한다. 계산은 실제 timestamp를 사용하고 UI tick은 표시 용도다. 캘린더 작업은 event 저장과 앱 연결 저장 사이의 중단도 다루는 재시도 계약을 기능 구현 전에 확정한다.

공용 모델·저장소·프로젝트 파일은 기반 담당이 단독 소유한다. 기능 담당은 이를 임의 확장하지 않고 필요한 변경을 개발총괄에게 전달한다. 프로토콜은 실제 OS 경계와 테스트 대역이 필요한 곳에만 도입한다.

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
