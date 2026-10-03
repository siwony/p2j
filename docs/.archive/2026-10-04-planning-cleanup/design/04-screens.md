# 한 주 — Screens & State

2026-10-04 · Phase 4 · 브라우저 예시 기준일 2026-10-04 일요일. 현재 주 9.28–10.4, 다음 주 10.5–10.11. 실제 앱은 사용자의 로컬 달력으로 날짜를 계산한다.

## 상태 모델과 불변 조건

- RoutineTemplate: 이름·분류·선택적 예상분·기본횟수·선호요일·시작행동·메모·보관여부. 보관은 미래 선택에서 제외하며 과거 snapshot 유지.
- WeekPlan: 월요일 시작 LocalDate, 선택한 occurrence들. 다음 주는 명시적 선택·확정으로만 생성. 자동 이월 없음.
- PlannedOccurrence: 고유 ID, 주 ID, routine ID, 실행시점 이름 snapshot, 날짜·선택시각, 예상분 snapshot, 상태 `planned / running / paused / completed / skipped`.
- Execution: 시작/재개 interval들, 누적 active duration, 선택적 직접입력 actualDuration, 완료시각. 직접 완료의 duration은 nil(시간 미기록); 0분과 다르다. 기록된 시간이 1분 미만이면 ‘1분 미만 기록’으로 표시한다. 완료행·실행기록시트·시간합계는 같은 formatter를 사용한다.
- 앱 전체 동시 running은 하나. 다른 항목 시작 시 기존 항목을 일시정지하고 새 항목 시작하는 선택을 제공한다. 취소하면 현재 실행 유지.
- pause는 누적값 저장, resume은 새 interval 시작. 화면 tick 수를 누적시간의 원천으로 삼지 않는다. 앱이 닫혀도 timestamp로 복원하며 자동완료 없음.
- 완료는 예정알림 취소, 캘린더 계획 유지. skip은 완료로 세지 않으며 연결된 캘린더 일정과 예정알림 제거 요청. active 항목 이동/skip은 먼저 pause하며 실행 interval 보존.
- 완료 취소는 planned(또는 기존 paused 기록이 있으면 paused)로 돌리고 완료 집계에서 제거. 기록 삭제와 완료 취소는 별개. 타이머 시간이 비정상적으로 길면 기록수정 안내, 자동 축소 없음.
- 주가 지난 planned는 `planned`를 보존하되 과거 계획에서 ‘기록 없음’으로 표시한다. 빨간 overdue, 다음주 자동복사 없음. 다음 계획 후보에서 선택하면 **새 ID**로 만든다.
- 예상 합계는 미완료·미skip의 알려진 예상분만 더한다. 미정 항목이 있으면 ‘예상 시간 미정 포함’ 추가. 실제 기록 합계는 actual duration이 있는 완료기록만 더하고 미기록 건수를 병기한다.
- 날짜는 월요일 기준 주간 LocalDate로 관리하고 시각은 로컬 wall time이다. 시간대 변경 시 실제 기록 interval은 instant 유지, 미래 알림/캘린더 시각의 재계산 정책은 개발 단계에서 명시·검증한다. DST에 없는/중복되는 시간 선택은 OS picker 결과를 확인해 사용자에게 표시한다.

## 1. Today / 오늘

**목적:** 지금 시작할 한 가지와 오늘의 배치를 읽는다. **위계:** 날짜 → 오늘 → 실행중(있을 때) → 예정 → 완료 → 일요일 다음 주 계획. **레이아웃:** 제목 영역 24pt margin, active panel은 단일 accentSubtle 면, 예정 항목은 separator 목록. 완료는 작은 표제와 낮은 굵기, 취소선 없음.

**Components:** NavigationHeader, ActiveRoutinePanel, TodayRoutineRow, CompletedRoutineRow, EmptyTodayState. **Primary:** 시작 또는 실행 중 완료. **Secondary:** 이미 했어요, 옮기기, 실행 상세.

**빈 상태:** ‘오늘은 정해둔 일이 없어요.’ + ‘이번 주 보기’. 과거 완료가 있다면 해당 섹션 유지. **오류:** ‘오늘 계획을 불러오지 못했어요’ + 재시도, 기존 표시 데이터가 있으면 유지. 알림 권한 거절은 실행을 막지 않는다.

**Interaction:** 시작 → RunningRoutine. 이미 했어요 → 즉시 completed/nil time → 완료 toast와 시간 추가 action. 완료행 → CompletionSheet 수정. 일요일 하단 ‘다음 주 계획하기’ → Week(next week) → 계획 선택. 날짜가 바뀌어도 실행 중인 항목은 상단에 원래 날짜와 함께 유지한다.

## 2. Week / 이번 주

**목적:** 월–일 계획을 읽고 옮긴다. **위계:** 실제 주간 날짜범위 → 요일 strip → 선택날짜/남은 예상시간 → 실행 목록 → 계획 편집/캘린더. **레이아웃:** horizontal day selector + 한 날짜 세로 agenda. 각 요일 수치 1개는 일자, 작은 표식은 계획 존재. 7열 시간표 없음.

**Components:** WeekDaySelector, WeekDayAgenda, PlannedRoutineRow, DayWorkloadIndicator, WeeklySelection, CalendarSyncState. **Primary:** 주가 비었으면 루틴 선택, 계획이 있으면 추가/계획 편집. **Secondary:** 지난주/다음주, 옮기기, 캘린더 반영.

**빈 상태:** 선택 날짜만 비었으면 ‘이 날은 비워두었어요’ + ‘루틴 추가’; 주 전체가 비었으면 ‘이번 주에 할 일을 골라볼까요?’ + ‘루틴 선택’, ‘이번 주 쉬기’. **오류:** 저장 실패 draft 유지, 재시도. Calendar 실패는 계획 자체의 실패로 표시하지 않는다.

**일요일 계획:** 오늘/기록의 현재주 회고 → ‘다음 주 10.5–10.11’ 명시 → 이전주 메모(있을 때) → 루틴함 후보/지난 계획 가져오기 → 루틴별 횟수 선택(기본횟수 초기값, 편집 가능) → 회차별 요일 배치 → ‘계획에 담기’. 선택하지 않은 후보와 미완료는 따라오지 않는다. 취소는 draft만 폐기. 쉬기는 빈 계획을 확정하고 알림을 추가하지 않는다. 회고 공란으로도 진행 가능.

**이동:** 행의 ‘옮기기’ → Reschedule → 저장 후 새 날짜 agenda 선택, toast ‘목요일로 옮겼어요’. 다른 주로 옮길 때 대상 주 날짜를 명시하며 그 주에 항목을 한 번만 이동한다. Drag는 필수 범위 아님.

## 3. Routine Library / 루틴함

**목적:** 반복해서 고를 일의 원본을 관리한다. **위계:** 제목/추가 → 간단한 전체·분류 filter → 분류별 목록 → 보관함. **레이아웃:** 카드 없이 분류 표제와 행. 이름, 예상분, 기본횟수만 우선 노출. 메모·선호요일은 편집에서 확인.

**Components:** RoutineRow, RoutineCategoryIndicator, InlineAction. **Primary:** 새 루틴. **Secondary:** 편집, 보관. **빈 상태:** ‘반복하고 싶은 일을 하나 적어보세요.’ + ‘루틴 만들기’. **오류:** 루틴 저장 실패 시 editor 보존. 보관 실패는 원래 행 유지.

**Interaction:** 이름 tap 편집, context action 보관. 보관된 루틴은 보관함에서 복원. 기존 occurrence와 기록 snapshot은 영향 없음. 검색은 MVP 필수 아님.

## 4. Records / 기록

**목적:** 실제 해낸 일과 메모를 확인한다. **위계:** 주간 범위 → 완료 목록(날짜별) → 기록한 시간/미기록 명시 → 루틴별 실제 횟수 → 주간 메모. **레이아웃:** 읽는 장부 형태. 큰 수치/차트/완료율 없음. 시간 합계는 한 줄 문장, 날짜와 행의 여백으로 grouping.

**Components:** CompletedRoutineRow, WeekMemo, InlineStatus. **Primary:** 메모 편집(선택적). **Secondary:** 주 이동, 기록 수정, 다음주 계획. **빈 상태:** ‘아직 남긴 기록이 없어요.’ + 메모 입력은 그대로 제공. **오류:** 메모 저장 실패에 입력을 보존하고 ‘다시 저장’, 자동저장 성공인 척하지 않는다.

**Interaction:** row→CompletionSheet. 시간 미기록을 0으로 합산하거나 예상시간을 사용하지 않는다. 미룬 뒤 완료한 항목은 ‘날짜를 옮겨 마침’ 텍스트만 추가. skip과 미완료는 완료 장부 밖의 ‘지난 계획 보기’에서 읽는다. 메모는 입력 후 자동저장, 자유분량, 필수 질문 없음.

## 5. Settings / 설정

**목적:** 알림·캘린더 사용 방식을 선택한다. **위계:** 계획알림 → 실행알림/기본시간 → Apple Calendar → 권한상태 → 기기저장 설명. **레이아웃:** native grouped settings와 separator. 브랜드 hero 없음.

**Components:** TimeSelector, PermissionState, CalendarSyncState. **Primary:** 해당 설정 control. **Secondary:** 시스템 설정 열기, 캘린더 관리. **빈 상태:** 미설정 상태 자체를 기본값으로 표시. **오류:** 변경 저장 실패와 재시도. ‘허용 안 됨’은 중립 label, 붉은 배너 금지.

**Interaction:** 계획알림 기본 일요일20:00, 실행 기본시각 사용자 선택. 권한 미요청에서 기능을 켤 때 설명 후 요청. 거절해도 앱내 실행 가능. ‘30분 뒤 다시 알림’은 알림만 늦추고 occurrence 일정은 그대로. 설정 화면에서 CloudKit 연결 control 없음.

## 6. Routine Editor / 루틴 편집

**목적:** 이름만으로 루틴을 만들고 필요하면 구체화한다. **위계:** 취소/저장 → 이름 → 예상시간/분류 → 선택사항(횟수·선호요일·시작행동·메모). **레이아웃:** native sheet, 이름은 큰 입력, 나머지는 줄 단위. **Primary:** 저장. **Secondary:** 취소, 편집시 보관.

**Components:** RoutineEditorSheet, TextField, DurationPicker, CategorySelector, DaySelector. **빈 상태:** 이름 placeholder ‘예: 책상 정리’, 나머지 미정 허용. **오류:** 빈 이름 inline 오류 및 focus, 저장 실패 입력유지. **Interaction:** 키보드 위 action 접근. 저장은 이름 trimming, 예상시간 미정 유효. 기존 루틴 수정은 이미 생성된 항목의 snapshot을 소급 변경하지 않는다.

## 7. Reschedule / 일정 옮기기

**목적:** 이유 없이 날짜·시각을 바꾼다. **위계:** 루틴명/현재날짜 → 날짜 선택 → 시간 지정 → 변경 action → 이번 주 건너뛰기. **레이아웃:** 주간 strip 또는 native date picker, 간단한 시트. **Primary:** 이 날로 옮기기. **Secondary:** 취소, 시간 없이 두기, 이번 주 건너뛰기.

**Components:** RescheduleSheet, DaySelector, TimeSelector, QuietButton. **빈 상태:** 대상 항목 없음→‘이 항목은 더 이상 계획에 없어요’ 닫기. **오류:** 저장 실패 초안 유지. **Interaction:** 날짜 선택은 draft, 확정만 영속. 취소는 호출한 탭·선택 날짜·스크롤·가능하면 호출 버튼 focus를 복원한다. Today에서 열었으면 Today로 돌아간다. 저장 성공일 때만 이동한 날짜의 Week agenda로 안내한다. skip은 중립 confirmation ‘이번 주에서는 건너뛸까요?’ + ‘건너뛰기’, 원래 실행기록 남김. 예정알림 취소·캘린더 제거 실패는 별도 재시도 상태. 오늘 나중은 날짜 유지+새 시각 선택, 알림 snooze와 구분.

## 8. Running Routine / 실행 중

**목적:** 첫 행동과 실행 제어에 집중한다. **위계:** 뒤로 → 분류/루틴명 → 시작행동 → 기록시간 → pause/resume + 완료 → 계획일/예상시간. **레이아웃:** 큰 시간(44pt)은 이 화면에만. 원형 chart 없음. **Primary:** 완료. **Secondary:** 일시정지/이어서 하기, 오늘로 돌아가기.

**Components:** RoutineStatus, PrimaryButton, SecondaryButton. **빈 상태:** 실행중 없음→‘시작할 일을 골라보세요’ + 오늘 보기. **오류:** 기록저장 실패 시 제어 결과를 확정하지 않고 시간을 보존, 다시 저장. **Interaction:** Today의 NavigationStack에 push하며 하단 TabView를 유지한다. 현재 탭은 Today다. back과 다른 탭 이동은 실행을 중단하지 않는다. 완료→기록 저장→Today/Records. 시간수정은 CompletionSheet. 예상시간이 지나도 경고·자동완료 없음. 접근성은 초 단위 announce 금지.

## 보조 presentation과 route

- CompletionSheet: 이름 → ‘완료했어요’ → 시간 미기록 또는 실제기록 → 선택적 분 직접입력 → 저장. ‘완료 취소’는 별도 action. 닫아도 이미 했어요 결과는 유지.
- CalendarSheet: 대상주·쓰기가능 캘린더 선택 → 종일/시간지정 규칙·방향 설명 → 권한→반영. 미허용/일부실패/외부변경/반영됨 분리. 외부수정 확인 시 ‘앱 계획으로 다시 반영’은 명시적 선택, 자동 덮어쓰기 금지. 완료의 계획 일정 유지, skip/제외 일정 제거. 메모·실제시간 내보내지 않음.
- Navigation: Tab(Today, Week, Library, Records, Settings). Today→Running push. Library→RoutineEditor sheet. Today/Week→Reschedule sheet. Completed row→Completion sheet. Week/Settings→Calendar sheet. Week→WeeklySelection sheet. sheet dismiss는 호출자 context와 focus 복원.
- 하나의 sheet enum을 root coordinator 또는 탭에 둔다. sheet 위에 sheet를 겹치지 않는다. editor에서 필요 picker는 같은 sheet의 native control. 저장성공 후 dismiss, 실패면 열린 채 유지.

## 프리뷰 계약

`design/preview/index.html`은 독립 로컬 시뮬레이션이다. 기기 밖 선택기로 8화면, 기본/빈/오류, light/dark, 큰글자를 선택한다. 고정 예시일이며 실제 OS 권한/알림/캘린더·SwiftData를 호출하지 않는다. 샘플 변경은 브라우저 localStorage에 저장한다. 초기화로 복구한다. 네이티브 tab bar는 시스템 크기를 따르므로 큰글자 시뮬레이션에서도 tab label은 유지하고 본문·action을 확장한다. native 구현의 VoiceOver·Dynamic Type 동작을 검증했다고 주장하지 않는다.
