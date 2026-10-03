# 한 주 iOS 디자인 및 개발 인계

집안일과 공부를 주간 단위로 계획하고, 부담 없이 실행과 재시작을 돕는 iPhone 앱의 디자인 작업 공간입니다. 현재 단계는 제품 디자인과 개발 인계입니다. 네이티브 앱은 아직 구현하지 않았습니다.

## 확인 순서

1. [제품 기획서](docs/product-plan.md)
2. [사용자가 제공한 디자인 지침](design/reference/user-design-brief.txt)
3. [디자인 방향](design/01-direction.md)
4. [디자인 기초와 토큰](design/02-foundations.md)
5. [컴포넌트 명세](design/03-components.md)
6. [화면 명세](design/04-screens.md)
7. [SwiftUI 구현 명세](design/05-swiftui-handoff.md)
8. [감독 검토 결과](docs/design-review.md)
9. [별도 개발 세션 인계서](DEVELOPMENT_HANDOFF.md)
10. [스킬 기반 아트 디렉션 재검토](design/06-art-direction-review.md)
11. [네이티브 경험·접근성·QA 계약](design/07-experience-contract.md)

## 화면 프리뷰

[디자인 프리뷰 열기](design/preview/index.html)

브라우저에서 확인하는 iPhone 디자인 시뮬레이션입니다. 실제 알림, 캘린더 권한, SwiftData 저장, VoiceOver 및 iOS Dynamic Type의 동작 검증을 대신하지 않습니다. 프리뷰의 화면·상태 선택 도구는 디자인 검토용이며 실제 제품에 포함하지 않습니다.

HTML 파일을 브라우저에서 직접 열 수 있습니다. 로컬 서버로 확인하려면 이 폴더에서 다음 명령을 실행하고 `http://127.0.0.1:8784/design/preview/index.html`을 엽니다.

```sh
python3 -m http.server 8784 --bind 127.0.0.1
```

왼쪽에서 8개 화면과 빈 상태·오류 상태를 고르고 다크·큰 글자를 확인할 수 있습니다. 시작하기, 일정 옮기기, 다음 주 계획하기, 주간 메모는 로컬 예시로 동작합니다. `예시 초기화`는 이 프리뷰의 테스트 기록을 초기화합니다.

## 제품 범위

- 첫 버전: iPhone용 iOS 앱, 로컬 저장, 주간 계획, 알림, 실행 기록, Apple 캘린더 연동, 짧은 주간 메모.
- 후속 단계: Mac 앱과 기기 간 앱 데이터 동기화.
- 완료율 경쟁, 연속 일수 강요, 미완료를 실패로 다루는 표현은 사용하지 않습니다.

## 원본

- [기획서 Page](https://chatgpt.com/space/page_571917542e908191be1cf0ee1878de14)
- 사용자 첨부 프롬프트는 `design/reference/user-design-brief.txt`에 원문 그대로 보관했습니다.
