# 한 주 — Components

2026-10-04 · 색·타입·간격은 `tokens.json`을 따른다. 공통 component는 두 화면 이상 공유하거나 의미 있는 상태 계약이 있을 때 추출한다. 단순한 화면 조합을 모두 generic component로 만들지 않는다.

## 공통 상태 계약

기본 / 눌림 / 비활성 / 로딩 / 오류를 구분한다. 저장 중 중복 실행은 막고 입력을 보존한다. 오류는 해당 action 인근에 복구 수단과 표시한다. 네트워크 부재는 로컬 계획·실행·메모의 오류가 아니다. 필수 정보는 색·위치와 함께 label로 읽힌다. 모든 button 최소 hit area 44pt. 아래 ‘위계’의 1은 주정보, 2는 보조정보다.

## Navigation

| Component | 역할·위계·variants | 상태와 interaction | SwiftUI 전략 |
| --- | --- | --- | --- |
| AppTabBar | 오늘/이번 주/루틴함/기록/설정 5목적지, tab label 필수 | 현재탭 선택, 각 탭 탐색상태 보존 | native TabView. 직접 그린 bar 강제 금지. 웹의 12pt label은 프리뷰값; 실제 label의 시스템 크기 우선 |
| NavigationHeader | 1 화면명, 2 날짜/주간 범위, 우측 최대 1 action | large/compact; 뒤로가기/추가 | NavigationStack + toolbar. 화면 첫 제목과 navigationTitle 중복 금지 |
| InlineNavigationTitle | 상세·시트의 짧은 제목 | back/close/save; 편집 취소는 변경 초안만 폐기 | inline navigation title, toolbar placement는 native |

## Routine / Today

| Component | 역할·위계·variants | 상태와 interaction | SwiftUI 전략 |
| --- | --- | --- | --- |
| RoutineRow | 1 이름, 2 분류·예상시간·주간기본횟수 | 기본/보관됨, tap 편집, 보관 context action | 공통 content primitive. 실행항목과 루틴원본 모델 혼합 금지 |
| RoutineCompactRow | 선택목록의 이름과 짧은 부가정보 | 미선택/선택 + check/횟수 stepper | Button + selection binding, selection 전체행 44pt |
| RoutineStatus | 예정/진행 중/일시 정지/완료/건너뜀 | text와 필요한 check/play/pause; 색만 금지 | 작은 Text/Image 조합. 모델 enum에서 label 도출 |
| RoutineCategoryIndicator | 집안일/공부/생활/분류 없음 | category label, badge 채움 없음 | textTertiary caption. emoji·색상 분류 강제 없음 |
| TodayRoutineRow | 1 오늘의 실행명, 2 시작행동·시각·예상시간, 3 조정 | 예정/날짜지남/paused. 시작, 이미 했어요, 옮기기 | screen-local row에서 RoutineRow의 이름/meta primitive 재사용 |
| ActiveRoutinePanel | 현재 실행 하나, 루틴명·기록시간·제어 | running/paused; pause/resume/complete; tap 상세 | accentSubtle 단일면. 상태·action props, timer 소유하지 않음 |
| CompletedRoutineRow | 완료한 이름 + 실제 시간 또는 시간 미기록 | tap 수정/완료 취소. strike-through 금지 | secondary hierarchy, check + 완료 label. 접근성 row 묶음 |
| EmptyTodayState | 오늘 정한 일이 없음을 설명 | ‘이번 주 보기’, 꾸밈 그림 없음 | Today 내부 텍스트 + QuietButton 조합 |

## Week

| Component | 역할·위계·variants | 상태와 interaction | SwiftUI 전략 |
| --- | --- | --- | --- |
| WeekDaySelector | 월→일 요일·일자 선택 | 오늘은 밑점+접근성 label, 선택은 면+윤곽; tap. 좌우 주 이동 별도 | 7개 date button. 큰글자/좁은폭은 horizontal ScrollView, 억지 축소 금지 |
| WeekDayAgenda | 7열 대신 선택 날짜의 세로 실행목록 | 빈날/날짜지난날/오늘/미래. 주 변경 시 선택날짜 범위 안 보정 | screen-local section. WeekDayColumn의 모바일 대체 |
| PlannedRoutineRow | 이름, 예상시간, ‘시간 미지정’ 또는 시각 | 완료/건너뜀/예정. tap→Reschedule, context menu 대체 | 실행항목 ID + 상태 + 변경 callback |
| DayWorkloadIndicator | 해당날 계획 수와 예상시간, 값 없으면 ‘예상 시간 미정 포함’ | 평가색·상한·목표대비 없음; 완료/skip은 계산범위 명시 | 단순 Text. planned+running+paused의 남은 예상 합계, 완료는 별도 기록 |
| WeeklySelection | 이번/다음주 날짜범위와 후보 선택·횟수·요일 | 루틴함 선택/지난 계획 가져오기/이번 주 쉬기; 확정 전 draft | Week screen-local sheet content; 후보는 확정 전 draft. 쉬기는 비어 있는 주에만 제공 |

## Actions

| Component | 역할·variants | 상태·interaction | SwiftUI 전략 |
| --- | --- | --- | --- |
| PrimaryButton | 화면/시트의 가장 중요한 실행; full/fit | accent/onAccent. 눌림, busy label, disabled 이유. destructive 사용 금지 | 소규모 ButtonStyle; label multiline; minHeight44 |
| SecondaryButton | 주 action 다음 선택 | borderStrong, 배경 없음. 선택 토글과 혼동 금지 | ButtonStyle |
| QuietButton | 취소·보조 탐색·이미 했어요 | textSecondary 또는 accent; 44pt hit | plain Button, visible focus |
| DestructiveButton | 실제 데이터 삭제 | destructive text, 필요시 native confirmation dialog | role: destructive. skip은 이 버튼 사용 금지 |
| InlineAction | 섹션 옆 보기·수정·옮기기 | text + 충분한 hit area. 작은 글자여도 target 유지 | Button/Text. 여러 inline action은 줄바꿈 |

## Inputs

| Component | 역할·variants | 상태·interaction | SwiftUI 전략 |
| --- | --- | --- | --- |
| TextField | 이름/시작행동 등 1줄 또는 확장입력 | 빈값/편집/오류; name만 필수, 공백값은 저장 불가 | native TextField axis vertical. label은 placeholder 외에도 유지 |
| DurationPicker | 예상/직접기록 시간 | 미정/분; 예상값을 실제값으로 자동복사 금지 | native Picker 또는 입력+단위. 시간 미기록을 0으로 저장하지 않음 |
| DaySelector | 선호요일/회차 배치/이동일 | 단일/다중선택 명시. 선택 텍스트와 check | DatePicker 또는 7개 Button. 이동은 단일선택 |
| TimeSelector | 시간 지정 선택 | 시간 없음/있음. toggle off시 시각 제거 | native Toggle + DatePicker(hourAndMinute) |
| CategorySelector | 분류 선택 | 분류 없음이 유효, category 추가는 후속 | native Picker/menu, fixed MVP list |
| WeekMemo | 자유 메모 | 공란 유효/저장중/저장됨/실패. 실패시 draft 보존 | TextEditor. debounce autosave, focus/scene 종료시 flush; 저장결과 별도 state |

## Feedback

| Component | 역할·variants | 상태·interaction | SwiftUI 전략 |
| --- | --- | --- | --- |
| Toast | 이동·완료 취소 등 단기 결과 | 4초 내외, ‘실행 취소’가 있으면 충분한 읽기시간. 중요오류는 toast 단독 금지 | overlay/safeAreaInset. accessibility announcement 한 번 |
| InlineStatus | 저장·복구정보 | neutral/saving/saved/error; retry 제공 | Text + action. 영역 높이 확장 |
| CalendarSyncState | 앱→캘린더 반영 상태 | 미연결/변경있음/반영중/반영됨/일부실패/외부변경확인필요 | UI view state. 기기 간 앱데이터 sync로 표현 금지 |
| PermissionState | notification/calendar 권한 안내 | 미요청/허용/허용안됨/제한. 미허용은 neutral | status + 권한요청 또는 설정열기. 실제 에러와 시각적으로 분리 |

## Sheets

| Component | 역할·위계·variants | 상태·interaction | SwiftUI 전략 |
| --- | --- | --- | --- |
| RoutineEditorSheet | 이름 우선, 분류/예상시간, 선택정보 | 추가/편집; 변경 draft 취소 시 폐기 여부 확인, 저장 실패 초안 유지 | native sheet + form-like local layout, medium/large는 내용·키보드 따라 |
| RescheduleSheet | 원래 날짜 → 새 날짜, 선택적 시각 | 오늘 나중/다른날/이번주 건너뛰기; 이유 요구 없음 | native sheet; selectedDate local, 저장 후 persistent 변경 |
| CompletionSheet | 기록 결과 확인 및 선택적 직접 시간 | timer완료/직접완료/기록수정/완료취소 | 바로완료는 한 번으로 완료 후 편집 sheet 선택적. 필수 확인 단계를 추가하지 않음 |
| CalendarSheet | 대상주·대상캘린더·반영범위·상태 | 미허용/ready/applying/pending/partial/conflict/success | EventKit service 결과를 표현. 권한/반영 command는 view 외부 |

## 추출의 경계

공유: 색·타입·간격, button styles, routine text/meta, status, 입력 label, 작은 피드백. 화면 내부 유지: 일요일 계획 안내, Records 날짜 장부, Settings 목록, RunningRoutine 배치, WeeklySelection draft. 모든 화면을 통합하는 Card/GenericRow/ScreenBuilder abstraction을 만들지 않는다.
