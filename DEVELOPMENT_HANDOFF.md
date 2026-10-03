# 개발팀 인계

## 상태와 읽는 순서

Stage: foundation merged (#4); routine editing, optional fields, archive/restore, and draft dismissal implemented in #7. Full MVP acceptance pending. Product spec 1.3 adopted in #18; feature implementation pending in #8–#13.

Before assigned work: `docs/development/planning-revision-1.3.md` → delta/AC/owner/scenarios. Reject stale 1.2 policies: empty-week-only rest, completion-entry-date aggregation, manual export of newly added items, time-first Records.

1. `docs/product-plan.md`: scope, policies, acceptance, kickoff decisions.
2. `design/01-direction.md`, `design/02-foundations.md`, `design/tokens.json`: art direction + visual source.
3. `design/03-components.md`, `design/04-screens.md`: component/screen/state contracts. Read assigned feature first.
4. `design/05-swiftui-handoff.md`: implementation + QA contract.

`design/preview/index.html`: 1.2 visual example; five 1.3 changes absent. Docs own behavior. Never copy fixed date, sample data, simulated permissions into product logic. Graph provenance predates #18; recheck source docs. Graph update only after merge.

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

Resolve kickoff items in plan. Foundation → components → screens/storage → notifications/calendar → accessibility/real use. Current work: development rules + AI review workflow merged. Foundation implementation/verification: #4; sequential features: `docs/development/implementation-plan.md`. Personal iPhone 15 Pro target; signing/device validation pending.

MVP excludes Mac, CloudKit, server, account, payment. Native SwiftUI; no HTML WebView wrapper. Tests map to plan acceptance criteria.

`docs/.archive/`: historical reviews + compression originals; exclude default reads. Read `design/reference/user-design-brief.txt` only for source conflicts.

Technical decision: `docs/adr/0001-native-ios-foundation.md`. Data contracts: `docs/development/data-contracts.md`. Local build: `docs/development/local-development.md`.
