# SwiftUI 구현 협업 계약

## 범위와 기준

Native foundation started in #4 after user development request. Full screen/AC implementation remains in follow-up issues. Policy/acceptance: `docs/product-plan.md`. Screen/data state: `design/04-screens.md`. Visual values: `design/tokens.json`.

Spec 1.3 / #18: read `docs/development/planning-revision-1.3.md` before #8–#13. Bulk rest, recovery entry, editable performed date, per-week calendar connection, action-first Records. Docs changed; app implementation pending.

Adopted stack: SwiftUI, SwiftData, UserNotifications, EventKit. iOS 17+, Swift 6 language mode, iPhone 15 Pro, personal device first; see `docs/adr/0001-native-ios-foundation.md`. Signing and actual device OS remain to verify. Skill defaults do not override supported users. Verify unfamiliar APIs against target SDK + Apple docs; compile.

## 구현 순서와 구조

Foundation → shared components → library/week/storage → today/execution/records → notifications/calendar → accessibility/real use. Include save failure + permission denial with each feature.

Feature folders; extract actual shared UI. Models: RoutineTemplate, WeekPlan, PlannedOccurrence, ExecutionRecord, WeeklyMemo, CalendarLink. Recorder/scheduler/calendar exporter outside views. No mandatory ViewModel/Repository/UseCase per screen.

## 상태 소유와 저장

Observation UI models. Owner: private `@State`; editing: binding. Verify actor isolation. Recorder lifetime independent from screen lifetime.

Typed tab/path/sheet. One active sheet enum + target ID. Prefer `sheet(item:)`. Stable collection/occurrence/transition IDs; no `UUID()` during view construction.

Sheet owns draft. Save success → dismiss; failure → preserve input. Block command reentry. Repeat week confirmation/completion/calendar retry must not duplicate occurrences/events.

App save and OS updates: separate outcomes. App saved + OS failed → pending/retry. Never show failed save as success or erase plan on calendar failure.

RestWeek command: stable confirmed ID set; current-week unfinished only. Pause target running interval + skip set atomically. Failure → original running/state. Preserve completed/intervals. Restore same ID; later additions unaffected. OS cleanup follows app commit.

Late completion: Week past-date/prior-week planned/paused → visible already-done action. Same ID/planned date; keep measured intervals, nil duration only without history.

Completion lifecycle: undo clears active completedAt/completionLocalDate/performedOn + removes aggregation; keep intervals/time. Recomplete captures new instant/local date; performedOn defaults to new date. Failed command preserves prior state. Date-only edits retain capture values.

Completion date: `performedOn` owns Records day/week grouping; default `completionLocalDate`. Edit date only; keep `completedAt`, measured intervals, duration, planned date. Reject changed future dates; keep unchanged stored performed date during time edits even if time-zone travel makes it later than local today. Never clamp the stored civil date on sheet open. Recompute both weeks; never move memo/calendar or create second completion.

Calendar intent belongs to WeekPlan; new/copied week defaults off. Connected week additions/changes/rest/restore schedule automatic export. Off suspends queued writes; keep existing events + links. Reconnect/move reuse links + compare external snapshots. Recheck current intent/state before each OS write; stale queued jobs must not resurrect skipped events.

Elapsed = start/end instants minus pause intervals. UI tick display only. Restore from timestamp after background/relaunch. No persistence, calendar I/O, whole-history sorting in body.

## 네이티브 탐색과 입력

5 tabs: TabView; detail: NavigationStack; editing: native sheet. Today start→Running push in Today; Week paused resume→Running push in Week, without moving planned date. Push only after successful save; switch confirmation cancel/failure keeps caller tab/date. TabView stays. Return/complete preserves caller agenda. Back/tab switch never stops recording. Preserve each tab's navigation state.

Dismiss restores caller tab/date/scroll/focus. Reschedule save success alone opens target Week date. Dirty draft cancel/swipe: ‘계속 편집 / 변경 버리기’. Clean draft: dismiss. Optional weekly memo exempt.

Use semantic Button/Toggle/Picker/DatePicker. Swipe/drag supplementary; primary actions always visible. Label icons. No nested sheets.

Recovery: Today quiet action → Week selection; current-week past planned/paused only; default none. Skip/completed/prior-week excluded. Confirm moves same IDs; cancel unchanged. Empty midweek → remaining-week planner. Completion date editor remains optional; direct completion stays one tap.

## 시각·모션·접근성

standard profile. Korean system type, 4pt spacing, forest accent, opaque content. OS owns navigation/control materials. Map tokens to semantic Swift constants + light/dark assets. No per-screen magic values.

Records order: performed-date completed rows → routine counts → optional time → memo. Timeless completion equal weight. All nil durations → hide aggregate, never imply 0. Recovery entry: no count/badge/automatic alert.

Scale token type with Dynamic Type; intrinsic row height. No fixed line-height frames or shrinking long names. Large type: vertical actions. System safe areas + keyboard insets.

Prefer system push/sheet. Custom motion: scoped `.animation(_:value:)` or explicit transaction. No delay-based coordination. Rapid input/reversal/cancel preserve latest state. No per-second animation, haptics, VoiceOver announcements.

Reduce Motion: immediate change/short fade. Reduce Transparency: opaque surfaces. Increase Contrast: stronger boundaries/secondary text. Differentiate Without Color: labels/outlines/symbols retain meaning.

VoiceOver/Voice Control/keyboard/focus must operate start/complete/move/save. Input error → announce + affected input; save/permission error → recovery action; dismiss → trigger. Edit/undo/recovery remain reachable after toast expires.

## 개발 검증

Use plan acceptance criteria. Domain tests: intervals, week boundaries, snapshots, duplicate commands, calendar conflicts. No tests merely copying implementation.

Add 1.3 scenarios: atomic rest/failure/restore; missed-day recovery; Sunday→Monday late entry + performed-date correction; reconnect + cross-week calendar move; all-timeless Records. Owners/cases: `docs/development/planning-revision-1.3.md`.

Build actual scheme. Test smallest/typical/large supported iPhone; default/largest accessibility type; light/dark/increased contrast; long/empty/loading/failure content; portrait/landscape/keyboard; Reduce Motion/Transparency.

Exercise rapid start/complete/confirm, back during push, sheet swipe cancellation/reopen, running tab switch, background/foreground, midnight/time-zone change. Operate VoiceOver/accessibility inputs. Supplement Simulator with device notification/haptic/performance evidence as needed.

Run static audit on actual Swift sources.

```sh
python3 .agents/skills/design-swiftui-interfaces/scripts/audit_swiftui_ui.py <실제-Swift-프로젝트-경로> --profile standard --fail-on high
```

Record scheme/SDK/device/settings/path/result/unverified items. HTML 320px/1.28× review is not native Dynamic Type/VoiceOver proof.
