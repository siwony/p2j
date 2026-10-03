# SwiftUI 구현 협업 계약

## 범위와 기준

현재는 기획 단계다. 구현 시작은 별도 개발 요청에 따른다. 제품 정책과 인수 조건은 `docs/product-plan.md`, 화면·데이터 상태는 `design/04-screens.md`, 색·서체·간격 값은 `design/tokens.json`을 기준으로 삼는다.

제안 기술은 SwiftUI, SwiftData, UserNotifications, EventKit이다. 배포 타깃·Swift 버전·서명·테스트 기기는 개발팀이 착수 시 확정한다. 스킬의 새 앱 버전 권고는 사용자 지원 범위를 대신하지 않는다. 낯선 API는 타깃 SDK와 Apple 문서에서 확인한 뒤 컴파일한다.

## 구현 순서와 구조

Foundation → 공통 컴포넌트 → 루틴함·주간 계획·저장 → 오늘·실행·기록 → 알림·캘린더 → 접근성·실사용 순서로 구현한다. 저장 실패와 권한 거절 경로도 해당 기능과 함께 구현한다.

화면별 feature 폴더를 사용한다. 공통 UI는 실제 공유되는 부분만 추출한다. 모델은 RoutineTemplate, WeekPlan, PlannedOccurrence, ExecutionRecord, WeeklyMemo, CalendarLink로 구분한다. 기록기·알림 예약기·캘린더 반영기는 뷰 외부에 둔다. 모든 화면에 ViewModel/Repository/UseCase 계층을 의무적으로 만들지 않는다.

## 상태 소유와 저장

UI 모델은 Observation을 사용한다. 소유 뷰의 상태는 private `@State`, 편집 전달은 binding으로 구성한다. UI 상태의 actor 격리를 확인한다. 화면 생성·제거가 실행 기록기의 수명을 결정하지 않게 한다.

탭 선택, navigation path, 활성 sheet는 타입으로 표현한다. 하나의 active sheet enum과 대상 ID를 사용한다. 대상이 있는 시트는 `sheet(item:)`을 우선한다. 목록·회차·전환의 ID는 안정적으로 유지한다. view 생성 중 `UUID()`를 만들지 않는다.

편집 draft는 각 시트가 소유한다. 저장 성공 후 닫고 실패 시 입력을 보존한다. 저장 중 재진입은 command에서 막는다. 같은 주간 확정·완료·캘린더 재시도가 중복 회차나 중복 일정을 만들면 안 된다.

앱 데이터 저장과 OS 알림·캘린더 갱신은 별도 결과로 관리한다. 앱 저장 후 OS 작업이 실패하면 pending 상태와 재시도를 유지한다. 저장 실패를 성공으로 표시하거나 캘린더 오류 때문에 앱 계획을 지우지 않는다.

실행 시간은 시작·종료 instant와 pause interval로 계산한다. UI tick은 표시만 갱신한다. background·재실행 시 timestamp로 복원한다. body에서 저장·캘린더 조회·전체 기록 정렬을 실행하지 않는다.

## 네이티브 탐색과 입력

5탭은 TabView, 상세 이동은 NavigationStack, 편집은 native sheet를 사용한다. Today→Running은 push하며 TabView를 유지한다. back·탭 전환은 실행을 종료하지 않는다. 각 탭의 탐색 상태는 보존한다.

시트 닫기는 호출 탭·날짜·스크롤·focus를 복원한다. Reschedule 저장 성공만 대상 날짜 Week로 안내한다. 변경된 draft를 취소하거나 swipe로 닫을 때 ‘계속 편집 / 변경 버리기’를 사용한다. 변경이 없으면 바로 닫는다. 선택적 주간 메모에는 이 확인을 적용하지 않는다.

Button·Toggle·Picker·DatePicker 등 의미 있는 시스템 제어를 사용한다. swipe·drag는 보조 경로다. 주요 동작을 제스처에만 숨기지 않는다. 아이콘에도 동작 label을 제공하고 중첩 sheet를 만들지 않는다.

## 시각·모션·접근성

standard 프로필. 한국어 system type·4pt 기반 간격·숲빛 accent·불투명 콘텐츠 면을 유지한다. OS navigation/control 재질은 시스템에 맡긴다. 토큰은 의미별 Swift 상수와 light/dark 색 asset으로 대응한다. 화면마다 임의 수치를 추가하지 않는다.

토큰 서체를 Dynamic Type에 상대적으로 연결하고 행 높이는 내용에 맞춘다. line height를 고정 frame으로 강제하거나 긴 이름을 축소하지 않는다. 큰 글자에서는 action을 세로로 배치한다. 시스템 safe area·키보드 inset을 사용한다.

시스템 push/sheet 전환을 우선한다. 커스텀 상태 변화는 좁은 subtree의 `.animation(_:value:)` 또는 명시적 transaction에 묶는다. 지연으로 전환을 조율하지 않는다. 연타·반전·취소 시 최신 상태를 보존한다. 매초 타이머에 animation·햅틱·VoiceOver 자동 읽기를 넣지 않는다.

Reduce Motion은 이동·확대를 즉시 전환 또는 짧은 fade로 대체한다. Reduce Transparency는 불투명 표면을 유지한다. Increase Contrast는 경계·보조 글자를 강화한다. Differentiate Without Color에서도 label·윤곽·심볼로 상태가 구분되어야 한다.

VoiceOver·Voice Control·키보드·focus로 시작·완료·이동·저장을 수행할 수 있어야 한다. 오류 후 관련 입력으로, 시트 종료 후 호출 제어로 focus를 돌린다. 토스트가 사라져도 기록 수정·완료 취소·오류 복구 경로는 남긴다.

## 개발 검증

검증 범위는 기획서의 인수 조건을 따른다. 핵심 domain 테스트는 interval·주 경계·snapshot·중복 command·캘린더 충돌을 다룬다. 구현을 그대로 복사한 형식적 테스트는 추가하지 않는다.

실제 scheme build 후 가장 작은 지원 iPhone·대표 크기·큰 크기에서 확인한다. 기본/최대 접근성 글자, light/dark/대비 증가, 긴 이름·빈 상태·loading·실패, 세로/가로·키보드, Reduce Motion/Transparency를 포함한다.

빠른 시작·완료·확정 연타, push 중 back, 시트 swipe 취소와 재진입, 실행 중 탭 이동, background/foreground, 자정·시간대 변경을 확인한다. VoiceOver와 접근성 입력은 실제로 조작한다. 알림 전달·햅틱·성능은 필요에 따라 실기기로 보완한다.

정적 검사는 실제 Swift 소스 경로에 실행한다.

```sh
python3 .agents/skills/design-swiftui-interfaces/scripts/audit_swiftui_ui.py <실제-Swift-프로젝트-경로> --profile standard --fail-on high
```

결과에는 scheme·SDK·기기·설정·확인한 경로·미검증 항목을 남긴다. HTML의 320px·1.28배 글자 검토를 native Dynamic Type·VoiceOver 통과로 환산하지 않는다. 품질 점수는 구현과 근거가 생긴 뒤에만 사용한다.
