# kickoff — 초안

베이스: 없음 — 프로토콜 §3 체크리스트의 직역. (skill-guide가 "이 지시가 반복되는 순간이 첫 스킬이 태어나는 순간"이라 지목한 바로 그 지시문.) 호출 방식: user-invoked.

```yaml
name: kickoff
description: align이 끝난 작업을 실제로 시작할 때. 사용자가 "시작하자", "kickoff"라고 하면 사용. align을 거치지 않은 작업이면 먼저 align이 필요한지 확인.
```

> `[검토점]` description 마지막 문장 — kickoff가 align 게이트를 우회하는 뒷문이 되는 걸 막으려는 것. 단 사소한 작업(align 자체를 안 하는)까지 막으면 과절차. "확인"이면 충분한가, 아니면 빼야 하나.

---

## 본문

전제 확인: workstream 초안(합의부)이 있는가. 없으면 사용자에게 align부터 할지, 초안 없이 시작할 만큼 작은 작업인지 물어라. 작은 작업이면 kickoff 없이 그냥 시작하는 게 맞다 — 이 스킬은 workstream 규모의 작업 전용이다.

> `[신규]` 자기 자신의 적용 범위를 좁히는 문장. gstack류 시스템이 모든 작업을 파이프라인에 태우는 것과 반대 방향 — 프로토콜의 최소주의.

main에서 한 커밋으로 시작 전이를 만들라:

1. `docs/BACKLOG.md`에서 해당 항목 제거. 이슈 트래커에서 넘어온 작업이면 이슈에 착수를 코멘트로 남겨라 — 이슈는 promote 때 근거 커밋과 함께 닫는다
2. `docs/PROJECT_STATE.md`에 active 등록 — 이름, 상태, owner, 상세 링크만
3. `docs/workstreams/<slug>.md` 생성 — align 초안을 합의부로, 상태부는 뼈대(Current State: 착수 전 / Next Step: 첫 슬라이스)
4. align에서 나온 decision-log 초안이 있으면 `docs/decision-logs/`에 착지. 착지하는 순간 결정마다 레포 전역 연번 ID(마지막 번호 +1)를 부여해 히스토리 항목 제목에 박고, 같은 파일의 `Current Decision`을 갱신하라. 이후 인용은 파일 경로가 아니라 ID로

> `[가져옴 · 프로토콜 §3]` 체크리스트 그대로. 스킬은 프로토콜의 실행자일 뿐 새 규칙을 만들지 않는다 (저작규율 4).
> `[신규 · 프로토콜 §4 결정 ID 규약, 2026-07-10]` 4의 ID 부여 — 초안 단계에는 ID가 없고, 기준 문서로 착지하는 순간이 부여 시점. 1의 이슈 코멘트 — 이슈 트래커 경계 규칙(같은 개정)의 kickoff 쪽 실행.
> `[검토점]` ID 규약 lint(ai-tab은 `scripts/lint-decision-logs.sh`를 pre-commit에 연결)를 스킬이 언급할지 — repo마다 존재가 달라 AGENTS.md 몫일 수도.

커밋 후 branch/worktree를 만들라. 이름은 workstream slug를 따른다 (`feat/<slug>`, worktree는 `../repo-<slug>`). 이후 이 branch에서는 `docs/workstreams/<slug>.md`만 갱신한다 — `PROJECT_STATE.md`·`BACKLOG.md`는 main 전용이다.

> `[가져옴 · 프로토콜 §3 + Parallel Workstreams]` main-only 규칙의 실행 시점 상기.
> `[참조 · obra using-git-worktrees]` worktree 명명 관례 정도만. superpowers는 worktree 생성·정리에 별도 스킬을 두지만 우리는 kickoff/promote에 인라인 — 조건부가 아니라 무조건 단계라서 (저작규율 3).

끝나면 한 줄로 보고하라: 만든 것(커밋·branch·worktree 경로)과 첫 슬라이스가 무엇인지.

> `[검토점]` worktree 생성까지 스킬이 자동으로 할지, 경로만 제안하고 사용자가 만들지. 단일 repo 단일 branch로 일할 때는 worktree가 불필요 — "병렬 작업일 때만 worktree" 분기를 넣을지.
