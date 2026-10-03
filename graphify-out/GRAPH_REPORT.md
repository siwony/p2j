> 분석 기준: main `e79677d29b4798b4cca1df95e41d7ccc208b5160` (이슈 #1, PR #2). 현재 작업 브랜치나 이후 main 변경은 포함하지 않는다.
> 이 저장소는 기획·디자인·협업 문서 단계이며, 그래프의 AC 연결은 구현/테스트 완료를 뜻하지 않는다.
> 의미 추출·한국어 라벨: 현재 Codex 하위 에이전트 세션. 모델 및 세션별 토큰 사용량은 제공되지 않아 알 수 없음. 외부 LLM API를 사용하지 않았다.

# Graph Report - ptoj  (2026-10-04)

## Corpus Check
- Corpus is ~17,439 words - fits in a single context window. You may not need a graph.

## Summary
- 93 nodes · 190 edges · 11 communities
- Extraction: 86% EXTRACTED · 14% INFERRED · 0% AMBIGUOUS · INFERRED: 26 edges (avg confidence: 0.94)
- Token cost: 알 수 없음 input · 알 수 없음 output

## Graph Freshness
- Built from commit: `e79677d2`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- main 병합 뒤에만 현재 AI 세션으로 graphify를 갱신한다. 토큰 비용은 미확인이다.

## Community Hubs (Navigation)
- 루틴 실행과 화면 탐색
- 이슈 리뷰와 병합 운영
- 기획 인계와 디자인 방향
- 시각 기준과 접근성 검증
- 주간 계획과 공통 구성
- 실행 기록과 날짜 보존
- 커밋 규칙 검사 도구
- 완료 기록과 주간 메모
- 제품 원칙과 캘린더 반영
- 저장 실패와 복구 흐름
- 실행 알림과 설정

## God Nodes (most connected - your core abstractions)
1. `한 주 iPhone MVP` - 23 edges
2. `Today 오늘 화면` - 5 edges
3. `Week 이번 주 화면` - 5 edges
4. `Records 기록 화면` - 5 edges
5. `독립 리뷰와 통합` - 5 edges
6. `단일 실행 시간 기록` - 4 edges
7. `Apple 캘린더 단방향 반영` - 4 edges
8. `캘린더 실패와 외부 변경` - 4 edges
9. `기기 내 오프라인 저장` - 4 edges
10. `생활 시각과 완료 날짜 보존` - 4 edges

## Surprising Connections (you probably didn't know these)
- `AC-12 탐색과 입력 취소` --conceptually_related_to--> `네이티브 탭과 시트 탐색`  [INFERRED]
  docs/product-plan.md → design/05-swiftui-handoff.md
- `AC-02 다음 주 계획` --conceptually_related_to--> `Week 이번 주 화면`  [INFERRED]
  docs/product-plan.md → design/04-screens.md
- `AC-14 부담 없는 사용` --conceptually_related_to--> `정돈한 생활의 페이지`  [INFERRED]
  docs/product-plan.md → design/01-direction.md
- `차분한 숲빛 강조색` --conceptually_related_to--> `시맨틱 디자인 토큰`  [INFERRED]
  design/01-direction.md → design/tokens.json
- `제안 기술 구성` --conceptually_related_to--> `기기 내 오프라인 저장`  [EXTRACTED]
  design/05-swiftui-handoff.md → docs/product-plan.md

## Import Cycles

실제 코드 순환 의존은 없다. 아래 1-file cycle은 Python 표준 라이브러리 노드의 source_file에 import 근거 위치를 기록하면서 생긴 graphify 파일 투영 결과다. re·subprocess·sys·pathlib은 저장소 파일이 아니다.

- 1-file cycle: `.githooks/commit-msg -> .githooks/commit-msg`

## Communities (11 total, 0 thin omitted)

### Community 0 - "루틴 실행과 화면 탐색"
Cohesion: 0.19
Nodes (15): ActiveRoutinePanel, Routine Editor 편집 시트, Execution, Routine Library 루틴함, PlannedOccurrence, Reschedule 일정 이동, RoutineTemplate, Running Routine 실행 화면 (+7 more)

### Community 1 - "이슈 리뷰와 병합 운영"
Cohesion: 0.21
Nodes (9): 에이전트 파일 소유권, 중요 기술 결정 ADR, 이슈 연결 Git 규칙, 독립 리뷰와 통합, 이슈부터 시작, 현재 AI 의미 추출과 라벨, main 병합 후 그래프 갱신, 그래프 출처와 무결성 (+1 more)

### Community 2 - "기획 인계와 디자인 방향"
Cohesion: 0.36
Nodes (4): 정돈한 생활의 페이지, 차분한 숲빛 강조색, 제안 기술 구성, 사용자 디자인 원문

### Community 3 - "시각 기준과 접근성 검증"
Cohesion: 0.22
Nodes (9): 처음부터 접근성 지원, 의미 있는 대비 기준, 한국어 시스템 서체, 디자인 프리뷰의 검증 경계, 네이티브 검증 계약, 지정 색 조합 대비 결과, 로컬 디자인 시뮬레이션, 시맨틱 디자인 토큰 (+1 more)

### Community 4 - "주간 계획과 공통 구성"
Cohesion: 0.29
Nodes (7): CalendarSyncState, 실제 공유 UI 추출, WeekDaySelector, CalendarSheet 반영 상태, Week 이번 주 화면, 기능별 폴더 구조, AC-02 다음 주 계획

### Community 5 - "실행 기록과 날짜 보존"
Cohesion: 0.43
Nodes (6): AC-11 오프라인과 날짜 변경, 미기록과 실제 시간 구분, 단일 실행 시간 기록, 기기 내 오프라인 저장, 생활 시각과 완료 날짜 보존, 주간 계획 선택과 확정

### Community 6 - "커밋 규칙 검사 도구"
Cohesion: 0.29
Nodes (5): Validate project commit conventions without third-party dependencies., Python pathlib, Python re, Python subprocess, Python sys

### Community 7 - "완료 기록과 주간 메모"
Cohesion: 0.33
Nodes (6): WeekMemo 입력, Records 기록 화면, AC-05 직접 완료와 수정, AC-09 주간 메모, AC-10 과거 기록과 주 경계, 선택적 주간 메모

### Community 8 - "제품 원칙과 캘린더 반영"
Cohesion: 0.60
Nodes (5): AC-07 캘린더 생성과 갱신, AC-14 부담 없는 사용, Apple 캘린더 단방향 반영, 부담 없는 계획과 재시작, 한 주 iPhone MVP

### Community 9 - "저장 실패와 복구 흐름"
Cohesion: 0.50
Nodes (4): 초안 보존과 저장 결과, AC-08 캘린더 실패와 외부 수정, AC-12 탐색과 입력 취소, 캘린더 실패와 외부 변경

### Community 10 - "실행 알림과 설정"
Cohesion: 0.67
Nodes (3): Settings 설정 화면, AC-06 알림, 로컬 실행 알림

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `한 주 iPhone MVP` connect `제품 원칙과 캘린더 반영` to `루틴 실행과 화면 탐색`, `기획 인계와 디자인 방향`, `시각 기준과 접근성 검증`, `주간 계획과 공통 구성`, `실행 기록과 날짜 보존`, `완료 기록과 주간 메모`, `저장 실패와 복구 흐름`, `실행 알림과 설정`?**
  _High betweenness centrality (0.239) - this node is a cross-community bridge._
- **Why does `이슈 연결 Git 규칙` connect `이슈 리뷰와 병합 운영` to `커밋 규칙 검사 도구`?**
  _High betweenness centrality (0.143) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Records 기록 화면` (e.g. with `AC-05 직접 완료와 수정` and `AC-10 과거 기록과 주 경계`) actually correct?**
  _`Records 기록 화면` has 2 INFERRED edges - model-reasoned connections that need verification._

## 입력과 검증 범위

- 입력 19개(코드 1개, 의미 추출 문서·디자인 18개); 전 파일에 source_file 노드가 있다.
- 93 노드, 190 관계, 11 커뮤니티. 원문 경로와 L줄번호를 검증했다.
- 누락 endpoint 0, dangling endpoint 0, 자기참조 0, 중복/축소 관계 0.
- 연결 성분 1, degree 0 노드 0.
- 아래 낮은 연결도/얇은 커뮤니티 안내는 코드 완성도 평가가 아닌 그래프 구조 진단이다.
- 문서 AC와 화면 연결의 INFERRED 관계는 설계 대응이며 구현 보장이 아니다.

## 실행 주의와 한계

- graphify 탐지는 design/tokens.json을 민감 파일명으로 오탐했다. 공개 디자인 값임을 확인한 뒤 의미 추출 입력에 명시적으로 포함했다.
- 입력은 19개 현재 문서·디자인·개발 파일이다. skills-lock.json은 설치 스킬 의존 메타데이터, .gitignore는 운영 설정으로 제외했다.
- 모델 ID·세션별 입력/출력 토큰 및 비용은 제공되지 않았다. 0으로 간주하지 않는다.
- 원본은 기획 단계다. 제안 기술과 미정 착수 항목은 이 SHA의 문서 상태이며 실제 구현 또는 최신 사용자 결정을 뜻하지 않는다.
- 의미 그래프는 주요 개념을 선별한 탐색 인덱스다. 원문 모든 문장·컴포넌트의 완전한 추출을 보장하지 않는다.

## 분석 입력 목록

- `.githooks/commit-msg`
- `.github/ISSUE_TEMPLATE/bug.md`
- `.github/ISSUE_TEMPLATE/task.md`
- `.github/pull_request_template.md`
- `AGENTS.md`
- `CONTRIBUTING.md`
- `DEVELOPMENT_HANDOFF.md`
- `README.md`
- `design/01-direction.md`
- `design/02-foundations.md`
- `design/03-components.md`
- `design/04-screens.md`
- `design/05-swiftui-handoff.md`
- `design/contrast-report.json`
- `design/preview/index.html`
- `design/reference/user-design-brief.txt`
- `design/tokens.json`
- `docs/development/graphify.md`
- `docs/product-plan.md`
