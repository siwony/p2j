# ADR 0004: 로컬 알림과 저장 후 재조정

상태: 채택 · 2026-10-21 · 관련 이슈 #11, #45 · 기획 1.3

## 문제와 선택

알림은 현재 계획을 반영하되 계획·실행 저장 실패를 성공으로 표시해서는 안 된다. 재알림은 원래 회차와 날짜를 유지하고, 중복·오래된 응답이 두 번째 실행을 만들면 안 된다. OS 예약은 앱 저장과 하나의 transaction으로 묶을 수 없다.

기존 SwiftData V4와 실행 명령을 유지한다. 앱 수명의 `@MainActor` 알림 coordinator가 현재 저장 상태로 예약을 계산하며, 실제 `UNUserNotificationCenter` 경계에만 작은 adapter를 둔다. 순수 예약 계산은 OS 없이 검증한다. 서버·새 의존성·화면별 Repository 계층은 추가하지 않는다.

알림 설정·재알림 의도·예약 세대·응답 receipt는 Application Support의 **단일 버전형 JSON 파일**에 원자적으로 저장한다. 대기/재시도는 이 영속 의도와 실제 OS 조회 결과의 차이로 다시 계산한다. `UserDefaults`는 복합 변경의 쓰기 실패를 호출자에게 확인시키기 어려워 제외했다. V5는 이번에 추가하지 않는다. 알림 상태와 실행 명령을 같은 SwiftData transaction에 넣어야 하는 요구가 생기면 새 schema를 검토한다. V1–V4 영속 정의는 동결한다.

## 파일 저장과 중단

- 처음 파일이 없는 경우만 초기 상태를 만든다. 읽기 실패·손상·미지원 버전을 기본값으로 덮어쓰지 않는다. 알림 설정 오류와 재시도를 제공하고 핵심 계획·실행은 계속 사용한다.
- 파일 쓰기는 throws이며 성공 후에만 메모리 상태를 확정한다. 실패하면 이전 파일·설정·재알림을 유지하고 새 의도로 OS를 변경하지 않는다. 원본 조회 실패를 빈 계획으로 취급해 기존 예약을 전부 지우지 않는다.
- 재알림은 응답 수락 시 원래 대상 ID·계획 날짜와 `dueAt = acceptedAt + 1800`을 한 번 저장한다. 재시도마다 30분을 새로 더하지 않는다. 이미 지난 재알림은 자동으로 몰아서 발송하지 않는다.
- receipt 수락 → 기존 실행 명령 저장 → receipt 완료는 두 저장소를 거친다. 중단 후 예전 응답을 최신 snapshot으로 바꿔 자동 실행하지 않는다. 원래 회차 수정시각·실행 revision·예약 세대로 재검증하고, 성공 여부가 모호하면 현재 실행 보기 또는 명시적 재시도로 남긴다. receipt 정리도 오래된 세대를 다시 실행할 근거가 되어서는 안 된다.

현재 열어 둔 묶음의 일부 대상이 바뀌어 원래 예약 세대가 재조정에서 제거돼도, 그 화면의 원래 버전이 유효한 나머지 대상은 명시적으로 시작할 수 있다(#45). 현재 route와 ticket 전체가 일치해야 하며 새 대상을 편입하거나 최신 snapshot으로 바꾸지 않는다. 세대 제거는 `install`의 파일 저장 성공 후 메모리에 반영되므로, 이미 제거된 세대는 재실행 시 응답 조회에서 거절된다. 이 경우에만 없는 receipt를 다시 만들지 않고 실행 명령의 원래 버전·단일 실행 검증을 사용한다. 다른 세대의 예약을 소비하거나 옛 세대를 OS 예약으로 되살리지 않는다. 원래 세대가 남아 있는 경우에는 기존 receipt 저장 → 실행 저장 → receipt 완료 순서와 파일 실패 처리를 유지한다.

## 앱 저장과 OS 예약의 경계

계획 확정·추가·이동·건너뛰기·일괄 쉬기·복원·재계획, 실행 시작·정지·완료·취소 이후에는 **저장 성공 신호만** 재조정에 연결한다. running 구간을 닫는 중간 변경에서 OS를 호출하지 않는다. 앱 저장 실패는 기존 예약을 유지하며, OS 오류는 별도 대기/재시도로 남기고 저장된 계획을 되돌리지 않는다. 루틴 보관은 이미 확정된 회차 snapshot이나 예약을 없애지 않는다.

`ModelContext.didSave`를 채택한다. iOS 17부터 공개된 API이며 iPhone 15 Pro/iOS 26.5의 동결 입력 네이티브 선검증 2개가 통과했다. 실제 context/container 식별·다른 container 제외, 같은 context의 두 번째 성공 저장, 유효 명령의 주입 save 도달·정확한 실패 오류·동기 신호 0회, await 중 추가 저장의 수렴을 확인했다. 실행 전후 소스 60개 hash도 일치했다. 앞선 첫 corrected 실행은 당시 소스가 고정되지 않아 최종 근거에서 제외했다. 이는 실제 디스크 I/O 실패·iOS 17 실행·OS 예약을 입증하는 시험은 아니다.

기존 writer는 수정하지 않는다. 지원 OS의 실제 실행에서 이 신호가 불충분한 근거가 생기면 `PlanWriter`·`ExecutionWriter`·`RoutineWriter`의 commit 성공 직후 nonthrowing 변경 신호를 보내는 대안을 검토한다. 실제 명령·결과·로그는 #11 검증 근거에 기록한다. observer/OS 오류를 writer의 save catch로 전달하지 않는다.

재조정은 단일 drain과 변경 세대를 사용한다. MainActor도 await 중 재진입할 수 있으므로, OS 작업 전과 await 후 현재 DB·설정·세대를 다시 확인한다. 처리 중 끄기·이동·완료가 발생해도 오래된 add가 최종 예약으로 남지 않게 다시 맞춘다. 메모·수행일 정정처럼 예약 내용이 바뀌지 않은 저장은 반복 add/remove를 만들지 않는다.

## 예약과 실제 상태

회차별 normal, 날짜별 group, 주간 planning, snooze는 서로 다른 안정 request ID를 사용한다. 콘텐츠 세대와 원래 대상/버전은 별도로 영속화한다. 같은 세대의 재시도는 같은 payload를 사용한다. OS 응답에 고유 response UUID가 있다고 가정하지 않는다.

시각이 있는 회차는 해당 날짜의 단일 알림, 시각이 없는 회차는 사용자가 정한 기본 시각의 날짜별 묶음으로 예약한다. 실행 기본 시각은 처음에 미설정이다. 계획 알림만 주간 반복하며 기본 일요일 20:00은 변경·해제할 수 있다. 계획/실행 토글은 독립적이고 쉬기로 계획 알림 설정을 바꾸지 않는다.

실제 pending 요청을 조회해 외부 namespace를 보존하고 **64개 이하를 보수적 예산**으로 삼는다. 가까운 미래를 우선하고 계획 알림·수동 재알림 여유를 남기며 넘친 일정은 예약 대기로 표시한다. 일반 예약에 남기는 재알림 여유는 수동 요청의 별도 개수 상한이 아니다. 수동 재알림을 우선 배정하고 필요하면 먼 일반 예약을 대기로 둔다. 예산 감소로 예약되지 못한 기존 재알림도 고정 dueAt·원래 대상 의도를 보존한다. 64는 현대 UN API가 보장하는 정확한 상한이 아니다.

같은 ID의 add는 교체이지만 실패 시 이전 요청이 남는다고 보장하지 않는다. remove API에는 완료·오류 callback이 없고 secondary thread에서 비동기로 처리되므로 직후 readback도 삭제 완료 barrier가 아니다. pending과 Notification Center의 delivered 요청을 다시 읽어 차이를 재시도 상태로 남긴다. 조회 결과는 관찰 시점의 상태이며 앱/OS 간 transaction이나 실제 화면 표시·전달의 증거가 아니다. 이미 지난 기본 알림이 조회되지 않는다고 catch-up 재발송하지 않는다.

## 날짜와 앱 수명

기존 `LocalTime.resolve`의 `.nextTime`·`.first`를 재사용하고 DST로 달라진 실제 시각을 표시한다. 단일 예약의 `DateComponents.calendar`와 `.timeZone`에 Gregorian/UTC를 명시하고 초까지 포함해 해석된 instant와 `nextTriggerDate()`를 대조한다. 주간 계획 반복은 재조정 시점 기기 시간대의 Gregorian weekday/hour/minute로 구성하고 OS가 계산한 실제 다음 시각을 사용한다. 별도의 반복 DST 정책이나 실제 표시 성공은 보장하지 않는다.

실행·복귀·시간대/중요 시각 변경 통지에서 미래 예약을 다시 계산한다. 실제 실행 interval·완료 입력 당시 날짜·수행일은 바꾸지 않는다. 재알림은 자정을 넘어도 원래 날짜·원래 대상 집합만 검증하고 새 항목을 편입하지 않는다. 임의의 백그라운드 실행이나 종료 중 즉시 재계산은 보장하지 않는다.

## 권한과 화면 이동

첫 실행에서는 권한을 요청하지 않는다. 사용자가 기능을 켤 때 설명 후 alert/sound만 요청하며 badge·provisional 권한을 추가하지 않는다. 실행·복귀 때 현재 notification settings를 다시 읽고 기존 provisional 상태도 구분한다. 거절·철회는 denied 상태와 시스템 설정 열기로 처리하며 재요청이 시스템 prompt를 다시 띄운다고 안내하지 않는다. 허용 상태와 실제 배너·소리·Focus 전달은 구분한다.

delegate와 category는 앱 launch 완료 전에 등록하고 강하게 보유한다. delegate가 기존 PersistenceStore/coordinator를 열고 HanjuApp은 같은 인스턴스를 사용한다. callback에서 primitive Sendable 값만 MainActor로 전달한다. 저장소/라우터가 준비되지 않았으면 응답을 대기시키고 OS completion은 유한하게 정확히 한 번 끝낸다. 사용자 선택이 끝날 때까지 completion을 붙잡지 않는다.

시작·묶음 선택은 후속 화면 상호작용이 필요하므로 foreground 동작이다. 입력이 필요 없는 30분 재알림은 foreground로 앱을 열지 않고 `.authenticationRequired`로 보호 파일 접근을 확보한다. 기존 편집 초안·탭·날짜를 건드리지 않고 재알림 의도를 저장·반영한다. 실패는 다음 foreground의 별도 대기/재시도이며 백그라운드 무제한 실행은 보장하지 않는다. 잠금 상태 실제 동작은 #13에서 확인한다.

알림 본문 탭은 대상 보기이고 자동 시작이 아니다. 단일 시작도 현재 상태를 재검증하고 기존 단일 실행/교체 확인을 거친 뒤 저장 성공할 때만 실행 화면을 연다. 묶음에서는 현재 유효한 원래 대상 중 한 가지만 고른다. Today는 명시적인 알림 대상에 한해 원래 날짜를 표시하는 임시 목록을 제공한다. 당일 기본 필터·지난 일 자동 이월 정책은 유지한다.

계획 알림은 현재 주의 Records 장부·선택적 메모로 이동하고 기존 다음 주 계획 동선을 사용한다. 기존 편집 시트·확인창이 열려 있으면 탭/날짜/초안을 바꾸지 않는다. presentation 소유자가 공개 상태로 root gate에 참여한다. 닫은 뒤에도 대기 알림을 자동으로 소비하지 않고 사용자가 명시적으로 열게 한다. 중첩 sheet·지연 시간 기반 라우팅·미완료 배지는 추가하지 않는다.

## 검증 범위와 근거

#11에서 순수 계산, 실제 파일 저장/재열기/실패, SwiftData 성공/실패와 전이, 실제 UN pending 재조회, 전용 시뮬레이터의 권한·응답·초안 보호 UI를 각각 기록한다. API 타입 검사나 macOS 날짜 계산을 iOS 실행 증거로 쓰지 않는다. 실제 iPhone 잠금/종료 전달·Focus·iOS 17 실행·전체 접근성은 #13의 미검증이며 scoped 구현 완료와 전체 MVP 인수는 별개다.

- [권한 요청](https://developer.apple.com/documentation/usernotifications/asking-permission-to-use-notifications), [delegate](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter/delegate), [action foreground](https://developer.apple.com/documentation/usernotifications/unnotificationactionoptions/foreground).
- [저장 완료 신호](https://developer.apple.com/documentation/swiftdata/modelcontext/didsave), [안정 요청 ID](https://developer.apple.com/documentation/usernotifications/unnotificationrequest/identifier), [pending 조회](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter/getpendingnotificationrequests(completionhandler:)), [예약 제거](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter/removependingnotificationrequests(withidentifiers:)).
- [Calendar 날짜 해석](https://developer.apple.com/documentation/foundation/calendar/nextdate(after:matching:matchingpolicy:repeatedtimepolicy:direction:)), [실제 다음 trigger](https://developer.apple.com/documentation/usernotifications/uncalendarnotificationtrigger/nexttriggerdate()), [구 API의 제한 문서](https://developer.apple.com/documentation/uikit/uilocalnotification).
