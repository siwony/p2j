# 한 주 — Foundations

2026-10-04 · 모든 값의 구현 기준은 `design/tokens.json`이다. 문서와 프리뷰는 이 파일을 따른다.

## Color

| Token | Light | Dark | 사용 |
| --- | --- | --- | --- |
| background | #F6F5F0 | #191E1B | 화면 전체 |
| surface | #FCFBF8 | #222924 | 입력, 제한적인 영역 구분 |
| surfaceRaised | #FFFFFF | #2A332C | 시트·상위 presentation |
| textPrimary | #252C28 | #EBEFE6 | 제목·본문 |
| textSecondary | #58625B | #B8C3B8 | 날짜·시간·보조정보 |
| textTertiary | #687168 | #9AA99C | 메타·힌트. 필수정보를 숨기는 용도 금지 |
| separator | #D8DDD5 | #3C473E | 장식적인 행 구분. 컨트롤 윤곽 대체 금지 |
| borderStrong | #7F8B7C | #6E8171 | 입력·선택 control의 의미 있는 윤곽 |
| accent | #3F6552 | #ABD0B0 | 주 행동, 선택 상태 |
| accentSubtle | #E6EDE5 | #303F33 | 실행 중 영역·선택 배경 |
| onAccent | #FFFDF8 | #172A1D | accent 단색 버튼의 전경 |
| success | #42634B | #ACCEAE | 완료 체크와 ‘완료’ 텍스트 |
| warning | #865C24 | #E8C18A | 복구가 필요한 안내 |
| destructive | #A33E33 | #F0ADA1 | 삭제·저장 실패 |
| calendar | #536A7D | #A9C5D8 | 캘린더 반영 상태 |
| paused | #746342 | #D7C398 | ‘일시 정지’ 표기 |

상태 텍스트는 일반 면 위에서 쓴다. warning/destructive 색으로 넓은 배경을 채우지 않는다. `accentSubtle` 위에는 textPrimary, textSecondary, accent만 사용하고 그 조합도 검증한다. disabled는 불투명도만 줄이지 않고 textTertiary + 명시적 비활성 의미로 전달한다. focus outline은 accent, 선택 윤곽은 accent 또는 borderStrong이다.

**대비 목표:** 일반 텍스트 4.5:1 이상, 큰 텍스트 3:1 이상, 의미 있는 컨트롤 경계·아이콘 3:1 이상. 9개 서체 단계 전부 가능한 한 4.5:1을 지킨다. separator는 장식이므로 대비로 상태를 전달하지 않는다. 실제 비율은 tokens와 함께 계산한 `design/contrast-report.json`에 기록한다. 색상 수치는 구현 가능 값이며 실제 디스플레이, 색상 대비 증가, VoiceOver 검증은 네이티브 단계에서 별도 수행한다.

## Typography

폰트는 SF Pro / iOS system. 한글은 OS의 한국어 시스템 대체 글꼴을 그대로 사용한다. 웹 프리뷰도 `-apple-system` 계열이며 Apple 폰트 파일을 배포하지 않는다. 글자 간격은 기본값(0). 대문자 자간 스타일을 한국어 UI에 적용하지 않는다.

| Token | 기본 pt | Weight | 목표 line height | 위치 | Dynamic Type 기준 |
| --- | ---: | --- | ---: | --- | --- |
| display | 44 | regular | 52 | RunningRoutine의 기록 시간에만 | largeTitle |
| largeTitle | 32 | semibold | 40 | Today·Records의 화면 제목 | largeTitle |
| title | 24 | semibold | 32 | 시트 제목·루틴 실행명 | title2 |
| sectionTitle | 18 | semibold | 26 | 섹션명·강조 날짜 | headline |
| body | 17 | regular | 26 | 본문·목록 이름·입력 | body |
| bodyEmphasis | 17 | semibold | 26 | 주 행동·현재 루틴 이름 | body |
| secondary | 15 | regular | 22 | 시간·설명·보조 행동 | subheadline |
| caption | 13 | medium | 20 | 상태와 일자 범위 | footnote |
| meta | 12 | medium | 18 | preview 외 메타·가벼운 분류 | caption1 |

SwiftUI에서는 semantic text style 또는 해당 style에 상대적인 scaled metric을 사용한다. line height는 기본 크기에서의 시각적 목표이며 고정 `frame(height:)`로 강제하지 않는다. 텍스트는 intrinsic height로 확장하고 줄간격 보정이 필요하면 양의 lineSpacing을 제한적으로 쓴다. Dynamic Type accessibility 크기에서 행의 우측 action은 아래로 이동하고 제목·시간·버튼을 세로로 배열한다. 이름은 최대 2줄에 묶지 않고 필요한 만큼 표시한다. 요일 셀은 가로 스크롤, 설정 label은 multiline. 시간과 날짜의 수치 부분에만 `monospacedDigit`을 사용한다. 글자를 줄여서 맞추지 않는다.

## Spacing & Layout

4pt 격자. 값의 의미를 재사용한다.

| Token | pt | 의미 |
| --- | ---: | --- |
| xs | 4 | label과 작은 부가정보 |
| sm | 8 | inline 요소 간격 |
| md | 12 | 행 안의 관련 정보·보조 action |
| lg | 16 | 행 세로 padding·control 간격 |
| xl | 24 | 일반 screen margin·sheet padding |
| xxl | 32 | section gap |
| xxxl | 48 | 집중 화면 큰 구분 |
| screen | 24 | 351pt 이상 좌우 |
| screenCompact | 16 | 350pt 이하 좌우 |
| section | 32 | 별도 섹션 사이 |
| row | 16 | list item 상하 |
| inline | 8 | label/value 및 button 내부 |
| modal | 24 | 시트 좌우 |
| safeBottom | 16 | 시스템 safe area 이외의 content 여유 |

390pt를 기준으로 설계하되 320pt에서 수평 넘침이 없어야 한다. 본문은 시스템 safe area 안에서 배치한다. 하단 tab bar / sheet / keyboard inset은 시스템 값이며 34pt 같은 기기 숫자를 앱 토큰으로 고정하지 않는다. action tap target 최소 44×44pt. 상단 제목과 tab 영역은 제품 레이아웃, device bezel과 시뮬레이션 toolbar는 프리뷰 외곽이다.

## Radius / Border / Elevation

radius: `control 8`, `container 16`, `modal 24`. 셀마다 radius를 주지 않는다. container는 ActiveRoutinePanel과 필요한 empty action 영역에만 제한한다. modal 수치는 프리뷰 형상 기준이며 네이티브 sheet는 OS 기본 모서리를 우선한다. border `hairline 0.5pt`(장식), `control 1pt`, `focus 2pt`. Shadow는 product content에 없음. sheet와 context menu의 시스템 elevation만 허용한다. 선택은 선·채움·label을 함께 사용한다.

## Iconography

SF Symbols 대응 이름: 탭 `sun.max`, `calendar`, `square.stack`, `text.book.closed`, `gearshape`; 행동 `play.fill`, `pause.fill`, `checkmark`, `plus`, `chevron.left`, `chevron.right`, `ellipsis`; 기능 `timer`, `bell`, `calendar.badge.checkmark`, `exclamationmark.circle`, `arrow.clockwise`, `arrow.up.right`, `xmark`.

심볼은 17pt(행) / 20pt(탭) 기본, text style에 따라 scale한다. 의미 있는 탭과 실행 제어에만 사용한다. 루틴별 장식·category emoji 없음. 프리뷰의 작은 inline SVG는 의미 확인용 대체 그림이며 SF Symbols 자산 복제물이 아니다. 후속 iOS 구현에서 `Image(systemName:)`로 교체한다. OS 가용성은 최소 버전 확정 후 확인한다.

## Motion & Haptics

- `quick 180ms`: 버튼 피드백·선택.
- `standard 240ms`: 예정 → 실행 영역, 완료 영역 전환.
- `sheet 320ms`: 웹 시트 시뮬레이션. iOS는 native presentation.
- 곡선 `cubic-bezier(0.2, 0, 0, 1)`. 반복 pulse, bounce, confetti 없음.
- Reduce Motion: 위치 이동 없이 즉시 전환 또는 `80ms` opacity. 타이머도 점멸하지 않는다.
- Haptic은 시작/완료/요일 선택의 결과에 제한. 매초·매행에는 없다. 시스템 설정을 존중한다.

## Accessibility 기준

Dynamic Type, Dark Mode, Reduce Motion을 처음부터 지원한다. 상태는 색 + label, 완료는 check + ‘완료’, 정지는 ‘일시 정지’, 건너뛰기는 ‘이번 주 건너뜀’으로 전달한다. VoiceOver는 ‘책상 정리, 예상 10분, 오후 7시, 예정’처럼 한 행 정보를 묶되 시작·옮기기는 각각 명명된 action으로 제공한다. 타이머 초 단위 변경을 live announcement로 읽지 않는다. 입력 오류는 내용을 안내하고 해당 입력으로 focus를 이동한다. 저장·권한 오류는 복구 action에 접근할 수 있게 하며, sheet가 닫히면 호출 control로 focus를 복원한다. 드래그 없이 tap 기반 날짜 이동이 가능하다. 체크·toggle·picker는 네이티브 의미를 유지한다. 키보드 닫기, 입력 보존, 긴 이름, 한국어 줄바꿈을 검증한다.

참고: [Apple 디자인 팁](https://developer.apple.com/design/tips/), [Apple Layout](https://developer.apple.com/design/human-interface-guidelines/layout). 실제 API/최소 iOS 가용성은 개발 착수 시 확인한다.

## 시스템 설정에 따른 표현

9가지 서체 역할, 4pt 간격, radius 8/16/24는 제품의 디자인 기준이다. 시스템 탐색·시트의 크기와 재질은 운영체제에 맡긴다. Running의 기록 시간은 해당 화면의 핵심 정보이므로 제목보다 크게 표시한다.

굵은 텍스트와 큰 글자에서도 label·수치·action 순서를 유지한다. Increase Contrast에서는 필요한 보조 글자를 `textPrimary`로 높이고 의미 있는 경계에 `borderStrong`을 사용한다. 새 색이 필요하면 토큰에 먼저 추가하고 대비를 다시 확인한다. Reduce Transparency에서도 label·윤곽·정렬로 위계가 남아야 한다.

토스트가 사라져도 시간 수정·완료 취소·오류 복구 경로는 남긴다. 웹 프리뷰의 큰 글자와 화면 크기 검토는 네이티브 접근성 검증을 대신하지 않는다.
