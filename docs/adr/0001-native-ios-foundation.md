# ADR 0001 — iPhone 네이티브 기반

상태: 채택 · 2026-10-04 · 이슈 #4

## 문제와 결정 근거

사용자는 iPhone 15 Pro를 기준으로 개발하고 기술 선택을 개발총괄에게 위임했다. 기획의 오프라인 저장·시스템 알림·Apple 캘린더·네이티브 접근성을 작은 코드베이스로 구현해야 한다.

최소 iOS 17.0, Swift 6 언어 모드, SwiftUI, Observation, SwiftData를 채택한다. 알림은 UserNotifications, 캘린더는 EventKit으로 구현한다. 외부 런타임 라이브러리와 서버는 추가하지 않는다. 후자의 두 연동은 기능 이슈에서 구현하며 이번 기반 단계에서는 권한을 요청하지 않는다.

iOS 17은 iPhone 15 Pro의 출시 시점 OS 계열이며 SwiftData와 Observation 기반을 사용할 수 있다. iOS 26으로 최소 버전을 올릴 기능상 이유가 없어 기기 업데이트를 강제하지 않는다. 사용하는 API가 iOS 17에서 가능한지 compiler availability로 검사한다. 실제 최저 OS 실행 검증은 별도이며 최신 시뮬레이터 성공으로 대체하지 않는다.

Flutter/React Native는 이 프로젝트에 필요한 네이티브 연동과 단일 iPhone 범위에 추가 계층을 만들므로 선택하지 않는다. Core Data는 지원 범위를 iOS 16 이하로 낮춰야 하거나 필수 저장·마이그레이션 검증을 SwiftData에서 충족하지 못할 때 재검토한다. 범용 Repository/UseCase/ViewModel을 모든 화면에 강제하지 않는다.

## 프로젝트와 데이터

- `Hanju/App`: 진입점과 탭 탐색. `Hanju/Persistence`: 앱 수명 저장소.
- `Hanju/Features`: Today, Week, Library, Records, Settings. 구현된 기능별 파일만 둔다.
- `Hanju/Models`: SwiftData 영속 모델. 첫 기반은 RoutineTemplate만 사용한다.
- `Hanju/Design`과 `Hanju/Assets.xcassets`: `design/tokens.json`의 실제 사용 값과 밝은/어두운 색상.
- `HanjuTests`: 저장 재열기, 오류·검증 등 동작 중심 단위 테스트. `HanjuUITests`: 등록·재실행·취소 동선의 네이티브 UI 테스트.
- `Hanju.xcodeproj`: 저장소에 포함하는 네이티브 프로젝트와 공유 Hanju scheme. 별도 프로젝트 생성 도구가 필요 없다.

SwiftData의 앱 수명 ModelContainer를 사용하고 CloudKit을 명시적으로 비활성화한다. 저장소 열기 실패는 재시도 가능한 오류 화면으로 표시한다. DB 삭제·묵시적 초기화·메모리 DB 대체로 오류를 숨기지 않는다. 사용자 저장은 명시적 save 성공 뒤에만 화면을 닫는다. 최초 V1 VersionedSchema를 고정하고 다음 모델 변경 때 기존 store fixture로 이전을 검증한다.

편집은 값 타입 draft에서 처리하고 입력 검증은 저장 경계에서 수행한다. 공용 모델·프로젝트 설정은 한 명만 수정한다. 이후 모델과 상태 계약은 [데이터 계약](../development/data-contracts.md)을 따른다.

## 지원과 검증

첫 대상은 개인 iPhone 15 Pro 설치다. TestFlight·App Store 배포, 유료 개발자 등록, 배포 인증서 생성은 이번 결정에 포함하지 않는다. bundle ID는 개발용 `com.siwony.hanju`이며 서명 팀은 기기 설치 시 확인한다. 개인 계정 정보는 저장소에 기록하지 않는다.

iPhone 세로·가로는 기본 적응형 SwiftUI 레이아웃으로 지원한다. iPad/Mac 제품 지원은 제외한다. 작은 화면·큰 글자·다크 모드·VoiceOver 검증을 기능마다 추가한다.

로컬 설치 확인: Xcode 26.6 (17F113), iOS 26.5 Simulator. 현재 전역 개발 디렉터리는 Command Line Tools이므로 필요할 때 `DEVELOPER_DIR`를 명령 범위에 지정한다. CI는 macOS 15 / Xcode 26.2에서 서명 없이 시뮬레이터 빌드·테스트한다. SDK 버전과 최소 지원 iOS는 다르다.

실제 기기의 iOS 버전·개발자 모드·서명은 연결 단계에서 확인한다. 로컬/CI 결과는 PR에 기록하고 실기기·최저 OS·접근성 미검증을 구분한다.

## 근거

- [Apple SwiftData](https://developer.apple.com/documentation/swiftdata)
- [EventKit 접근 권한](https://developer.apple.com/documentation/eventkit/accessing-the-event-store)
- [iPhone 15 Pro](https://support.apple.com/en-us/111829)
- [GitHub macOS 15 runner 도구 목록](https://github.com/actions/runner-images/blob/main/images/macos/macos-15-Readme.md)
