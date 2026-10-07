# 구현 순서와 담당

2026-10-07 · 모든 단계는 실제 이슈 → 구현 → 독립 Codex 리뷰 → 최신 head Copilot 완료·검증 → PR 병합 순서다. 단계 완료와 MVP 인수를 구분한다.

기획 1.3 / [#18](https://github.com/siwony/p2j/issues/18): [변경 인계](planning-revision-1.3.md) 먼저 확인. Policy adopted; implementation pending. #8~#13의 개정 AC·시나리오 적용. 기존 개발 순서 유지.

| 순서 | 이슈 | 범위와 선행 조건 |
| --- | --- | --- |
| 1 | [#1](https://github.com/siwony/p2j/issues/1) | 협업 규칙, 병합 후 Graphify 최초 생성 완료(PR #2, #5) |
| 2 | [#3](https://github.com/siwony/p2j/issues/3) | AI 리뷰·PR 이슈 검사·main 보호 완료(PR #6) |
| 3 | [#4](https://github.com/siwony/p2j/issues/4) | 네이티브 프로젝트·저장 경계·이름 등록·빌드 검증. 전체 기능 AC를 완료하지 않는다 |
| 4 | [#7](https://github.com/siwony/p2j/issues/7) | 루틴 편집·선택 필드·보관/복원, dirty swipe 취소 확인과 초점 복원 |
| 5 | [#8](https://github.com/siwony/p2j/issues/8) | LocalDate·주간 계획·snapshot·중복 방지. 일괄 쉬기/복원 + Today→Week 재계획 진입 소유 |
| 6 | [#9](https://github.com/siwony/p2j/issues/9) | 단일 실행·직접 완료·재실행 복원 + 수행일 정정. #8 선행; 실행 중 일괄 쉬기 원자성 통합 |
| 7 | [#10](https://github.com/siwony/p2j/issues/10) | 수행일 기준 두 주 집계 + 행동 우선 기록 + 자유 메모. #9 완료 기록 선행 |
| 8 | [#11](https://github.com/siwony/p2j/issues/11) | 알림/수동 snooze + 일괄 쉬기·복원·재계획 후 예약 정리. #8/#9 선행 |
| 9 | [#12](https://github.com/siwony/p2j/issues/12) | 주별 연결·신규 항목 자동 반영·해제/재연결·주 이동·외부 변경·중단 복구. #8/#9 선행 |
| 10 | [#13](https://github.com/siwony/p2j/issues/13) | 실기기·접근성·전체 AC + 놓침/쉬기/늦은 기록/복귀 시나리오, 실제 2주 실사용 |

사용자가 순차 구현을 요청했다. 독립적인 기술 조사·리뷰는 병렬로 진행할 수 있으며, 기능 구현 순서는 위 의존성을 따른다. 한 단계의 실패를 성공으로 표시하고 넘어가지 않는다.

## #4 기반 완료 당시 배정

- 개발총괄: ADR, 데이터 계약, 이슈 분해, CI, 최종 통합·실행 검증·Git 작업.
- `ios_foundation_builder`: `Hanju/`, `HanjuTests/`, `HanjuUITests/`, `Hanju.xcodeproj/` 단독 구현.
- `technology_research`: 공식 Apple 자료에 기반한 기술 조사, 읽기 전용.
- `review_rules_pr`: 구현하지 않은 Codex의 diff·정책·실패 경로 리뷰.

후속 구현 시작 때 해당 이슈에 구현자·리뷰어·허용 파일을 다시 배정한다. 공용 모델과 프로젝트 파일을 기능 담당들이 동시에 수정하지 않는다.

## #7 구현과 담당

- 기획 1.3 PR #20 병합(`e5945a8`) 후 착수. AC-01/12/14, 루틴함·편집 화면 기준.
- 구현 worker `ios_foundation_builder`: `Hanju/Features/Library/`, 관련 단위/UI 테스트, 소스 등록을 위한 프로젝트 설정. 기존 V1 필드를 재사용하며 스키마는 변경하지 않는다.
- 독립 Codex 리뷰 `review_collaboration_rules`: 실제 diff·입력 보존·저장 실패·편집/보관/복원·swipe 취소 검토.
- 개발총괄: 범위·공용 계약·문서·통합 검증·Git·PR·병합 감독. 공유 checkout에서 Git 변경은 총괄만 수행한다.
- 선호 요일 저장값은 월요일 1부터 일요일 7까지다. 날짜 구현 #8도 이 값을 명시적으로 변환하며 Foundation의 weekday 숫자와 혼용하지 않는다.
- 실제 회차/기록 snapshot 모델은 #8 이후 도입한다. #7은 원본 ID·생성시각·선택값 보존을 검증하고, 과거 snapshot 결합 검증은 #8에서 수행한다.

1.3 integration: #8 owns rest/replan command + route contract; #9 adds recorder atomics + performed date; #10 consumes performed-date grouping; #11/#12 consume committed transitions. #8의 계획 기능 완료가 아직 없는 recorder/OS 연동까지 검증했다는 뜻은 아니다. 각 이슈가 담당 결합부를 검증하고 #13에서 전체 인수한다.

## #8 구현과 담당

- 기준 main `0796b75`, 기획 1.3. AC-02/03/10/11/12/14 및 R13-01~04의 계획 기능을 구현한다.
- 구현 worker `ios_foundation_builder`: 날짜·주간 모델과 저장 명령, Week/Today 계획 진입과 탭 라우팅, 관련 테스트·프로젝트 소스 등록 단독 소유.
- 독립 Codex 리뷰 `review_collaboration_rules`: 실제 diff·V1 이전·날짜/DST·snapshot·원자 저장·취소 맥락·중복 방지 검토.
- 개발총괄: 문서·이슈·통합 검증·Git·PR·병합 감독. 공유 checkout에서 Git 변경은 총괄만 수행한다.
- V1 모델 정의를 유지한 채 새 schema에 주간 모델을 추가하고 실제 V1 디스크 store로 이전·재열기를 검증한다.
- #9의 실행 기록, #11 알림, #12 캘린더는 후속 통합이다. recorder가 없는 단계에서 running을 기록 보존 없이 옮기거나 건너뛰지 않는다.
- 사용자 수동 테스트 시뮬레이터를 보존하고 별도 시뮬레이터에서 자동 테스트한다.

## #9 구현과 담당

- 구현·검증 근거는 #9 PR에서 추적한다. 기준 main `e8ab5d8`, 브랜치 `codex/feat/9-execution-records`. #8 PR #23의 계획 기능 병합 뒤 착수. AC-04/05/10/11/12, R13-01/02/05/06을 사용한다.
- 구현 worker `ios_foundation_builder`: 실행 서비스·V3 모델·앱 수명 주입, Today/Week 실행 진입, 동일 저장 단위의 쉬기/이동/복원, 관련 테스트·프로젝트 등록 단독 소유. V1/V2 저장 모델 정의는 변경하지 않는다.
- 기술 조사 `fix_rebase_hook`: 공식 Apple 문서·설치 SDK의 시계/저장 API를 읽기 전용으로 검증. 결정: [ADR 0002](../adr/0002-execution-time-and-recovery.md).
- 독립 Codex 리뷰 `review_collaboration_rules`: 실제 diff·이전·단일 실행·복구·완료 날짜·저장 실패·취소·접근성 검토. 최신 head Copilot 결과도 도착한 뒤 병합한다.
- 개발총괄: 공용 계약·문서·이슈·통합 검증·Git·PR·병합 감독. 공유 checkout에서 Git 변경은 총괄만 수행한다.
- #10의 전체 주간 기록·메모, #11 알림, #12 캘린더는 제외한다. #13에서 실제 iPhone의 잠금/종료/재부팅·시간대와 전체 접근성을 인수한다. 사용자 수동 테스트 시뮬레이터와 데이터는 보존한다.

## 기반 단계의 경계

기반 #4는 이름 등록/재조회까지 구현했다. #7은 분류·예상분·기본횟수·선호요일·시작행동·메모 편집, 분류 필터, 보관/복원을 구현했다. 기존 V1 필드를 사용하며 별도 저장 context에서 명령을 확정하고 목록은 값 복사로 다시 읽는다. #8은 계획·회차 snapshot·선택 재계획과 쉬기/복원을 구현했다. #9은 앱 수명 타이머·직접 완료·기록 수정·수행일 정정과 running 계획 변경의 원자 저장을 구현한다. 전체 주간 기록·알림·캘린더는 #10–#12 후속 단계이며 빈 탭에 성공 상태나 가짜 데이터를 넣지 않는다.

기반 편집 시트의 미완료였던 swipe 시도 확인은 #7에서 공개 UIKit presentation delegate를 좁게 연결해 처리한다. 변경된 초안은 시스템 닫기 차단을 유지하며 ‘계속 편집/변경 버리기’를 제공한다. 저장 실패 시 원문을 보존하고 저장과 보관/복원 재시도를 구분한다. AC-12 전체 인수는 후속 계획·실행 화면과 #13 검증까지 포함한다.

각 개발 PR 병합 뒤 Graphify를 갱신한다. 연속 병합은 마지막 main SHA로 묶을 수 있고, 생성물만 변경한 PR에는 재실행하지 않는다.
