# 한 주 — iPhone 주간 루틴 앱

현재는 네이티브 앱 기반을 구현하는 단계입니다. 집안일과 공부를 주간 단위로 계획하고, 부담 없이 실행과 재시작을 돕는 iPhone 앱입니다. 개발팀이 착수할 수 있도록 범위·화면·동작 정책·인수 조건을 정리했습니다.

## 기획·디자인 자료

| 문서 | 내용 |
| --- | --- |
| [제품 기획서](docs/product-plan.md) | Why / What / How / So What, MVP 정책, 인수 조건 14개, 착수 확인 사항 |
| [디자인 방향](design/01-direction.md) | 제품 태도, 시각 언어, 화면별 구성 |
| [디자인 기준](design/02-foundations.md) | 색상·서체·간격·접근성 |
| [컴포넌트 명세](design/03-components.md) | 공통 UI의 역할과 상태 |
| [화면 명세](design/04-screens.md) | 8개 화면, 상태와 탐색 흐름 |
| [디자인 토큰](design/tokens.json) | 구현할 시각 값의 기준 |

## 개발 협업 자료

[개발 및 협업 규칙](CONTRIBUTING.md)은 이슈·브랜치·커밋·PR·검증의 기준입니다. 모든 개발 에이전트는 [AGENTS.md](AGENTS.md)를 먼저 읽습니다. [Graphify 운영](docs/development/graphify.md)은 main 병합 이후 갱신과 현재 AI 도구의 라벨링 절차를 정의합니다.

[개발팀 인계](DEVELOPMENT_HANDOFF.md)에서 시작합니다. [SwiftUI 구현 계약](design/05-swiftui-handoff.md)은 협업용 압축 문서입니다. 기획·디자인 자료는 사람이 읽기 쉬운 문체를 유지합니다.

iOS 17 이상·iPhone 15 Pro·개인 기기 우선 검증을 기준으로 시작합니다. 실제 기기 OS·서명 계정과 개발 일정은 검증 단계에서 확인합니다. 기획서의 8주와 250,000원은 기존 개인 개발 추정치로, 개발팀의 일정이나 인건비 견적이 아닙니다.

## 화면 프리뷰

[프리뷰 파일](design/preview/index.html)을 브라우저에서 직접 열 수 있습니다. 로컬 서버를 사용하려면 이 폴더에서 실행합니다.

```sh
python3 -m http.server 8784 --bind 127.0.0.1
```

주소: http://127.0.0.1:8784/design/preview/index.html

화면·다크 모드·큰 글자와 주요 동작을 살펴보는 예시입니다. 실제 앱이나 기획서의 전체 기능 구현물이 아닙니다. 동작 정책은 기획서와 화면 명세를 따릅니다.

## 원본과 보관

사용자 디자인 지침은 [원문](design/reference/user-design-brief.txt)에 보존했습니다. 중복 검토 문서와 압축 전 원본은 `docs/.archive/`에 보관하며 기본 읽기 대상에서 제외합니다.

## 네이티브 개발

`Hanju.xcodeproj`의 `Hanju` scheme을 연다. iPhone 15 Pro 기준 iOS 17 이상, SwiftUI·SwiftData를 사용한다. 현재 기반 범위는 5개 탭 시작점과 이름으로 루틴 등록/저장이며 전체 MVP는 개발 중이다.

- [기술 선택 ADR](docs/adr/0001-native-ios-foundation.md)
- [로컬 실행](docs/development/local-development.md)
- [구현 순서와 이슈](docs/development/implementation-plan.md)
- [데이터 계약](docs/development/data-contracts.md)
- [Codex/Copilot 리뷰 절차](docs/development/review-workflow.md)
