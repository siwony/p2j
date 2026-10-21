# AI 리뷰와 PR 검증

관련 이슈: #3, #9. 사용자 결정(2026-10-07): 코드 수정은 독립 Codex 리뷰를 받고, 문서·Graphify를 포함한 모든 PR은 최신 head SHA의 Copilot 리뷰 결과를 받은 뒤 병합한다. 구현자가 자신의 변경을 승인하지 않는다.

## 실제 적용

main ruleset `24424097`은 PR·squash 통합, 선형 이력, 대화 해결을 요구하고 삭제·force push를 금지한다. Copilot 자동 리뷰는 신규 PR과 추가 push에 켜고 draft에서는 끈다. 1인 저장소이므로 사람 승인 수는 0이다. 관리자의 우회 목록은 비어 있다.

GitHub Actions `PR policy`는 브랜치·PR 제목·모든 새 커밋의 대표 이슈 번호와 실제 이슈 존재, 본문의 Closes/Refs 연결을 검사한다. 닫힌 원본 이슈는 Graphify 후속 PR에서 재사용할 수 있다. 250개 이상 커밋은 전체 API 조회 한계 때문에 작은 PR로 나눈다. Actions는 읽기 권한만 사용하고 비밀키나 외부 LLM API를 요구하지 않는다. `PR policy`는 PR #6의 실제 첫 성공(run 37142922120) 후 main 필수 검사(app15368)로 연결했다. 앱 프로젝트 추가 후 `iOS build and tests`도 실제 성공을 확인하고 같은 방식으로 연결한다.

## PR 검사와 main 전체 회귀

사용자 결정(2026-10-21), #44: PR에서는 전체 앱 빌드·모든 단위 테스트·변경과 관련된 UI 테스트를 확인하고, 전체 회귀는 main 병합 후 별도로 실행한다. 공용 코드·영향 범위가 불명확한 변경은 PR에서도 전체 검사를 유지한다. 문서·Graphify만 바뀌면 native 검증 불필요를 명시한다. 구체적인 선택 범위와 수동 실행 명령은 [로컬 개발 안내](local-development.md#pr-검사와-전체-회귀)에 있다.

PR의 필수 `iOS build and tests`와 별도 `iOS full regression`을 혼동하지 않는다. PR 선별 검사의 성공은 전체 회귀 통과가 아니다. 전체 회귀가 진행 중이어도 다음 개발과 PR 검증은 진행할 수 있으며, 병합 조건은 최신 PR의 필수 검사·독립 Codex·실제 Copilot 결과로 판단한다.

개발총괄은 작업을 재개할 때와 다음 병합 전에 최근 main 전체 회귀의 실제 SHA·진행 상태·결과를 확인한다. 문서 전용 skip 실행의 SUCCESS로 직전 native 전체 회귀를 대체하지 않는다. 실패·취소·timeout·결과 누락은 미검증으로 기록하고 원인을 확인한다. 실제 회귀 실패가 확인되면 후속 기능 병합을 보류하고 필요한 수정·재실행을 우선한다. 다른 SHA의 성공만 보고 과거 실패가 해결됐다고 추정하지 않으며, 실패 SHA와 수정·재검증 근거를 연결한다. PR/인계에는 선별 검사와 전체 회귀의 실행 링크·SHA·상태를 각각 남긴다.

전체 회귀 결과를 기다리지 않는 정책은 최신 head의 Copilot 대기나 독립 코드 리뷰를 생략하는 근거가 아니다.

## PR별 순서

1. 작성자가 검증을 수행하고 `agent:codex` 라벨과 PR 템플릿을 채운다.
2. ready PR에서 최신 head SHA의 Copilot 리뷰 요청과 실제 완료 결과를 확인하고 기다린다. 자동 요청 설정은 결과 수신이나 승인과 다르다. 라이선스·사용량·서비스 상태에 따라 실행되지 않을 수 있다.
3. 코드 변경은 구현하지 않은 Codex 하위 에이전트가 base/head SHA, diff, 관련 AC, 테스트를 읽고 리뷰한다. 또는 저장소가 연결된 Codex GitHub 연동에서 PR 댓글 `@codex review`로 요청한다. GitHub 연동 활성화는 별도 계정 설정이며 이 문서만으로 연결되지 않는다.
4. 결과에 리뷰 도구/리뷰어, 검토 head SHA, 발견 사항과 처리 근거, 남은 미검증을 기록한다. 로컬 Codex 결과는 PR 본문에 그대로 요약하고 게시 계정과 도구를 구분한다.
5. 코드를 수정하면 검증과 독립 리뷰를 갱신한다. 예전 SHA의 리뷰, 요청 댓글, 무응답, CI 성공을 리뷰 완료로 간주하지 않는다. P0/P1과 그 외 인수 조건 위반을 해결하거나 근거 있는 비해당 판정을 남긴다.
6. 개발총괄이 최신 SHA의 독립 Codex 리뷰(코드 변경)·완료된 Copilot 리뷰·지적 조치·CI·대화 해결을 확인하고 squash merge한다. Copilot이 COMMENTED로 완료되어도 실제 내용과 검토 SHA를 확인하며, GitHub의 APPROVED 상태와 혼동하지 않는다. 자동 병합과 AI 자동 승인은 사용하지 않는다. 병합 후 Graphify는 별도 절차로 실행한다.

현재 자동 강제 검사는 PR 정책 CI와 ruleset이다. **AI 리뷰 완료 여부·지적 처리의 타당성은 개발총괄이 검증한다.** Copilot 자동 요청 규칙만으로 리뷰 완료를 강제한다고 주장하지 않는다. Copilot 미실행·무응답이면 원인을 기록하고 병합을 대기한다. 독립 Codex 리뷰는 구현 검토에 활용하지만 Copilot 대기를 대신하지 않는다. 지연이 지속되면 사용자에게 상태와 필요한 결정을 알리며 예외 병합을 임의 결정하지 않는다.

## 근거

- [GitHub Copilot 자동 리뷰 설정](https://docs.github.com/en/copilot/how-tos/copilot-on-github/set-up-copilot/configure-code-review)
- [GitHub ruleset API](https://docs.github.com/en/rest/repos/rules#create-a-repository-ruleset)
- [Codex GitHub 리뷰와 AGENTS 지침](https://learn.chatgpt.com/docs/third-party/github)
