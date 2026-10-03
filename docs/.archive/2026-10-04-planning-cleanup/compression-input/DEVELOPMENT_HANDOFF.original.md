# 개발팀 인계

## 상태와 읽는 순서

현재는 기획 단계다. iPhone MVP 개발 착수를 위한 자료를 제공한다. 네이티브 앱 구현과 검증은 개발팀의 후속 작업이다.

1. `docs/product-plan.md`: 제품 범위, 동작 정책, 인수 조건, 착수 시 확정할 사항.
2. `design/01-direction.md`, `design/02-foundations.md`, `design/tokens.json`: 아트 디렉션과 시각 기준.
3. `design/03-components.md`, `design/04-screens.md`: 컴포넌트·화면·상태 계약. 담당 기능의 섹션부터 읽는다.
4. `design/05-swiftui-handoff.md`: 구현·검증 협업 계약.

`design/preview/index.html`은 화면 참고용 예시다. 문서가 동작 정책의 기준이다. 프리뷰의 고정 날짜·예시 데이터·가상 권한 상태를 제품 로직으로 복사하지 않는다.

## 협업 규칙

최신 사용자 결정이 우선이다. 제품 정책은 기획서, 시각 값은 토큰, 화면 계약은 화면 명세에서 관리한다. 변경 시 관련 참조를 함께 갱신하고 같은 규칙을 여러 문서에 복제하지 않는다.

다음 프로젝트 스킬을 역할별로 적용한다.

- `.agents/skills/swiftui-design-skill/SKILL.md`: 아트 디렉션·구도·위계.
- `.agents/skills/apple-design/SKILL.md`: iOS 탐색·조작 관례.
- `.agents/skills/swiftui-pro/SKILL.md`: SwiftUI 구현·데이터 흐름·동시성.
- `.agents/skills/design-swiftui-interfaces/SKILL.md`: 인터랙션·모션·접근성·시각 QA.

판단 순서: 제품 철학 → 아트 디렉션 → 시각 위계·고유 정체성 → 네이티브 iOS 인터랙션 → 구현 정확성 → 시뮬레이터 QA. 스킬의 기본 스타일을 평균화하지 않는다. standard 프로필과 현재 브랜드를 유지한다.

사람이 읽는 기획·디자인 명세는 자연스러운 문장을 유지한다. 이 문서와 구현 협업 문서는 caveman 방식으로 작성한다. 코드·경로·API·조건·부정 표현은 손실 없이 보존한다.

## 착수와 범위

기획서의 착수 확인 사항을 개발팀이 정리한 뒤 Foundation → 공통 컴포넌트 → 화면·저장 → 알림·캘린더 → 접근성·실사용 순서로 진행한다. 현재 기획 검토에서는 개발·배포를 시작하지 않는다.

Mac·CloudKit·서버·계정·결제는 첫 버전 범위 밖이다. HTML을 WebView로 포장하지 않고 SwiftUI로 구현한다. 테스트는 기획서의 인수 조건에 대응시킨다.

과거 검토·압축 원본은 `docs/.archive/`에 보관한다. 기본 읽기 대상에서 제외한다. 원본 디자인 요구는 충돌 확인이 필요할 때만 `design/reference/user-design-brief.txt`에서 확인한다.
