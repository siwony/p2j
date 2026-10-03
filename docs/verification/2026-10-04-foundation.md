# 네이티브 기반 검증

이슈 #4 · PR #14 · 2026-10-04. 전체 MVP 인수 결과가 아닌 기반 구현 검증이다.

## 환경

로컬 Xcode 26.6 (17F113), iOS Simulator SDK/런타임 26.5, iPhone 15 Pro Simulator, Hanju scheme, Swift 6 언어 모드, deployment target 17.0, 서명 비활성. 테스트 fixture는 임시 store 또는 UUID 이름의 시뮬레이터 데이터다. 실제 iPhone 개인 데이터는 사용하지 않았다.

## 결과

| 검증 | 결과 |
| --- | --- |
| plutil, 공유 scheme/project 조회, build, build-for-testing | 성공 |
| V1 디스크 store 저장/재열기·ID/선택값 보존 | 통과 |
| 메모리 store 간 격리 | 통과 |
| 저장 실패 주입→draft 보존→재시도 한 건 생성 | 통과 |
| 공백 이름 저장 거절 | 통과 |
| UI 이름 입력→저장 직후 목록→앱 종료/재실행 후 유지 | 통과 |
| UI 취소→계속 편집→입력 유지→변경 버리기→새 입력창 | 초기 실패 원인 수정 후 통과 |
| SwiftUI static audit | 10파일, high/medium/low 모두 0 |
| Git diff 공백 검사·CI YAML 구문 | 통과 |

UI 초기 실패는 iOS 26.5의 toolbar confirmation popover가 `.cancel` 역할 버튼을 생략해 ‘계속 편집’이 없던 문제다. 테스트 조건을 약화하지 않고 버튼을 명시적 동작으로 바꿨다. 수정 후 해당 UI 테스트 1개가 통과했다. 저장 UI 테스트와 단위 테스트 4개도 실제 시뮬레이터에서 통과했다.

명령은 `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild`에 `-project Hanju.xcodeproj -scheme Hanju`, 실제 Simulator ID, `CODE_SIGNING_ALLOWED=NO`를 지정해 수행했다. build-for-testing 후 test-without-building을 사용했다. 감사 명령은 `python3 .agents/skills/design-swiftui-interfaces/scripts/audit_swiftui_ui.py Hanju --profile standard --fail-on high`다.

GitHub macOS CI는 PR 최신 SHA에서 전체 6개 테스트를 다시 수행한다. 실제 run URL·성공 상태와 최신 SHA의 독립 리뷰는 PR 본문에 남긴다. 파일 작성만으로 CI 성공을 주장하지 않는다.

## 남은 인수

- iOS 17 실제 런타임·iPhone 15 Pro 실기기·서명은 미검증이다.
- VoiceOver 실제 조작, 최대 접근성 글자·작은 화면·가로·모션/투명도 감소 전체 조합은 #13에서 수행한다. 기본 화면/AX 관찰·정적 감사가 이를 대신하지 않는다.
- dirty swipe는 데이터 유실 없이 닫기를 막지만 시도 시 확인창은 아직 제공하지 않는다. #7에서 완료하며 AC-12 전체 완료로 표시하지 않는다.
- 루틴 전체 편집/보관, 주간 계획, 실행 타이머, 기록/메모, 알림, 캘린더는 후속 #7~#12 범위다.
