# 한 주 — 네이티브 경험과 검증 계약

2026-10-04. 디자인·개발 인계 기준. 현재 저장소에 네이티브 앱 구현은 없다.

아래는 후속 native 구현의 계약이다. 웹 프리뷰는 주요 흐름의 예시이며, 변경된 draft의 공통 폐기 확인, 탭별 native stack 복원, OS 접근성 반응, 저장 command 재진입 방지까지 모두 구현한 것은 아니다. 프리뷰가 제공하는 증거 범위는 `docs/design-review.md`에서 구분한다.

## 우선순위와 스킬의 책임

판단 순서는 **제품 철학 → 아트 디렉션 → 시각 위계와 고유 정체성 → 네이티브 iOS 인터랙션 → 구현 정확성 → 시뮬레이터 기반 시각 QA**다. 이는 의사결정의 순서다. 뒤에 있는 구현·접근성·검증을 생략해도 된다는 뜻은 아니다.

| 스킬 | 이 프로젝트에서 맡는 판단 | 다른 영역과의 경계 |
| --- | --- | --- |
| [swiftui-design-skill](../.agents/skills/swiftui-design-skill/SKILL.md) | 구도, 서체 위계, 간격, 고유한 화면 구성, 불필요한 장식 검토 | 예시의 세리프나 8pt 권고가 사용자 지침과 기존 토큰을 대체하지 않는다 |
| [apple-design](../.agents/skills/apple-design/SKILL.md) | iPhone 탐색·시트·취소·입력·권한·시스템 관례 | HIG 정합을 이유로 모든 화면을 기본 Form의 동일한 모습으로 바꾸지 않는다 |
| [swiftui-pro](../.agents/skills/swiftui-pro/SKILL.md) | 상태 소유, SwiftUI API, 모델·뷰 경계, 동시성, 유지보수 | 디자인을 기본 파란색·기본 글자 크기로 환원하지 않는다. 모델 수명과 상태를 먼저 정확히 구현한다 |
| [design-swiftui-interfaces](../.agents/skills/design-swiftui-interfaces/SKILL.md) | 인터랙션 안정성, 모션, 접근성 대안, 시각·런타임 증거 | 장식 효과나 점수로 빌드·실제 조작 검증을 대신하지 않는다 |

프로필은 **standard**다. 짧은 생활 행동을 시작하고, 일정을 바꾸거나 쉬어도 다시 돌아오기 편한 감정을 목표로 한다. ‘정돈한 생활의 페이지’라는 현재 방향을 유지한다. 구조 비교와 화면별 고유 요소는 [아트 디렉션 검토](06-art-direction-review.md)를 따른다.

콘텐츠는 불투명 중성 배경, 숲빛 강조색, 선과 여백의 위계를 유지한다. 시스템 바·메뉴·시트의 현재 OS 표현은 시스템 컴포넌트에 맡긴다. 콘텐츠 카드에 커스텀 유리 효과를 추가하지 않는다. 한국어 시스템 서체와 4pt 기반 간격 토큰은 제품 결정이며, 스킬의 취향 예시와 절충해 바꾸지 않는다.

## 지원 환경과 소유권

- 첫 대상은 iPhone 터치 사용. 세로를 기준으로 설계하고 가로·키보드 표시·하드웨어 키보드 및 접근성 입력에서도 주요 동작에 접근 가능하게 한다.
- 최소 지원 OS는 아직 프로젝트 설정으로 확정하지 않았다. `swiftui-pro`의 새 앱 기본 제안인 iOS 26 / Swift 6.2 이상을 개발 착수안으로 두고, 실제 SDK와 지원 기기를 확인해 확정한다. 웹 프리뷰의 폭은 OS 지원 목록이 아니다.
- 앱이 소유하는 한 개의 실행 기록기가 현재 실행을 관리한다. Running 화면을 닫거나 탭을 바꿔도 시간이 유지된다. 화면 타이머는 표시 갱신만 담당한다.
- 루틴·회차·기록·주간 메모는 로컬 영속 데이터가 원천이다. 원본 수정은 과거 회차 snapshot을 바꾸지 않는다.
- 각 탭의 navigation path와 선택 날짜는 해당 탐색 상태가 소유한다. 실행 상태와 navigation 상태를 같은 boolean으로 제어하지 않는다.
- 편집·주간 선택·일정 이동은 시트별 draft가 소유한다. 활성 sheet는 대상 ID를 가진 enum 하나로 표현한다. 저장 중/성공/실패를 구분하며 실패 시 draft를 유지한다.
- 권한은 OS 조회 결과가 원천이다. 앱에 저장한 허용 boolean으로 대체하지 않는다. 캘린더 반영 상태는 권한과 별도다.

## 탐색과 취소

| 출발 → 도착 | 표현 | 취소·돌아가기 | 확정 이후 |
| --- | --- | --- | --- |
| Today → Running | Today stack의 push, TabView 유지 | back/탭 전환은 실행 유지 | 완료 저장 후 Today로 복귀 |
| Library → RoutineEditor | 대상이 있는 native sheet | 호출자 복원. 변경 draft는 아래 공통 규칙 적용 | 저장 성공 후 Library 갱신 |
| Today/Week → Reschedule | native sheet | 원래 탭·주·날짜·스크롤 유지 | 저장 성공 후 대상 날짜 Week agenda를 보여줌 |
| 완료행 → Completion | native sheet | 이미 저장된 완료 결과 유지 | 수정 저장 또는 완료 취소 반영 |
| Week/Settings → Calendar | native sheet | 호출자 복원. 반영 중이면 작업 상태 보존 | 성공/부분 실패/외부 변경을 구분해 표시 |
| Today/Records → 다음 주 계획 | 대상 주를 명시한 Week + 선택 sheet | 후보 draft 폐기 시 기존 계획 유지 | 선택한 회차만 한 번 생성 |

편집된 draft가 있는 시트를 취소하거나 swipe로 닫으려 할 때는 동일한 ‘계속 편집 / 변경 버리기’ 선택을 사용한다. 변경이 없으면 바로 닫는다. 짧은 확인에는 해당 시트를 여는 중첩 sheet 대신 시스템 confirmation dialog를 사용한다. 선택적 메모는 별도 저장 버튼 없이 자동 저장하며 이 확인 흐름에 포함하지 않는다.

저장 중인 확정 버튼의 반복 입력은 같은 command를 중복 실행하지 않는다. 화면 비활성화보다 저장 단계의 재진입 방지가 우선이다. 실패하면 버튼을 다시 사용할 수 있고, 같은 draft로 재시도한다. 이는 주간 회차 중복 생성과 캘린더 중복 반영을 막는 기능 조건이다.

## 모션 계약

시스템 push/sheet는 시스템 전환과 접근성 대안을 사용한다. 제품 모션 토큰은 커스텀 상태 표현에만 적용한다. 반복 타이머 숫자, 메모 저장, 매초의 시간 변화에는 주의를 끄는 모션이나 햅틱을 넣지 않는다.

| 트리거 | 시작 → 진행 → 정착 | 중단·반전·취소 | Reduce Motion |
| --- | --- | --- | --- |
| 루틴 시작 | 예정행 → 저장 성공 → Running push | 저장 실패는 출발 화면 유지. push 중 back은 실행 종료가 아님 | 시스템 대안; 추가 zoom 없음 |
| 일시 정지/재개 | 실행 중 ↔ 일시 정지 label와 제어 교체 | 하나의 기록기 상태만 변경. 연속 입력에도 interval 중복 없음 | 즉시 label 변경 |
| 완료 | 기록 저장 → 완료행 표시 | 저장 실패는 시간·제어 유지. 완료 취소로 되돌릴 수 있음 | 즉시 갱신 또는 짧은 fade |
| 요일 선택 | 선택 날짜 → agenda 교체 | 다음 선택은 이전 전환을 대체. 선택요일만 strip 안으로 이동 | 즉시 교체·즉시 내부 스크롤 |
| 일정 이동 | draft → 저장 → 대상 날짜 강조 | 취소는 호출자 복원. 성공 후 다른 주로 이동했음을 날짜로 알림 | 즉시 갱신, 텍스트 피드백 유지 |
| 시트 열기/닫기 | 호출 제어 → 시스템 presentation → 편집 | swipe 취소 시 입력 유지, 확정 시 종료. 완료 콜백은 최신 route만 갱신 | 시스템 대안 |

커스텀 애니메이션은 좁은 subtree의 상태 값 또는 명시적 transaction에 연결한다. 지연 시간으로 저장·화면 전환을 동기화하지 않는다. 기본 프로필에는 커스텀 drag, parallax, shader, 지속 ambient animation이 필요하지 않다.

## 접근성의 실제 동작

| 설정·입력 | 유지해야 할 동작 |
| --- | --- |
| Dynamic Type / Bold Text | 토큰 역할을 상대 text style에 연결. 자연 행 높이, 큰 크기에서는 가로 action을 세로로 전환. 루틴 이름·완료·취소를 축소/잘라내지 않음 |
| VoiceOver / Voice Control | 의미 있는 Button·Toggle·Label 사용. 아이콘에도 동작 이름 제공. 제목·상태·예상/실제 시간을 구분해 읽고 타이머는 매초 자동 announce하지 않음 |
| focus / 키보드 | 시트 진입 후 제목 또는 첫 입력, 오류 후 해당 입력, 닫은 후 호출 제어로 복귀. 키보드가 저장·취소를 가리지 않음 |
| Reduce Motion | 장식 이동·확대 제거. 상태 label, 직접 제어, 저장 결과를 유지 |
| Reduce Transparency | 콘텐츠는 기존 불투명 surface 유지. 시스템 chrome 대안 확인. 커스텀 투명 영역이 생기면 의미가 같은 불투명 surface 제공 |
| Increase Contrast | 의미 있는 경계는 borderStrong 이상으로 식별. 강조·선택·비활성 글자의 대비를 각 배경에서 재검토. 장식 separator에 조작 의미를 맡기지 않음 |
| Differentiate Without Color | 선택 테두리+상태 label, 완료 check+문구, 일시 정지 문구. 분류·성공·실패를 색 하나로만 구분하지 않음 |

글자 크기는 [ScaledMetric](https://developer.apple.com/documentation/swiftui/scaledmetric) 같은 상대 크기 대응을 통해 기존 위계를 보존한다. 검증은 기본 크기뿐 아니라 가장 큰 접근성 크기까지 포함한다. [Apple Larger Text 평가 기준](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/larger-text-evaluation-criteria).

## SwiftUI 구현 기준

- UI 모델은 Observation과 명시적 소유권을 사용한다. UI 상태의 actor 격리를 확인하고, 로컬 상태는 private `@State`, 전달받는 편집 상태는 binding으로 구성한다. 실제 저장 모델의 수명을 화면 생성에 묶지 않는다. [Apple 모델 데이터 가이드](https://developer.apple.com/documentation/SwiftUI/Managing-model-data-in-your-app).
- Tab 선택과 navigation destination은 타입으로 구분한다. enum과 안정적인 모델 ID를 사용하며 view 생성 중 ID를 새로 만들지 않는다. 대상이 있는 sheet는 `sheet(item:)`을 우선한다.
- body는 배치에 집중하고 저장·기록·알림·캘린더 command는 메서드/서비스로 분리한다. 화면마다 의무적으로 별도 계층을 늘리지 않는다. 새 Swift 타입은 역할별 파일에 둔다.
- 실제 타깃과 SDK에서 확인한 API만 사용한다. 최신 스킬 예시는 API 가용성 증거가 아니다. 낯선 API는 설치 SDK 또는 Apple 문서 확인 후 최소 사용 예를 컴파일한다.
- 핵심 로직의 검증은 기록 interval·주간 날짜·중복 command·snapshot·외부 캘린더 변경에 집중한다. 토큰 상수를 그대로 비교하는 형식적 테스트를 늘리지 않는다.
- 매초 tick은 타이머 표시 영역만 갱신한다. body에서 영속 저장, 전체 기록 정렬, 캘린더 조회를 실행하지 않는다. 앱 재진입은 timestamp에서 복원한다.
- 외부 라이브러리·서버·계정·CloudKit은 이 디자인 인계의 필요 범위가 아니다.

## 시뮬레이터·실기기 검증 게이트

첫 native 실행 전에 scheme, Xcode/SDK 버전, Simulator runtime, 기기명, OS, 지원 orientation을 기록한다. 화면 캡처마다 기본/최대 접근성 글자, appearance, 데이터 상태를 함께 명시한다.

1. 실제 scheme의 Simulator build와 핵심 domain tests.
2. 지원하는 가장 작은 iPhone·대표 크기·큰 크기에서 8화면. 세로/가로와 키보드 표시 확인.
3. light/dark/increased contrast × 기본/최대 접근성 글자. 긴 이름·빈 목록·loading·저장 실패·권한 거절 확인.
4. 빠른 시작/완료/계획 확정 연타, push 도중 back, 시트 swipe 취소, 시트 재진입, 실행 중 다른 탭, background/foreground 확인.
5. VoiceOver로 계획 선택→시작→완료→기록 수정. Reduce Motion/Transparency 및 Differentiate Without Color 상태에서 같은 작업 완료.
6. 안정적인 ID와 view 수명, offscreen tick, 주간 목록 스크롤을 점검. 성능 문제나 큰 커스텀 모션을 추가한 경우 Instruments로 해당 경로 측정.
7. 실제 알림 전달과 햅틱 등 Simulator가 충분히 증명하지 못하는 부분은 iPhone에서 확인.

보조기술을 해당 Simulator/도구에서 검증할 수 없으면 실기기 결과를 추가한다. 시각 캡처를 보조기술 통과로 기록하지 않는다. 현재 한국어 화면의 LTR을 기준으로 하고 RTL은 데이터·배치 스트레스 프리뷰에서 확인한다. RTL 언어 지원 출시를 의미하지 않는다.

정적 검사 경로는 설치된 프로젝트 스킬의 실제 경로를 사용한다.

```sh
python3 .agents/skills/design-swiftui-interfaces/scripts/audit_swiftui_ui.py <실제-Swift-프로젝트-경로> --profile standard --fail-on high
```

## 현재 증거와 Apple Fidelity

이번 확인: `xcodebuild -version`은 활성 CommandLineTools 경로 때문에 실패. `xcrun swift --version`은 Swift 6.1.2 macOS 대상. `xcrun simctl list devices available`은 simctl을 찾지 못함. 정적 검사도 저장소에 Swift 파일이 없어 종료 코드 2를 반환했다. 네이티브 빌드나 시뮬레이터 테스트를 수행한 것으로 기록하지 않는다.

**Apple Fidelity 점수: 산정하지 않음.** 구현 없는 디자인 제안에는 점수를 부여하지 않는 스킬의 evidence cap을 적용한다.

| 평가 영역 | 배점 | 현재 증거 상태 |
| --- | ---: | --- |
| 플랫폼 정합 | 15 | 탐색 명세·웹 예시 검토, native 미검증 |
| 정보 구조·배치 | 15 | 기존 웹 8화면 검토, native 최대 글자 미검증 |
| 의미·시각 시스템 | 15 | 토큰·컴포넌트 정의, SwiftUI 구현 없음 |
| 인터랙션 연속성·정확성 | 20 | 웹 핵심 흐름 및 취소 경로 검토, native 연타·취소 미검증 |
| 모션·소재 | 15 | standard 계약 작성, runtime 미검증 |
| 접근성·적응 | 10 | 대비 계산·웹 큰 글자, iOS 보조기술 미검증 |
| 성능·구현 품질 | 10 | 앱 빌드·Instruments 증거 없음 |

후속 구현은 적용되는 hard gate를 모두 통과하고 증거를 갖춘 후 점수를 산정한다. 90점 목표는 native 완료 판정에 사용하며 디자인 인계 완료와 구분한다.
