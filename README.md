# 한 주 — iPhone 주간 루틴 앱 기획

현재는 기획 단계입니다. 집안일과 공부를 주간 단위로 계획하고, 부담 없이 실행과 재시작을 돕는 iPhone 앱입니다. 개발팀이 착수할 수 있도록 범위·화면·동작 정책·인수 조건을 정리했습니다.

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

[개발팀 인계](DEVELOPMENT_HANDOFF.md)에서 시작합니다. [SwiftUI 구현 계약](design/05-swiftui-handoff.md)은 협업용 압축 문서입니다. 기획·디자인 자료는 사람이 읽기 쉬운 문체를 유지합니다.

지원 iOS·테스트 기기·배포 경로·개발팀 견적은 착수 미팅에서 확정합니다. 기획서의 8주와 250,000원은 기존 개인 개발 추정치로, 개발팀의 일정이나 인건비 견적이 아닙니다.

## 화면 프리뷰

[프리뷰 파일](design/preview/index.html)을 브라우저에서 직접 열 수 있습니다. 로컬 서버를 사용하려면 이 폴더에서 실행합니다.

```sh
python3 -m http.server 8784 --bind 127.0.0.1
```

주소: http://127.0.0.1:8784/design/preview/index.html

화면·다크 모드·큰 글자와 주요 동작을 살펴보는 예시입니다. 실제 앱이나 기획서의 전체 기능 구현물이 아닙니다. 동작 정책은 기획서와 화면 명세를 따릅니다.

## 원본과 보관

사용자 디자인 지침은 [원문](design/reference/user-design-brief.txt)에 보존했습니다. 중복 검토 문서와 압축 전 원본은 `docs/.archive/`에 보관하며 기본 읽기 대상에서 제외합니다.
