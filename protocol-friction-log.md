# Protocol Friction Log

AGENT_WORKFLOW_PROTOCOL.md 운영 중 마주친 마찰의 로그. **프로토콜 자신을 위한 BACKLOG**다 — 마찰을 느낀 순간 프로토콜을 고치러 가지 말고(park, don't chase), 한 줄 남기고 하던 작업으로 복귀한다.

## 기록 규칙

- 한 줄이면 충분하다: `- 날짜 | repo | 유형 | 내용`
- 유형은 4가지. 각각 리뷰 때의 처리 경로가 다르다:
  - `어색` — 프로토콜 규칙이 방해가 되거나 이상했던 순간 → 프로토콜 수정 후보
  - `공백` — 프로토콜에 답이 없는 상황을 만난 순간 → 프로토콜 보강 후보
  - `반복` — 같은 지시를 다시 타이핑한 순간 → **스킬 결정화 후보.** 지시문을 요약하지 말고 그대로 붙여넣는다. 그 자연스러운 문장이 미래 스킬의 초안이다 ("적절한 순간의 적절한 단어")
  - `위반` — agent가 프로토콜을 어긴 순간 → 대상 repo의 AGENTS.md 규칙 강화 후보
- **중복 제거하지 않는다.** 같은 마찰이 또 나오면 또 적는다. 몇 회째인지 세지도 않는다 — 빈도 집계는 리뷰 세션의 일이고, 중복 자체가 데이터다.
- **캡처 시점에 해석하지 않는다.** "그러니까 §4를 이렇게 바꿔야…" 같은 진단은 리뷰의 일이다. 사실만 기록한다.
- 캡처 비용이 20초를 넘으면 안 된다. 세션 중이면 agent에게 **"마찰: ..."** 로 시작하는 메시지를 보내는 게 가장 싸다 (전역 CLAUDE.md에 append 규칙 있음).

## 리뷰 규칙

- 주기: 2~3주마다, 또는 항목 10개 도달 시 — 먼저 오는 쪽.
- 리뷰는 grill 세션으로 진행한다: 클러스터링 → 빈도 집계 → 항목별로 {프로토콜 수정 / 스킬 결정화 / AGENTS.md 강화 / 기각} 결정.
- 처리한 항목은 로그에서 삭제하고, 결정은 AGENT_WORKFLOW_PROTOCOL.md의 변경 이력에 남긴다.

## 로그

<!-- 예: - 2026-07-08 | myapp | 반복 | "셰이핑 끝났으니 scope랑 behavior notes는 workstream 문서로, ADR급 결정은 decision-logs로 착지시켜줘" -->

- 2026-07-10 | skill-guide 폐기 | 공백 | 격주 정비 패스(codebase-design 어휘로 deep module 후보 탐색) 아이디어가 폐기된 skill-guide에만 있었음 — 프로토콜 편입 여부 리뷰 필요
- 2026-07-10 | skill-guide 폐기 | 공백 | "규모가 크면 grill 전에 그릴 가능한 덩어리로 쪼개고 덩어리별 별도 세션" 요령이 프로토콜 §2에 없음 — Align 앞수(⓪)로 편입 검토
- 2026-07-26 | persquad 이식 | 어색 | 마커 블록의 원문 링크가 link-workflow 공개 여부에 걸려 있어, 미공개 상태에서 이식하면 프로토콜 원문 도달 경로가 아예 사라짐
- 2026-07-26 | persquad 이식 | 어색 | 배경 에이전트 세션의 강제 worktree 격리와 프로토콜 §3 Kickoff의 "전이 커밋을 main에서" 요구가 충돌 — agent가 main에 있을 수 없음
- 2026-07-26 | persquad 이식 | 공백 | 프로토콜 §4 park의 "scope 밖 → docs/BACKLOG.md (main에서만)"가 브랜치/worktree에서 작업 중인 agent에게 실행 불가능한 지시 — 대체 착지점이 없음
- 2026-07-26 | persquad 이식 | 공백 | 결정 ID 레포 전역 연번의 동시 할당 규칙이 없음 — 병렬 worktree 둘이 같은 번호를 잡는 경우의 처리 미정의
- 2026-07-26 | persquad 이식 | 공백 | `docs/decision-logs/`·`ARCHITECTURE.md`를 브랜치에서 쓰는지 main에서 쓰는지 프로토콜에 명시 없음 — §Parallel Workstreams는 PROJECT_STATE·BACKLOG만 main 전용으로 규정
- 2026-07-26 | persquad 이식 | 어색 | kickoff은 sibling worktree(`../<repo>-<slug>`)를 명시하는데 Claude Code의 EnterWorktree·배경 세션은 `.claude/worktrees/<name>`을 씀 — 두 규약 중 어느 쪽이 이기는지 없음
- 2026-07-26 | persquad 이식 | 공백 | 작업 크기 임계가 align·kickoff에서 다섯 표현(non-trivial, workstream-scale, substantial, workstream-sized, small enough to begin directly)으로 나타나는데 어느 것도 정의되지 않음
- 2026-07-26 | persquad 이식 | 공백 | kickoff이 "approved workstream agreement exists"에 게이트하는데 승인이 어디에 기록되는지 규정 없음 — workstream 문서 존재 자체가 승인 증거인지 불명
- 2026-07-26 | persquad 이식 | 공백 | 프로토콜 단계 6개 중 Develop·Resume에 대응하는 스킬이 없어 Skill routing이 4개만 매핑 — 두 단계의 실행 근거가 스킬에도 마커 블록에도 없음
- 2026-07-26 | persquad 이식 | 공백 | promote가 "run only after merge"라고만 하고 누가 merge하는지, PR이 필요한지, squash 여부가 없음
- 2026-07-26 | persquad 이식 | 어색 | kickoff 1단계가 항목이 `BACKLOG.md`에 있다고 가정하는데, 이슈 트래커를 쓰는 레포에서 셰이핑 완료 항목은 정의상 BACKLOG에 없음 (align 출구에서 이미 제거됨)
- 2026-07-26 | persquad 이식 | 공백 | 이슈 번호를 workstream과 잇는 위치가 규정되지 않아 나중 세션이 연결을 재발견할 방법이 없음 — kickoff은 "records the start on its issue", promote는 "close an associated issue"만 말함
- 2026-07-26 | persquad 이식 | 공백 | promote가 요구하는 "concrete evidence"의 기준이 코드 없는 문서 전용 변경에 대해 정의되지 않음
- 2026-07-26 | persquad 슬라이스1 align | 공백 | align의 프로토타입 핸드오프가 되돌릴 수 없는 외부 부작용을 요구할 때의 처리가 없음 — `orca repo add`는 remove 명령이 없어 되돌릴 수 없고, 사용자 부재 세션에서는 승인도 받을 수 없어 grill이 막힘
- 2026-07-26 | persquad 슬라이스1 align | 어색 | 배경 세션에서 workstream을 순차 실행할 때 앞 workstream의 PR이 머지되지 않으면 뒤 workstream이 main에서 kickoff할 수 없음 — 한 세션에 여러 workstream이 쌓이면 PR 하나가 여러 작업을 담게 됨
- 2026-07-26 | persquad 슬라이스1 develop | 어색 | kickoff이 만든 worktree에서 세션이 바로 편집할 수 없음 — 자기가 만든 worktree인데도 격리에 막혀 EnterWorktree로 명시적 전환이 필요. kickoff은 worktree를 "만들고 보고"할 뿐 "들어간다"고 말하지 않음
- 2026-07-26 | persquad promote | 공백 | promote 5단계(새 repo 전체 규칙 → AGENTS.md)와 6단계(Learnings → LEARNINGS.md, 반복 확인되면 AGENTS.md)의 경계가 없음 — 위반의 대가가 되돌릴 수 없는 규칙은 반복 확인을 기다릴 이유가 없는데 6단계를 문자 그대로 따르면 두 번째 workstream까지 버퍼에 머무름
- 2026-07-26 | persquad promote | 어색 | promote의 "저장소 지침이 요구하지 않는 한 자동 커밋 금지"와 배경 에이전트 세션의 "커밋·push·PR 필수"가 충돌 — 단서 조항으로 해소되나 실행 하니스의 규칙이 "저장소 지침"에 해당하는지 불명확
