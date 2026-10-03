# SwiftUI 구현 협업 계약

## 범위와 기준

Planning only; implementation starts on separate dev request. Policy/acceptance: `docs/product-plan.md`. Screen/data state: `design/04-screens.md`. Visual values: `design/tokens.json`.

Proposed stack: SwiftUI, SwiftData, UserNotifications, EventKit. Dev kickoff sets deployment target, Swift, signing, test devices. Skill defaults do not override supported users. Verify unfamiliar APIs against target SDK + Apple docs; compile.

## 구현 순서와 구조

Foundation → shared components → library/week/storage → today/execution/records → notifications/calendar → accessibility/real use. Include save failure + permission denial with each feature.

Feature folders; extract actual shared UI. Models: RoutineTemplate, WeekPlan, PlannedOccurrence, ExecutionRecord, WeeklyMemo, CalendarLink. Recorder/scheduler/calendar exporter outside views. No mandatory ViewModel/Repository/UseCase per screen.

## 상태 소유와 저장

Observation UI models. Owner: private `@State`; editing: binding. Verify actor isolation. Recorder lifetime independent from screen lifetime.

Typed tab/path/sheet. One active sheet enum + target ID. Prefer `sheet(item:)`. Stable collection/occurrence/transition IDs; no `UUID()` during view construction.

Sheet owns draft. Save success → dismiss; failure → preserve input. Block command reentry. Repeat week confirmation/completion/calendar retry must not duplicate occurrences/events.

App save and OS updates: separate outcomes. App saved + OS failed → pending/retry. Never show failed save as success or erase plan on calendar failure.

Elapsed = start/end instants minus pause intervals. UI tick display only. Restore from timestamp after background/relaunch. No persistence, calendar I/O, whole-history sorting in body.

## 네이티브 탐색과 입력

5 tabs: TabView; detail: NavigationStack; editing: native sheet. Today→Running push; TabView stays. Back/tab switch never stops recording. Preserve each tab's navigation state.

Dismiss restores caller tab/date/scroll/focus. Reschedule save success alone opens target Week date. Dirty draft cancel/swipe: ‘계속 편집 / 변경 버리기’. Clean draft: dismiss. Optional weekly memo exempt.

Use semantic Button/Toggle/Picker/DatePicker. Swipe/drag supplementary; primary actions always visible. Label icons. No nested sheets.

## 시각·모션·접근성

standard profile. Korean system type, 4pt spacing, forest accent, opaque content. OS owns navigation/control materials. Map tokens to semantic Swift constants + light/dark assets. No per-screen magic values.

Scale token type with Dynamic Type; intrinsic row height. No fixed line-height frames or shrinking long names. Large type: vertical actions. System safe areas + keyboard insets.

Prefer system push/sheet. Custom motion: scoped `.animation(_:value:)` or explicit transaction. No delay-based coordination. Rapid input/reversal/cancel preserve latest state. No per-second animation, haptics, VoiceOver announcements.

Reduce Motion: immediate change/short fade. Reduce Transparency: opaque surfaces. Increase Contrast: stronger boundaries/secondary text. Differentiate Without Color: labels/outlines/symbols retain meaning.

VoiceOver/Voice Control/keyboard/focus must operate start/complete/move/save. Input error → announce + affected input; save/permission error → recovery action; dismiss → trigger. Edit/undo/recovery remain reachable after toast expires.

## 개발 검증

Use plan acceptance criteria. Domain tests: intervals, week boundaries, snapshots, duplicate commands, calendar conflicts. No tests merely copying implementation.

Build actual scheme. Test smallest/typical/large supported iPhone; default/largest accessibility type; light/dark/increased contrast; long/empty/loading/failure content; portrait/landscape/keyboard; Reduce Motion/Transparency.

Exercise rapid start/complete/confirm, back during push, sheet swipe cancellation/reopen, running tab switch, background/foreground, midnight/time-zone change. Operate VoiceOver/accessibility inputs. Supplement Simulator with device notification/haptic/performance evidence as needed.

Run static audit on actual Swift sources.

```sh
python3 .agents/skills/design-swiftui-interfaces/scripts/audit_swiftui_ui.py <실제-Swift-프로젝트-경로> --profile standard --fail-on high
```

Record scheme/SDK/device/settings/path/result/unverified items. HTML 320px/1.28× review is not native Dynamic Type/VoiceOver proof.
