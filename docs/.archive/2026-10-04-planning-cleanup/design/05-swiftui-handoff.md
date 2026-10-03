# 한 주 — SwiftUI 개발 인계

2026-10-04 · Phase 5 · 디자인을 네이티브 앱으로 옮기기 위한 명세. SwiftUI 앱을 구현하거나 컴파일한 결과물이 아니다.

## 읽는 순서와 구현 순서

1. `docs/product-plan.md`로 iPhone MVP 범위 확인.
2. `design/01-direction.md`와 `02-foundations.md`로 태도와 시각 규칙 확인.
3. **Foundation 먼저:** `design/tokens.json`을 source of truth로 색 asset과 Swift 타입으로 대응. 문서·프리뷰가 달라지면 JSON을 기준으로 수정한다.
4. **공통 component:** button style, routine 이름/meta, status, 입력 label, feedback. `03-components.md`의 shared/screen-local 구분을 따른다.
5. **실제 상태와 화면:** 루틴함+편집 → 주간 선택·배치 → 오늘+실행 → 기록·메모 → 설정·알림 → 캘린더. 각 단계에서 저장·실패 경로를 함께 연결한다.
6. 접근성·권한·시간대·재실행·실기기 검증 후 MVP 완료 판단. 웹 프리뷰 성공을 네이티브 검증으로 대체하지 않는다.

추가 기준은 `06-art-direction-review.md`와 `07-experience-contract.md`다. 네 스킬의 책임과 사용자가 지정한 우선순위, 상태 소유권, 취소·모션·접근성 규칙, 시뮬레이터 통과 조건을 함께 읽는다. 기본 system style에 맞추기 위해 제품의 아트 디렉션을 평균화하지 않는다.

## 제안 파일 구조

```text
HanJu/
  App/
    HanJuApp.swift
    AppRoute.swift
  DesignSystem/
    Foundation/
      AppColor.swift
      AppTypography.swift
      AppSpacing.swift
      AppRadius.swift
      AppMotion.swift
    Components/
      Action/AppButtonStyle.swift
      Routine/RoutineSummary.swift
      Routine/RoutineStatusLabel.swift
      Planning/WeekDaySelector.swift
      Input/LabeledInput.swift
      Feedback/InlineStatusView.swift
  Models/
    RoutineTemplate.swift
    WeekPlan.swift
    PlannedOccurrence.swift
    ExecutionRecord.swift
    WeeklyMemo.swift
    CalendarLink.swift
  Features/
    Today/TodayView.swift
    Week/WeekView.swift
    Week/WeeklySelectionView.swift
    Library/LibraryView.swift
    Library/RoutineEditorView.swift
    Records/RecordsView.swift
    Records/CompletionView.swift
    Settings/SettingsView.swift
    Reschedule/RescheduleView.swift
    Running/RunningRoutineView.swift
    Calendar/CalendarSheet.swift
  Services/
    ExecutionRecorder.swift
    NotificationScheduler.swift
    CalendarExporter.swift
  Resources/Colors.xcassets
```

`Extensions/`는 실제 중복이 생겼을 때만 만든다. 각 화면마다 ViewModel/Repository/UseCase 계층을 의무적으로 추가하지 않는다. SwiftData query와 작은 feature state로 충분한 부분은 그대로 둔다. SwiftData model을 디자인 component API로 직접 넘기지 않고 필요한 값과 action만 전달한다.

## Token → SwiftUI의 정확한 대응

| JSON 경로 | Swift 대응 제안 | 규칙 |
| --- | --- | --- |
| color.light/dark.background | Color("Background") / AppColor.background | Asset의 Any/Dark에 각각 정확한 hex |
| color.*.surface / surfaceRaised | Surface / SurfaceRaised | opacity로 대체하지 않음 |
| color.*.textPrimary/Secondary/Tertiary | TextPrimary/Secondary/Tertiary | 임의 `.secondary.opacity(...)` 대체 금지 |
| color.*.separator / borderStrong | Separator / BorderStrong | 장식선과 control경계 구분 |
| color.*.accent / accentSubtle / onAccent | Accent / AccentSubtle / OnAccent | system blue로 치환하지 않음 |
| color.*.success/warning/destructive/calendar/paused | 동명 PascalCase asset | text+label와 함께만 상태 전달 |
| typography.display … meta | AppTypography의 9역할 | size/weight/relativeTo 매핑. 02 문서 표와 동일 |
| spacing.screen / screenCompact | AppSpacing.screen / screenCompact | 가용 content 폭 기준 350pt 이하에서16, 이상24 |
| spacing.xs…xxxl / section/row/inline/modal/safeBottom | AppSpacing 동명 상수 | point 단위. system safe area는 별도 |
| radius.control/container/modal | AppRadius 동명 상수 | 8/16/24. 실제 native sheet radius는 OS 우선 |
| border.hairline/control/focus | 0.5 / 1 / 2pt | 픽셀단위 hairline 필요하면 displayScale과 정합 |
| motion.quick/standard/sheet/reduced | AppMotion | ms→초 변환. native sheet 애니메이션은 시스템 |
| symbols.* | Image(systemName: 값) | 배포타겟 가용성 확인, label 필요 |

색 asset의 sRGB 변환은 8bit/255로 한다. 주 색에 별도 투명도를 주지 않는다. JSON의 타입 크기를 `@ScaledMetric(relativeTo:)` 또는 iOS semantic font와 연결하되 text style별 기본 크기를 먼저 확인한다. font size만 커지고 행이 잘리지 않도록 자연 높이로 배치한다. 지정 lineHeight는 기본 크기의 디자인 목표이며 `.frame(height:)`로 강제하지 않는다. 숫자 표시만 `.monospacedDigit()` 사용한다. `minimumScaleFactor`로 긴 이름을 작게 만드는 대응은 금지한다.

웹 프리뷰는 JSON을 문서 내에 포함한 사본으로 실행하며 build/server 없이 열 수 있다. JSON 수정 시 `<script id="design-tokens">`를 갱신해야 한다. JS가 색·서체·간격·radius·motion을 CSS 변수로 생성한다. 검토 shell의 margin·bezel·labels는 앱 token 범위 밖이다.

## Native behavior와 custom composition

- TabView의 5탭과 시스템 label 크기 사용. 큰글자는 content에서 확장한다. native tab bar를 축소하거나 제품 자체 custom navigation으로 대체하지 않는다.
- NavigationStack 안에서 Today→Running push하고 TabView를 유지한다. 현재 탭은 Today이며 back/탭 전환은 실행 기록기를 중단하지 않는다. editor/reschedule/completion/calendar/weekly-selection은 native sheet. 현재 화면의 route와 대상 ID를 함께 보관한다.
- sheet의 dismiss/키보드 inset/back gesture는 시스템. 변경된 draft가 있을 때 취소/swipe는 ‘계속 편집 / 변경 버리기’ 확인으로 통일한다. 변경이 없으면 즉시 닫는다. 실패 시 draft를 유지한다. 닫을 때 호출한 탭·날짜·스크롤·focus를 복원한다. Reschedule 저장 성공일 때만 대상 날짜의 Week agenda로 이동한다.
- native DatePicker, TimePicker, Toggle, contextMenu, swipeActions 사용. 핵심 action은 swipe만으로 숨기지 않는다. 날짜 이동은 버튼 경로가 기본이다.
- Today active panel, Records 장부, Week 단일일자 agenda, RoutineEditor 입력 composition에서 브랜드를 만든다. 모든 화면을 shared card component로 감싸지 않는다.

## Component 인터페이스의 경계

예시 계약이며 컴파일 가능한 API를 보장하는 코드가 아니다.

- `RoutineSummary`: title, categoryLabel, expectedDurationLabel, statusLabel. 명명된 onOpen/onStart/onMove action. 내부에서 timer/저장/알림을 호출하지 않는다.
- `ActiveRoutinePanel`: title, firstAction, executionState, elapsedDisplay, onPause/onResume/onComplete/onOpen. Timer는 화면 갱신용이고 누적기록의 원천은 ExecutionRecorder다.
- `WeekDaySelector`: dates[7], selectedDate, today, onSelect. actual Calendar와 time zone으로 날짜 생성. locale의 firstWeekday가 일요일이어도 제품 주간은 월요일 시작이다.
- `RoutineEditor`: 기존 template 또는 새 draft, onSave(draft), onCancel. 저장 결과는 성공/실패로 돌려받고 실패 메시지를 표시한다.
- `Reschedule`: occurrence summary, proposedDate/time, onMove, onSkip. active 상태는 recorder가 먼저 pause한다.
- `Completion`: occurrence/record summary, optional actualDuration draft, onSave/onUndoCompletion. nil과 zero를 구분한다.
- `InlineStatus`: state(neutral/saving/saved/error), message, optional retry. 서비스의 내부 에러코드를 사용자에게 그대로 출력하지 않는다.

## 화면 local state와 영속 데이터

| 데이터 | 소유·수명 | 저장 규칙 |
| --- | --- | --- |
| 선택 탭/선택 날짜/열린 sheet | 화면 route state | 앱 재시작 복원은 선택 사항. domain에 저장하지 않음 |
| editor 이름·분류·기타 draft | sheet local state | 저장 버튼에서 한 번 commit. 실패 후 draft 유지 |
| 주간 후보·횟수·요일 draft | WeeklySelection local state | 확정 전 occurrence 만들지 않음 |
| 이동 날짜·시각 draft | Reschedule local state | 이동 확정 때 기존 occurrence ID 유지 |
| 현재 tick/표시 문자열 | Running local display state | 영속 시간의 원천으로 사용 금지 |
| 루틴원본·주간계획·회차·실행interval·memo | SwiftData | 저장 실패·재실행 복원 시험 |
| 권한 상태 | OS에서 조회한 view state | OS값을 source of truth로 조회. 임의 ‘허용됨’ 저장 금지 |
| 알림 예약 ID·캘린더 연결 ID·반영 결과 | 로컬 영속 coordination data | 해당 occurrence ID와 연결, 재반영 중복 방지 |

메모는 주 ID마다 하나다. 공란도 유효하다. debounce autosave와 scene 전환 flush를 사용하고 실패시 원문 draft와 오류 상태를 유지한다. 저장 전에 저장됨 label을 띄우지 않는다. 루틴원본 이름을 변경해도 이전 occurrence의 이름 snapshot과 실행기록은 변하지 않는다.

## 시간·알림·캘린더의 구현 계약

ExecutionRecorder는 시작/종료 instant를 저장하고 pause interval을 제외한다. 앱 background 후 다시 foreground가 될 때 실제 timestamp로 시간을 계산한다. 실행중 앱 종료는 자동완료가 아니다. 저장 오류가 있어도 시간을 지우지 않는다. 종료를 잊은 기록은 사용자가 수정한다. 타이머 없이 완료한 것은 actualDuration=nil, 계산할 때 예상값으로 보충하지 않는다. 기록값이 1분 미만이면 ‘1분 미만 기록’, nil이면 ‘시간 미기록’으로 구분한다. 표시용 분 내림이 원래 초 단위 기록을 덮어쓰지 않도록 하고, 기록 편집에서 값을 변경하지 않고 저장하면 원래 기록을 보존한다.

NotificationScheduler는 계획 알림(기본 일20:00)과 실행알림을 분리한다. 날짜·시각 변경/완료/skip 이후 기존 request를 정리한다. ‘30분 뒤 다시 알림’은 notification request 변경이고 occurrence 날짜 변경이 아니다. OS 권한 없이도 domain command는 정상 작동한다.

CalendarExporter는 해당 주의 선택한 occurrence만 쓰기 가능한 calendar에 반영한다. 시간 미지정은 종일, 지정시각은 예상 소요시간을 사용한다. 예상시간까지 미정인 시간지정 항목은 반영 전 사용자에게 종료시간/예상시간을 정하도록 안내한다. 임의 길이의 이벤트를 조용히 만들지 않는다. 기존 연결 ID로 update하여 재반영 중복을 막고, 외부 변경이 확인되면 사용자가 앱 계획으로 덮어쓰기를 선택하게 한다. 완료는 계획 이벤트 유지, skip/제외는 연결 이벤트 제거. 부분실패는 재시도 가능 상태로 남긴다. 전체 접근권한 설명과 실제 요청은 개발단계에서 현재 EventKit 문서와 배포타겟을 확인한다.

앱 데이터는 기기 로컬 저장이다. Apple Calendar 계정의 OS 동기화는 앱 루틴·실행·메모의 기기간 동기화가 아니다. Mac 앱·CloudKit 앱 데이터 동기화·역방향 캘린더 import·서버는 이번 구현범위 밖이다.

## 프리뷰로 확인할 시나리오

- 오늘 시작 → 일시정지 → 이어서 → 완료 → 기록시간.
- 오늘 이미 했어요 → 시간 미기록 → 선택적 시간수정 → 완료취소.
- 예정항목 옮기기 → 날짜/시각 저장 → Week 새 날짜. 건너뛰기 → 완료목록·합계에서 제외.
- 일요일 다음주 계획 → 후보 선택 → 횟수 변경 → 회차별 요일 → 확정. 선택하지 않은 일은 따라오지 않음.
- Records 메모 → 자동 저장 → 새로고침, 공란 허용.
- CalendarSheet 미요청/미허용/반영됨/부분실패/외부변경 예시. 실제 EventKit은 호출하지 않음.
- 320·390pt, dark, 큰글자, empty/error. 각 control target 44pt, 날짜 strip 가로스크롤.

## 검증의 경계

`contrast-report.json`은 지정된 불투명 색 조합 68개에 대한 수치 검증이다. preview는 JavaScript·CSS를 통한 시각/동작 모델이며 SwiftUI 컴파일, SwiftData transaction, iOS 권한창, 알림 취소·재예약, EventKit 중복 방지, background timekeeping, VoiceOver 실제 순서와 Dynamic Type 기기별 결과를 검증한 것이 아니다. 후속 개발 세션에서 Xcode와 iPhone을 사용해 이 항목들을 검증한다. 최소 지원 iOS 버전은 기획대로 개발 착수 시 확정한다.
