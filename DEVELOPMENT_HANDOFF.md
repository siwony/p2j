# 개발팀 인계

## 상태와 읽는 순서

Stage: foundation merged (#4); routine editing, optional fields, archive/restore, and draft dismissal implemented in #7. Week planning, LocalDate, occurrence snapshots, move/skip/restore, bulk rest and Today recovery are implemented in #8. Execution/timer/direct completion, record edits/date correction and atomic running rest are implemented in #9. Feature verification/review evidence is tracked in that issue/PR. Weekly Records performed-date grouping, optional time summaries and free memo/planning reference are implemented in #10. This change includes local notifications/settings/manual snooze in #11; actual verification/review/merge state is tracked in its issue/PR. Product spec 1.3 adopted in #18. Calendar integration #12 and full MVP acceptance #13 remain pending.

Before assigned work: `docs/development/planning-revision-1.3.md` → delta/AC/owner/scenarios. Reject stale 1.2 policies: empty-week-only rest, completion-entry-date aggregation, manual export of newly added items, time-first Records.

1. `docs/product-plan.md`: scope, policies, acceptance, kickoff decisions.
2. `design/01-direction.md`, `design/02-foundations.md`, `design/tokens.json`: art direction + visual source.
3. `design/03-components.md`, `design/04-screens.md`: component/screen/state contracts. Read assigned feature first.
4. `design/05-swiftui-handoff.md`: implementation + QA contract.

`design/preview/index.html`: 1.2 visual example; five 1.3 changes absent. Docs own behavior. Never copy fixed date, sample data, simulated permissions into product logic. Graph freshness follows `graphify-out/provenance.json`; recheck source docs for changes newer than its source commit. Graph update only after merge.

## 협업 규칙

Development workflow: `CONTRIBUTING.md`. Agent instructions: `AGENTS.md`. Graphify: `docs/development/graphify.md`; generate/update only after main merge, current AI session owns labels.

Latest user decision wins. Policy → product plan; values → tokens; screen behavior → screen spec. Update affected refs together. No duplicated rules.

Apply project skills by responsibility:

- `.agents/skills/swiftui-design-skill/SKILL.md`: art direction, composition, hierarchy.
- `.agents/skills/apple-design/SKILL.md`: native iOS navigation/control semantics.
- `.agents/skills/swiftui-pro/SKILL.md`: SwiftUI, data flow, concurrency.
- `.agents/skills/design-swiftui-interfaces/SKILL.md`: interaction, motion, accessibility, visual QA.

Priority: product philosophy → art direction → hierarchy/signature identity → native iOS interaction → implementation correctness → Simulator QA. No generic averaging. Keep standard profile + brand.

Human planning/design docs: natural prose. This file + implementation contract: caveman. Preserve code, paths, APIs, conditions, negations.

## 착수와 범위

Resolve kickoff items in plan. Foundation → components → screens/storage → notifications/calendar → accessibility/real use. Sequential work: #9 execution after #8, then #10 weekly Records; independent Codex review + latest-head Copilot completion required before merge. Foundation implementation/verification: #4; library: #7; planning: #8; sequential features: `docs/development/implementation-plan.md`. Personal iPhone 15 Pro target; signing/device validation pending.

MVP excludes Mac, CloudKit, server, account, payment. Native SwiftUI; no HTML WebView wrapper. Tests map to plan acceptance criteria.

`docs/.archive/`: historical reviews + compression originals; exclude default reads. Read `design/reference/user-design-brief.txt` only for source conflicts.

Technical decisions: `docs/adr/0001-native-ios-foundation.md`, `docs/adr/0002-execution-time-and-recovery.md`. Data contracts: `docs/development/data-contracts.md`. Local build: `docs/development/local-development.md`.

#11 ownership (2026-10-21): planning handoff `issues/11#issuecomment-6303010134`; base main `4c68330`. Worker `fix_rebase_hook` owns notifications/Settings/routing/new tests/project registration in managed `issue-11-notifications` worktree. Root owns docs/Git/integration; `review_collaboration_rules` independent review; `notification_api_research` read-only Apple/SDK research. No V5; [ADR 0004](docs/adr/0004-local-notifications-and-reconciliation.md) owns atomic notification file + save/reconcile/crash boundaries. Source implementation, local evidence, latest-head reviews/CI, code merge and postmerge Graphify are separate milestones. Actual device delivery/Focus/iOS 17/full accessibility remain #13; calendar #12 follows.
