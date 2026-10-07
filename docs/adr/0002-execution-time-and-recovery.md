# ADR 0002: 실행 시간과 재실행 복구

상태: 채택 · 2026-10-07 · 관련 이슈 #9 · 기획 1.3

## 문제와 선택

벽시계만 빼면 수동 시각 변경으로 시간이 줄거나 늘어난다. UI tick 누적은 화면 이탈·앱 종료 때 기록을 잃는다. `systemUptime`은 수면을 제외한다. 별도 서버나 백그라운드 실행에 의존하지 않고 실제 실행 구간을 보존해야 한다.

앱 수명의 MainActor 실행 서비스와 SwiftData 저장 명령을 사용한다. 명령은 await 없이 새 context에서 한 번에 저장하고 성공 뒤 화면 상태를 갱신한다. 다른 실행으로 전환할 때 기존 pause와 새 start, 일괄 쉬기 때 구간 종료와 skipped는 같은 저장 단위다.

Date는 시작/종료·완료 입력 사실에 사용한다. 경과 시간은 공개 Darwin `clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW)`의 차이로 계산한다. 이 시계는 수면을 포함하며 iOS 10부터 제공된다. UI 갱신은 표시만 수행한다. 테스트는 시계 샘플을 주입한다.

## 복구와 기록 보존

같은 프로세스에서는 단조 시계로 계산해 벽시계 변경에 영향을 받지 않는다. 재실행 때 저장 샘플과 새 프로세스의 시작 샘플을 비교해 감소 또는 벽시계/단조 경과 차이가 5초를 넘으면 해당 미종료 구간을 확인 필요로 보존한다. 판정은 프로세스 시작 기준으로 고정하고 그 뒤 벽시계가 변경돼도 정상 복구를 다시 불확실로 바꾸거나 불확실한 복구를 조용히 확정하지 않는다. 복구에서 확인 필요로 판정한 열린 구간은 그 표식을 한 번 영속화해 다시 종료·실행해도 조용히 확정하지 않는다. 표식 저장 실패는 기존 실행/원본과 오류를 보존하고 재시도한다. 확정된 구간은 유지하고 불확실한 구간을 0이나 벽시계 추정값으로 덮어쓰지 않는다. 시간 입력 없이 pause·재개·완료할 수 있다.

공개된 부팅 세션 식별자를 확인하지 못했다. 샘플 비교는 휴리스틱이며 동일 부팅의 증명이 아니다. 앱 종료 중 재부팅과 수동 시각 변경이 겹치는 모든 경우를 완벽히 구분한다고 주장하지 않는다. 실제 기기 종료/재부팅 검증은 #13에 남긴다.

선택적 수동 총시간은 구간 sequence 경계까지 적용한다. 원본 구간을 삭제하지 않고 이후 구간만 더한다. 사용자가 불확실한 구간을 포함해 정정하면 그 경계까지의 시간을 대체하며, 이후 새 불확실 구간은 다시 확인 필요다. 비우면 원래 측정값/확인 필요로 돌아간다. 수행일만 변경할 때 초 단위 시간이나 수동값을 표시용 분으로 반올림해 다시 저장하지 않는다.

완료 입력시각·당시 현지 날짜·수행일은 별도로 저장한다. 완료 취소는 세 날짜만 해제하고 구간/시간을 보존한다. 재완료는 새 입력 사실을 캡처한다. revision으로 오래된 화면 명령을 거절한다.

## 저장과 영향

V3는 V1 RoutineTemplate과 V2 WeekPlan/PlannedOccurrence 정의를 그대로 재사용하며 ExecutionRecord/ExecutionInterval을 추가한다. 기존 스키마 정의는 동결하고 migration 목록만 확장한다. 디스크 V1→V3·V2→V3 이전과 재열기로 ID·snapshot·값 보존을 검증한다.

nil(측정 이력 없음), 0, 1분 미만을 구별하고 불확실 시간은 별도로 표시한다. 전체 기록 집계·메모는 #10, OS 연동은 #11/#12다. 저장 오류를 메모리 DB로 숨기지 않는다.

## 검증 근거

기능 검증 결과는 #9 PR에 실제 명령·환경·로그와 함께 기록한다. 시간 변경·재실행·중복 명령·저장 실패·날짜 수명·수동 정정·쉬기 원자성 및 디스크 이전을 확인한다. Simulator 결과는 실제 기기의 잠금/재부팅 인수를 대신하지 않는다.

공식 자료와 설치된 iOS SDK를 기술 조사 agent가 확인했다: [수면 포함 시계와 권장 API](https://developer.apple.com/documentation/kernel/1646199-mach_continuous_time), [systemUptime](https://developer.apple.com/documentation/foundation/processinfo/systemuptime), [rollback](https://developer.apple.com/documentation/swiftdata/modelcontext/rollback()), [migration](https://developer.apple.com/documentation/swiftdata/schemamigrationplan). ContinuousClock.Instant의 Codable 제공 여부와 별개로 재부팅 간 비교의 정확성을 가정하지 않는다.

현재 Apple [필수 사유 API 목록](https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitype)은 SystemBootTime에 systemUptime/mach_absolute_time을 열거한다. 선택한 clock_gettime_nsec_np 호출만으로 PrivacyInfo.xcprivacy 추가 의무를 확인하지 못했다. 실제 사용 API가 바뀌면 다시 확인한다.
