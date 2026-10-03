# 한 주 — Art Direction Review

2026-10-04 · 기존 디자인에 설치 스킬을 적용한 재검토. 대상은 iPhone 디자인·브라우저 프리뷰·개발 인계다. 네이티브 구현의 완료·출시 판정이 아니다.

## 결론과 판단 순서

**현재의 ‘정돈한 생활의 페이지’를 유지한다.** 차별화는 따뜻한 색 자체보다 다음 행동·요일 배치·실제 실행기록을 다르게 읽게 하는 화면 구조에서 나온다. 새 폰트·삽화·재질을 더할 필요는 없다. 이번 보완은 방향의 근거, 화면별 signature, 플랫폼 동작과 접근성의 경계를 명확히 하는 것이다.

우선순위는 제품 철학 → 아트디렉션 → 시각 위계·고유 정체성 → iOS 상호작용 → 구현 정확성 → 시뮬레이터 QA다. 접근성을 낮추는 시각적 타협은 하지 않는다. 날짜 이동·직접 완료·건너뛰기를 부차적인 실패 경로로 만들지 않는 것이 우선이다.

## 구조가 다른 세 방향 비교

세 안은 색상 교체안이 아니라 읽기 순서와 화면 밀도가 다른 후보다. 현재 방향의 적합성을 기존 제품 요구와 비교한다. 사용자의 최종 시각 디자인 승인과는 구분한다.

| 방향 | 주 화면의 골격 | 장점 | 이 제품에서의 비용 | 판정 |
| --- | --- | --- | --- | --- |
| A. 정돈한 생활의 페이지 | Today는 시작할 한 가지+예정 행, Week는 요일 선택+하루 목록, Records는 날짜별 장부 | 지금 할 행동과 한 주의 맥락을 함께 읽는다. 실행/조정/회고의 밀도를 각각 달리할 수 있다 | 화면별 정렬·간격을 의도적으로 유지해야 한다 | **유지**. 부담 없이 계획을 바꾸는 제품 태도와 가장 잘 맞는다 |
| B. 촘촘한 agenda | Today·Week 모두 시각 열을 선두에 둔 세로 일정표, 상태를 같은 행으로 압축 | 시간 지정 일정이 많을 때 빠르게 훑는다 | 요일만 정한 일·시간 미정 루틴도 시간표에 종속된다. 예정 시각 중심의 압박이 커질 수 있다 | 보류. 시간 미지정이 정상인 MVP의 기본 구도로 부적합 |
| C. 한 가지씩 보는 실행 중심 | Today에 한 루틴만 크게 표시, 나머지는 다음 카드/별도 목록; Week가 부가 탐색 | 시작 버튼과 첫 행동에 최대 집중 | 오늘의 전체 분량·완료·재배치를 한 번에 볼 수 없다. 전환과 숨은 탐색이 늘어난다 | 전체 방향에서는 제외. RunningRoutine의 집중 구도에만 원칙 일부 사용 |

세 안 모두 현재 semantic palette와 system type으로 표현할 수 있다. B·C를 과장된 색이나 애니메이션으로 더 좋아 보이게 비교하지 않는다. 이번 작업은 B·C의 고충실도 시안을 새로 제작하는 범위가 아니다.

## 8개 화면의 signature

‘120% 디테일’은 화면마다 장식 하나를 추가한다는 뜻으로 해석하지 않는다. 사용자가 반복해서 마주치는 구조 한 곳을 정확히 다듬는다.

| 화면 | 한 가지 signature | 구체적인 위계·구도 | 지켜야 할 경계 |
| --- | --- | --- | --- |
| Today | 시작할 한 가지와 나머지 목록의 대비 | 날짜/32pt 제목 아래 얇은 선, 24pt 루틴명·첫 행동·폭을 채운 시작 버튼. 나머지는 17pt 이름과 행 끝 action. 실행 중에는 단 하나의 accentSubtle 면으로 전환 | 당일 통계 hero 없음. 완료는 이름을 지우거나 흐리게 숨기지 않고 아래 섹션에 보존 |
| Week | 월–일을 가로로 고르고 하루를 세로로 읽기 | 주간 날짜범위 → 요일 strip → 선택 날짜와 남은 예상 → 단일열 agenda. 선택일은 면·윤곽·label로 고정 | 7열 시간표나 drag 전용 이동 금지. 좁으면 44pt 셀을 줄이지 않고 strip 내부만 스크롤 |
| Library | 분류를 표제로 읽는 루틴 목록 | 제목/추가 → text filter → 작은 분류 표제 → 이름과 시간·기본횟수. 모든 이름은 하나의 leading 축, 편집은 trailing 축 | 임의 category emoji·색상 아이콘 없음. 원본의 선택정보를 각 행에 전부 펼치지 않음 |
| Records | 날짜별 실행 장부에서 메모로 이어지는 흐름 | 주 범위 → 한 줄의 기록시간/미기록 → 날짜 표제와 들여쓴 완료행 → 실천 횟수 → 열린 자유메모 영역 | 완료율·그래프가 아닌 실제 행동. ‘시간 미기록’과 ‘1분 미만 기록’을 같은 작은 정보층에서 구분 |
| Settings | 기능과 사용 가능 상태를 가까이 놓기 | 알림 label/설명과 trailing toggle, 시간 설정은 아래, 캘린더 방향과 권한 설명은 해당 기능 옆. 마지막에 기기 저장 범위 | 브랜드 장식의 밀도가 가장 낮은 화면. ‘허용 안 됨’을 붉은 실패로 만들지 않음 |
| RoutineEditor | 이름을 먼저 쓰는 한 줄 | 취소/저장 아래 작업명 입력을 title 단계로 강조, 분류·예상시간은 divider 행, 추가 정보는 뒤의 별도 섹션 | 이름만으로 저장 가능. optional 항목이 필수 체크리스트처럼 보이지 않음 |
| Reschedule | 기존 계획에서 새 날짜로 옮기는 단순한 순서 | 루틴명/현재 날짜 → 옮길 날짜 → 선택 시각 → 한 개의 주 action → 중립적인 건너뛰기 | 이유 입력 없음. 취소는 호출한 화면·선택 맥락으로 복귀 |
| RunningRoutine | 한 축에 놓인 기록 시간과 실행 제어 | 루틴명·첫 행동 뒤 기록 시간만 display 44pt, 그 아래 정지/재개와 완료, 계획일·예상시간은 마지막. native 탭 유지 | 원형 타이머·남은 목표량·자동 경고 없음. 집중은 본문 위계로 만든다. 탭 이동이 타이머 종료를 의미하지 않음 |

수치는 Apple의 고정 배치 규격이 아니라 `tokens.json`의 제품 기준이다. screen title이 항상 가장 커야 한다는 일반 점검 항목은 RunningRoutine에 적용하지 않는다. 여기서는 기록 시간이 주된 내용이다.

## Anti-slop 5차원 리뷰

아래 판정은 **디자인 명세와 웹 시각 모델에 대한 정성 평가**다. 네이티브 코드·실기기 증거가 없는 상태에서 평균 점수, production 점수, 출시 가능 점수를 부여하지 않는다. 특히 스킬의 높은 점수에 붙은 ship-ready 의미를 이 산출물에 옮기지 않는다.

| 차원 | 명시적 판정 | 근거 | 남은 경계 |
| --- | --- | --- | --- |
| Philosophy Alignment | **방향 유지** | 자동 이월·점수·스트릭 대신 이동/건너뛰기/선택적 기록이 표면에 있다. 바탕·서체·문구가 같은 낮은 긴장도를 유지한다 | 본인 실사용에서 ‘다시 시작하기 편한가’는 아직 사용자 가설 |
| Visual Hierarchy | **시각 구조 적합** | Today의 큰 행동, Week의 날짜 탐색, Records의 날짜 구분이 서로 다르다. 면을 제거해도 제목·행·정렬로 grouping을 읽는다 | 접근성 최대 크기의 실제 iOS 읽기 순서 검증 필요 |
| Craft Quality | **문서·웹 증거 범위 적합** | semantic token, 9타입 역할, 제한된 radius, 상태 label, sub-minute/nil 구분. 부모의 기존 320px·큰 글자 QA 기록과 이번 화면 재관찰 근거 | 실제 SF Symbols rendering, OS의 Bold Text/Increase Contrast, safe area는 미검증 |
| Functionality | **발견 2건 수정·재검증 완료** | 주된 action은 보이고 local 예시는 연결되어 있다. 그러나 Reschedule 취소 복귀와 Running의 push/탭 표현에 불일치를 발견했다 | 아래 두 건은 웹 범위 확인. 실제 알림·캘린더·저장 성공 판정 아님 |
| Originality | **현재 구도 유지** | 8화면의 역할 차이, 이름부터 입력, 요일선택+하루 agenda, 평가 없는 실행 장부가 제품을 설명한다. 금지 gradient/card stack/장식 이미지 없음 | 숲빛 색 하나만으로 독창적이라고 주장하지 않는다. 추가 장식은 필요하지 않음 |

서체·색·간격의 절제가 템플릿을 피하는 유일한 증거는 아니다. ‘무엇을 강조하지 않았는지’가 상태 규칙과 연결되어야 한다. 완료 비율을 제거한 자리를 큰 칭찬 문구나 다른 지표로 채우지 않는다. 계획 선택 시 이전 메모 옆의 가는 선은 인용 구분이며, 색 띠가 달린 둥근 카드의 반복 패턴과 구분한다.

## HIG 8원칙 리뷰

원칙 순서는 `apple-design/references/principles.md`를 따른다. conforms는 **해당 설계 원칙과 정합**이라는 뜻이다. native QA 통과 의미가 아니다.

| 원칙 | Verdict | 이 제품에서의 근거·발견 |
| --- | --- | --- |
| 1. Purpose | **conforms · 설계 범위** | 루틴 선택→실행→조정에 화면을 집중한다. Mac·동기화·보상·복잡한 통계를 첫 버전에 넣지 않는다 |
| 2. Agency | **conforms · 설계 범위** | 직접 완료, 이유 없는 이동·skip, 완료 취소, 선택적 메모를 제공한다. 다음 주는 명시적 선택으로만 만든다. 타이머 없이도 완료가 가능하다 |
| 3. Responsibility | **conforms · 명세 범위** | 기기 저장과 앱→캘린더 방향을 설명한다. 메모·실제시간은 export하지 않는다. 미허용/부분실패/외부변경을 분리한다. 실제 권한·보존·export는 미구현 |
| 4. Familiarity | **conforms · 발견 2건 수정 후 웹 검증** | Today/Week에서 연 Reschedule 취소가 호출자·선택 날짜·버튼 focus로 복귀한다. Running에서 Today 탭 선택 상태와 5탭이 유지되며 탭 전환 후에도 실행이 이어짐을 감독이 확인 |
| 5. Flexibility | **conforms · 디자인 계약, 검증은 제한적** | 큰 글자에서 행 확장, tap 날짜 이동, 상태 label, light/dark token, Reduce Motion 규칙. 웹 1.28배 검토로 VoiceOver와 최대 Dynamic Type 통과를 주장하지 않음 |
| 6. Simplicity | **conforms · 설계 범위** | 카드 장식을 없애도 충분한 일상 정보가 남는다. 이름만 등록 가능, 옵션은 뒤에 배치, 주간/실제 시간 분리. 간결함을 정보 삭제로 만들지 않음 |
| 7. Craft | **conforms · 반복 검토 과정** | 토큰 불일치·44pt 영역·선택일 가시성·sub-minute 표현을 이전 감독 QA로 수정했다. 이번에도 route 불일치를 구체적으로 좁혀 수정한다. 네이티브 완성도는 미판정 |
| 8. Delight | **conforms · 제품 태도** | 날짜를 바꾸거나 한 주를 쉬어도 손해가 쌓이지 않는 경험이 감정적 보상이다. 이를 confetti·칭찬 hero·반복 animation으로 대체하지 않는다 |

## 발견과 변경 책임

| 발견 | 결정 | 이번 리뷰 종료 시 상태 |
| --- | --- | --- |
| `reschedulecancel`이 호출자를 보존하지 않고 항상 Week로 이동 | Today/Week의 호출 맥락을 보존하고 취소로 변경 draft만 버림 | 부모 수정·브라우저 재검증 완료 |
| Running의 명세는 NavigationStack push, 프리뷰는 탭 숨김 | 기존 push 유지 + native TabView 유지. 타 탭으로 가도 실행 상태 보존. 별도 full-screen modal 추가 안 함 | 부모 수정·브라우저 재검증 완료 |
| Direction의 ‘권한 문제’가 destructive 범위로 읽힐 수 있음 | 미허용은 중립, 저장 실패·실제 삭제는 구분 | `01-direction.md` 문구 수정 완료 |
| 유리 효과 금지와 OS navigation material의 범위가 모호함 | 콘텐츠 장식 효과 금지, OS 기본 navigation/control 재질은 수용 | `01-direction.md`, `02-foundations.md` 명확화 완료 |

부모가 앞의 두 건을 검증한 뒤 이 표와 Familiarity 판정을 보정했다. 본 재검토 에이전트는 `preview/index.html`, `04-screens.md`, `05-swiftui-handoff.md`를 수정하지 않았다.

## 브랜드 선택·접근성·구현의 경계

- 스킬의 세리프/두 폰트/여러 브랜드색 권고를 따르기 위해 현재의 한국어 system font와 단일 accent를 바꾸지 않는다. 기존 디자인 시스템이 있으므로 외부 브랜드 asset 수집이나 새 brand-spec 파일을 만들 필요가 없다.
- 스킬의 8pt 권고보다 사용자의 4pt 기반 토큰을 우선한다. 이는 임의 간격을 허용한다는 뜻이 아니다. 12pt도 명명된 관계 간격으로 유지한다.
- 다섯 목적지와 Settings 탭은 현재 명세의 정보구조다. 스킬의 일반적인 ‘Settings를 탭에서 빼라’ 권고만으로 변경하지 않는다. 사용 빈도를 실제로 관찰한 뒤 변경할 문제다.
- 콘텐츠는 불투명 semantic 면을 사용한다. OS의 TabView/toolbar 재질은 운영체제가 관리한다. glass를 앱 전체에 직접 적용하거나, 브랜드를 보존한다는 이유로 OS navigation을 전부 다시 그리지 않는다.
- 44pt 버튼, 본문 17pt, 텍스트 크기별 대비 권고는 Apple Accessibility/Buttons 참조에 근거한다. 4.5:1을 모든 글자에 적용하는 목표와 의미 있는 비텍스트 3:1은 이 제품이 명시한 검증 기준이다. 스킬의 간략 대비 표로 기존 기준을 낮추지 않는다.
- 충분한 대비를 가진 custom color라도 Increase Contrast·Bold Text·Reduce Transparency 반응을 검토해야 한다. 현재값을 줄이는 변경 없이 기존 textPrimary/borderStrong로 가독성을 높이는 방향을 명세했다. 새 값이 필요하면 `tokens.json`부터 변경한다.
- 폰트·색·레이아웃 명세가 실제 Dynamic Type·VoiceOver 동작을 자동 보장하지 않는다. UI가 커질 때 ‘다른 날’과 ‘건너뛰기’가 화면 밖으로 영구히 사라지지 않아야 한다. 시간 제한 toast 이후에도 영속적인 수정 경로를 둔다.
- 단순 기능 심볼을 나타내는 웹 vector는 대체 자산이다. SF Symbols 공식 자산으로 오인하거나 제품 로고로 사용하지 않는다. 실제 앱에서 system symbol과 native control로 대응한다.

## 읽은 자료와 검토 증거

적용한 정확한 스킬:

- `/Users/jeongcool/me/ptoj/.agents/skills/swiftui-design-skill/SKILL.md`
- `/Users/jeongcool/me/ptoj/.agents/skills/apple-design/SKILL.md`

읽은 관련 reference:

- swiftui-design-skill: `references/anti-ai-slop.md`, `references/design-review.md`, `references/layout-patterns.md`, `references/typography-color.md`.
- apple-design: `references/principles.md`, `references/platforms.md`, `references/accessibility.md`, `references/layout.md`, `references/components.md`, `references/materials-color.md`, `references/typography-symbols.md`, `references/patterns-gestures.md`.

공식 근거: [Design principles](https://developer.apple.com/design/human-interface-guidelines/design-principles), [iOS](https://developer.apple.com/design/human-interface-guidelines/designing-for-ios), [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility), [Layout](https://developer.apple.com/design/human-interface-guidelines/layout), [Buttons](https://developer.apple.com/design/human-interface-guidelines/buttons), [Tab bars](https://developer.apple.com/design/human-interface-guidelines/tab-bars), [Materials](https://developer.apple.com/design/human-interface-guidelines/materials), [Typography](https://developer.apple.com/design/human-interface-guidelines/typography). 이번 검토는 설치 스킬의 해당 원문 요약과 프로젝트 증거를 읽어 적용했다. 새로운 OS/API 호환성 조사를 수행한 것은 아니다.

기존 증거는 `docs/design-review.md`의 감독 브라우저 QA와 `contrast-report.json`이다. 이번에 로컬 프리뷰의 Today, Week, Library, Records, Settings, RoutineEditor, Reschedule와 Running 빈 상태를 스크린샷·접근성 트리로 다시 관찰했다. 실행 중 화면의 명세는 기존 감독 증거와 문서에 근거하며 이 재검토에서 새 실행기록을 만들지 않았다. 수치 대비나 320px 측정을 새로 수행했다고 표시하지 않는다. 실제 Xcode 빌드·시뮬레이터·실기기 검증은 이번 평가에 포함하지 않는다.

감독 보정: 취소 동작은 수정 전 재현 후 Today와 Week 각각에서 복귀·버튼 focus를 확인했다. Running의 5탭 표시·Today 선택, Settings 왕복 후 시간 유지, 320px·다크·1.28배 글자에서 본문 가로 넘침 없음과 표시된 조작 영역 44px 이상을 확인했다. 이 추가 증거도 웹 프리뷰 범위다.
