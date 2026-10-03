# AI 리뷰와 PR 검증

관련 이슈: #3. 코드 수정은 독립 Codex 또는 Copilot 리뷰 후 병합한다. 구현자가 자신의 변경을 승인하지 않는다.

## 실제 적용

main ruleset `24424097`은 PR·squash 통합, 선형 이력, 대화 해결을 요구하고 삭제·force push를 금지한다. Copilot 자동 리뷰는 신규 PR과 추가 push에 켜고 draft에서는 끈다. 1인 저장소이므로 사람 승인 수는 0이다. 관리자의 우회 목록은 비어 있다.

GitHub Actions `PR policy`는 브랜치·PR 제목·모든 새 커밋의 대표 이슈 번호와 실제 이슈 존재, 본문의 Closes/Refs 연결을 검사한다. 닫힌 원본 이슈는 Graphify 후속 PR에서 재사용할 수 있다. 250개 이상 커밋은 전체 API 조회 한계 때문에 작은 PR로 나눈다. Actions는 읽기 권한만 사용하고 비밀키나 외부 LLM API를 요구하지 않는다. 필수 status check는 실제 첫 성공 후 main ruleset에 연결한다.

## PR별 순서

1. 작성자가 검증을 수행하고 `agent:codex` 라벨과 PR 템플릿을 채운다.
2. ready PR에서 Copilot 리뷰 요청/결과를 확인한다. 자동 요청 설정은 결과 수신이나 승인과 다르다. 라이선스·사용량·서비스 상태에 따라 실행되지 않을 수 있다.
3. Copilot을 사용할 수 없으면 구현하지 않은 Codex 하위 에이전트가 base/head SHA, diff, 관련 AC, 테스트를 읽고 리뷰한다. 또는 저장소가 연결된 Codex GitHub 연동에서 PR 댓글 `@codex review`로 요청한다. GitHub 연동 활성화는 별도 계정 설정이며 이 문서만으로 연결되지 않는다.
4. 결과에 리뷰 도구/리뷰어, 검토 head SHA, 발견 사항과 처리 근거, 남은 미검증을 기록한다. 로컬 Codex 결과는 PR 본문에 그대로 요약하고 게시 계정과 도구를 구분한다.
5. 코드를 수정하면 검증과 독립 리뷰를 갱신한다. 예전 SHA의 리뷰, 요청 댓글, 무응답, CI 성공을 리뷰 완료로 간주하지 않는다. P0/P1과 그 외 인수 조건 위반을 해결하거나 근거 있는 비해당 판정을 남긴다.
6. 개발총괄이 최신 SHA 리뷰·CI·대화 해결을 확인하고 squash merge한다. 자동 병합과 AI 자동 승인은 사용하지 않는다. 병합 후 Graphify는 별도 절차로 실행한다.

현재 자동 강제 검사는 PR 정책 CI와 ruleset이다. **AI 리뷰 완료 여부·지적 처리의 타당성은 개발총괄이 검증한다.** Copilot 자동 요청 규칙만으로 리뷰 완료를 강제한다고 주장하지 않는다. 서비스가 응답하지 않아도 독립 Codex 리뷰로 진행할 수 있다.

## 근거

- [GitHub Copilot 자동 리뷰 설정](https://docs.github.com/en/copilot/how-tos/copilot-on-github/set-up-copilot/configure-code-review)
- [GitHub ruleset API](https://docs.github.com/en/rest/repos/rules#create-a-repository-ruleset)
- [Codex GitHub 리뷰와 AGENTS 지침](https://learn.chatgpt.com/docs/third-party/github)
