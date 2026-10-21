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

## PR 검사와 전체 회귀

관련 이슈: #44. PR의 필수 검사 이름은 `iOS build and tests`다. 앱을 빌드하고 모든 `HanjuTests`를 실행하되, UI 테스트는 변경 경로의 영향 범위로 선택한다. 여러 영역을 변경하면 대상의 합집합을 실행한다. 문서·Graphify만 바뀐 경우에는 native 검증 불필요를 명시하며, 필수 job은 항상 결과를 반환한다.

| 변경 영역 | PR의 UI 테스트 |
| --- | --- |
| Settings | Notification, Records |
| Today, Week, Execution | Execution, WeekPlan, Records |
| RecordsView.swift | Records |
| Records의 나머지 파일 | Records, WeekPlan, Execution |
| Library | RoutineLibrary, WeekPlan, Execution, Records |
| 기존 UI 테스트 파일 | 해당 클래스 |
| 단위 테스트만 변경, iOS workflow·선택기 자체 변경 | 없음. 모든 단위 테스트와 선택기 검증 수행 |
| App, Models, Persistence, Design, Assets, 프로젝트, Notifications 서비스 | 전체 UI |
| native 삭제·이름 변경, 알 수 없는 native/build 경로·UI 클래스 | 전체 UI |

표의 이름은 `HanjuUITests`의 `*UITests` 클래스다. Library의 루틴 생성과 Week의 계획 준비는 다른 화면 테스트에서도 사용하므로 해당 폴더 하나로만 제한하지 않는다. 공용 코드나 선택 근거가 불완전한 경우에는 전체 검사를 유지한다. 선택기의 정확한 경로 규칙과 self-check는 `.github/scripts/ios-test-plan.cjs`, `.github/scripts/ios-test-plan.test.cjs`에서 관리한다.

변경 목록은 전체 이력을 checkout한 Git의 완전한 diff로 구한다. PR은 base/head의 merge base, main push는 before/after를 비교한다. 이름 변경은 이전 경로의 삭제와 새 경로의 추가로 처리한다. SHA·diff·상태를 읽지 못한 경우를 문서 변경으로 간주하지 않는다. 선택된 테스트의 고정 identifier를 `-only-testing` 인자로 전달하고 실제 결과에서 선택 suite와 실행 사례가 존재하는지 확인한다.

`main` push에서는 별도 `iOS full regression`으로 전체 회귀를 실행한다. 문서·Graphify 전용 push는 명시적으로 native 검증을 건너뛴다. 전체 회귀는 PR 병합을 기다리게 하는 필수 검사가 아니며, 새 PR이나 다음 push가 이전 전체 회귀를 취소하지 않는다. Actions 요약과 결과물에서 event, PR head와 실제 checkout SHA, 실행 모드·대상·결과를 구분한다. 문서 전용 skip의 SUCCESS는 전체 테스트 통과가 아니다.

수동 전체 회귀와 최근 main 실행 조회:

```sh
gh workflow run ios.yml --repo siwony/p2j --ref main
gh run list --repo siwony/p2j --workflow ios.yml --event push --branch main --limit 10
gh run view <실행 ID> --repo siwony/p2j
```

실패·취소·timeout·결과 없음은 성공으로 보고하지 않는다. 작업 재개와 다음 병합 전의 확인·실패 처리 기준은 [리뷰 워크플로우](review-workflow.md)를 따른다. iOS 최소 버전 컴파일 검사는 실제 iOS 17 런타임 검증과 다르다.

구현 근거: [Apple 선택 테스트 identifier](https://developer.apple.com/library/archive/technotes/tn2339/_index.html), [checkout의 전체 이력 옵션](https://github.com/actions/checkout), [GitHub concurrency의 실행·대기 취소 규칙](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/control-workflow-concurrency).
