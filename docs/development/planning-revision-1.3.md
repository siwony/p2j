# 기획 1.3 변경 인계

2026-10-04 · [#18](https://github.com/siwony/p2j/issues/18) · Policy adopted by user; app implementation pending.

Sources: [제품 정책·AC](../product-plan.md), [화면](../../design/04-screens.md), [데이터 계약](data-contracts.md). This file routes changes; no separate policy source.

## 변경표

| 변경 | 1.2 → 1.3 | AC | 구현 이슈 |
| --- | --- | --- | --- |
| 남은 일정 쉬기 | Empty week only → current-week unfinished batch skip; preserve completed/intervals; restore same IDs | AC-03/04/06/07/12/14 | #8 command, #9 running atomicity, #11 alarms, #12 calendar |
| 놓친 일 다시 고르기 | Recovery entry unspecified → quiet Today→Week action; current-week past planned/paused; default none; selected IDs move | AC-02/03/11/12/14 | #8 entry + plan, #9 execution integration |
| 실제 수행일 | Completion-entry date aggregation → editable `performedOn`; preserve entry timestamp + measured intervals; refresh both weeks | AC-05/10/11/12 | #9 edit/model, #10 grouping |
| 주별 캘린더 연결 | Existing changes auto, new items manual → explicit per-week opt-in; additions/changes automatic; disconnect suspends writes, keeps events | AC-07/08/11/12 | #12, plan interfaces #8 |
| 행동 우선 기록 | Time first → completed rows, routine counts, optional time, memo. All nil time → no aggregate row | AC-05/10/14 | #10, QA #13 |

## 에이전트 착수

1. Read assigned row → revised AC → screen/data source. Old 1.2 policy superseded.
2. Check existing issue body for #18 section. Record applied spec `1.3` + relevant AC in implementation PR.
3. Before edit: owner/path/dependencies with lead. #8 owns Today recovery entry; #9 follows for execution. Shared model/project single owner.
4. Implement assigned scope; include changed acceptance cases. Report actual result + unverified integrations. No feature-complete claim from this docs PR.

Human plan/design: readable Korean. Agent routing/contracts: caveman; preserve paths/APIs/conditions/negations. No external compression API required.

## 시나리오와 책임

| ID | 상황 → 기대 결과 | 책임 |
| --- | --- | --- |
| R13-01 | Current week: completed + past planned + paused + running + prior skipped. Confirm rest → only confirmed unfinished skipped, running interval saved/stopped. Other week unchanged | #8/#9 |
| R13-02 | Rest cancel/save failure → all original state; retry → no duplicate transitions. Restore chosen item → same ID/history; later added item remains normal | #8/#9 |
| R13-03 | Monday missed, Tuesday open → quiet recovery entry, no badge/push. Choose one → same ID moves; unchosen/cancel unchanged. Skipped/prior-week items excluded | #8; alerts #11 |
| R13-04 | Sunday plan missed or weeks away → remaining-week planner; no past-date filling, forced memo, auto carryover | #8/#13 |
| R13-05 | Sunday action entered Monday → Week prior-week planned/paused row, one-tap same-ID completion, optional performed-date correction to Sunday. Two week counts/time update; timestamp/intervals/plan/calendar/memo unchanged | #9/#10 |
| R13-06 | Future performed date rejected; cancel keeps old aggregation, discards edit draft; save failure keeps draft + old aggregation. Nil/0/subminute remain distinct after correction/time-zone change. Monday complete→undo→Tuesday recomplete uses Tuesday capture/default performed date; intervals/time preserved | #9/#10 |
| R13-07 | Connect week, then add/move/rest/restore → automatic reconciliation; missing expected duration pending, filled later → retry. Next/copied week off | #12 |
| R13-08 | Pending export then disconnect → no later queued write; events/links retained. Reconnect + external edit/delete → explicit choice, no duplicate | #12 |
| R13-09 | Move occurrence between weeks: on/on, on/off, off/on, off/off. Honor source/destination consent, reuse matching links, preserve external edits | #8/#12 |
| R13-10 | Rest/replan/restore with normal/group/snooze requests → replace/cancel affected only. Weekly planning preference unchanged; OS failure separate from app commit | #11 |
| R13-11 | All completions untimed → rows/counts visible, no zero-time aggregate or recording prompt. Mixed times remain secondary; memo optional | #10 |
| R13-12 | Native small screen/large type/VoiceOver: rest, recovery, date edit, connection control accessible. Actual use: recovery effort + record burden; absent life cases remain unverified | #13 |

## 적용 상태와 후속

- This revision: plan/screens/components/contracts/AC + agent entry docs. Existing #8–#13 issue scopes updated; no duplicate feature issues.
- App source, tests, tokens, HTML behavior unchanged. HTML remains 1.2 example; use current screen order/policies.
- Graph remains last main index. No branch generation. After merge: lead records main SHA in #18 and updates graph under existing workflow; do not infer 1.3 from old graph.
- Implementation status: [단계/소유권](implementation-plan.md). New actual verification belongs to implementation PRs + #13.
