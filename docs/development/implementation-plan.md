# 구현 순서와 담당

2026-10-04 · 모든 단계는 실제 이슈 → 구현 → 독립 Codex/Copilot 리뷰 → 검증 → PR 병합 순서다. 단계 완료와 MVP 인수를 구분한다.

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

## #4 현재 배정

- 개발총괄: ADR, 데이터 계약, 이슈 분해, CI, 최종 통합·실행 검증·Git 작업.
- `ios_foundation_builder`: `Hanju/`, `HanjuTests/`, `HanjuUITests/`, `Hanju.xcodeproj/` 단독 구현.
- `technology_research`: 공식 Apple 자료에 기반한 기술 조사, 읽기 전용.
- `review_rules_pr`: 구현하지 않은 Codex의 diff·정책·실패 경로 리뷰.

후속 구현 시작 때 해당 이슈에 구현자·리뷰어·허용 파일을 다시 배정한다. 공용 모델과 프로젝트 파일을 기능 담당들이 동시에 수정하지 않는다.

1.3 integration: #8 owns rest/replan command + route contract; #9 adds recorder atomics + performed date; #10 consumes performed-date grouping; #11/#12 consume committed transitions. #8의 계획 기능 완료가 아직 없는 recorder/OS 연동까지 검증했다는 뜻은 아니다. 각 이슈가 담당 결합부를 검증하고 #13에서 전체 인수한다.

## 기반 단계의 경계

현재 저장 경로는 루틴 이름 등록/재조회다. 계획·타이머·기록·알림·캘린더는 구현하지 않았고 빈 탭에 성공 상태나 가짜 데이터를 넣지 않는다. 기존 이름을 편집하거나 보관하는 기능도 #7에서 완료한다.

기반 편집 시트는 변경이 있으면 swipe 닫기를 차단하고 취소 버튼에서 ‘계속 편집/변경 버리기’를 제공한다. 독립 리뷰가 지적한 **swipe 시도 자체의 확인창**은 #7의 명시적 미완료 사항이며 AC-12 완료로 표시하지 않는다. 저장 실패 시 원문은 보존한다.

각 개발 PR 병합 뒤 Graphify를 갱신한다. 연속 병합은 마지막 main SHA로 묶을 수 있고, 생성물만 변경한 PR에는 재실행하지 않는다.
