# 로컬 빌드와 실행

프로젝트: `Hanju.xcodeproj` · 공유 scheme: `Hanju` · 최소 iOS: 17 · Swift 언어 모드: 6.

Xcode에서 프로젝트를 열고 Hanju scheme과 iPhone Simulator를 선택하여 실행한다. Simulator는 Apple 계정이나 서명 인증서 없이 실행할 수 있다.

기본 개발 디렉터리가 Command Line Tools이면 Xcode → Settings → Locations → Command Line Tools에서 설치한 Xcode를 선택한다. 변경 전에도 명령마다 다음처럼 경로를 지정할 수 있다.

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -list -project Hanju.xcodeproj
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl list devices available
```

목록에서 실제 Simulator ID를 선택해 빌드·테스트한다. 기기 ID는 Mac마다 다르므로 저장소에 고정하지 않는다.

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild test \
  -project Hanju.xcodeproj -scheme Hanju \
  -destination 'platform=iOS Simulator,id=<목록의 기기 ID>' \
  -derivedDataPath DerivedData CODE_SIGNING_ALLOWED=NO
```

실제 iPhone 15 Pro 설치는 연결된 기기의 iOS와 개발자 모드, Xcode의 개인 Team을 확인한 뒤 진행한다. 인증서·계정·개인 provisioning 설정은 커밋하지 않는다. 현재 개발용 bundle ID는 `com.siwony.hanju`다.

CI의 `iOS build and tests`는 앱·테스트·프로젝트·iOS workflow 변경에만 빌드·테스트하고 문서만 바뀌면 명시적으로 건너뛴다. job 자체는 항상 결과를 반환하여 문서 PR의 필수 검사가 대기 상태에 남지 않게 한다. iOS 최소 버전 컴파일 검사는 실제 iOS 17 런타임 검증과 다르다.
