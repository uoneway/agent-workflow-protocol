# 프로토콜 리뷰 제안 — persquad 실적용 (Round 1~2)

- 근거: [round-01](./persquad-round-01-transplant.md), [round-02](./persquad-round-02-first-slice.md), [round-03](./persquad-round-03-promote.md)
- 마찰 28건, 리뷰 트리거(10건)의 2.8배
- **이 문서는 제안이다.** 프로토콜 본문은 리뷰에서 확정된 변경만 수정한다.

이미 처리한 것은 여기 없다. 스킬 레벨에서 실증과 함께 확정된 4건(cold-read 개정)과 setup-workflow 초안 보강 3건은 각 파일에 반영했다. **아래는 프로토콜 본문을 건드려야 하는 것들이다.**

---

## 군집 1 — 브랜치에 있는 agent가 main 전용 자원에 닿는 방법 *(최우선)*

마찰 5·8·9·10·22·24. **6건이 한 뿌리다.**

### 문제

프로토콜은 두 가지를 동시에 요구하는데, 실행하면 충돌한다.

- §4 Develop: "scope 밖이면 → `docs/BACKLOG.md`"
- §Parallel Workstreams: "`BACKLOG.md`는 main에서만 갱신한다"

Develop 단계의 agent는 정의상 workstream 브랜치에 있다. **한 규칙이 다른 규칙을 실행 불가능하게 만든다.** park의 존재 이유가 "착지 지점이 항상 이 두 곳뿐이라는 확신이 열린 루프를 닫는다"인데, 두 곳 중 하나가 도달 불가능하면 그 확신이 성립하지 않는다.

같은 뿌리에서 파생된 것들:

| 마찰 | 내용 |
| --- | --- |
| 5 | Kickoff은 "전이 커밋을 main에서"를 요구하는데 배경 에이전트 세션은 worktree 격리로 시작해 main에 있을 수 없다 |
| 9 | 결정 ID 전역 연번의 **동시 할당 규칙이 없다** — 병렬 worktree 둘이 같은 번호를 잡으면 |
| 10 | `decision-logs/`·`ARCHITECTURE.md`를 브랜치에서 쓰는지 main에서 쓰는지 명시가 없다 (§Parallel Workstreams는 PROJECT_STATE·BACKLOG만 지정) |
| 22 | 앞 workstream이 머지되지 않으면 뒤 workstream이 시작할 main이 없어 PR 하나에 여러 작업이 쌓인다 |
| 24 | kickoff이 만든 worktree에 세션이 **자동으로 들어가지 않는다** — 프로토콜은 전환 행위를 규정하지 않고 사람의 `cd`를 암묵 가정 |

### persquad에서 쓴 잠정 규약 (실제로 동작함)

레포 `AGENTS.md`의 마커 밖에 기록했고, Round 2 전체를 이 규약으로 완주했다.

- `PROJECT_STATE.md`·`BACKLOG.md`만 main 전용. **나머지는 쓰는 시점이 브랜치를 결정한다** — `decision-logs/`는 kickoff(main)·Develop(브랜치)·promote(main) 셋 다 가능
- scope 밖 park는 workstream 문서의 `Parked (out of scope)` → **promote가 main에서 BACKLOG로 이관**
- 결정 ID는 브랜치에서 잠정 할당 → promote에서 main의 최대값으로 확정, 충돌 시 나중 merge 쪽이 재번호. 프로토콜이 이미 "인용은 경로가 아니라 ID로"를 규정했으므로(P-0003) 재번호 비용은 grep 치환이다 — **이 규약이 성립하는 근거가 기존 설계에 이미 있었다**
- worktree는 `.claude/worktrees/<slug>` (kickoff의 sibling 규약 대신)

### 제안

1. **§4 park 규칙 개정** — scope 밖 착지점을 브랜치 상태로 분기한다. main이면 BACKLOG, 브랜치면 workstream 문서의 `Parked (out of scope)`.
2. **§6 promote에 이관 단계 추가** — `Learnings` 이관과 같은 자리에서 `Parked` 항목을 BACKLOG로 옮긴다. **promote 스킬의 7단계에 이 단계가 없다** — 레포가 각자 발명하게 두면 안 된다.
3. **§Parallel Workstreams에 결정 ID 동시성 규칙 명문화** — 위 잠정 규약대로.
4. **§Parallel Workstreams에 "main 전용은 이 둘뿐"을 명시적 열거로** — 현재는 두 파일만 언급하고 나머지의 지위가 추론에 맡겨져 있다.
5. **kickoff에 worktree 진입을 명시** — 만들고 보고하는 데서 끝내지 않는다. 실행 환경에 따라 명시적 전환(`EnterWorktree` 등)이 필요하다.

### 열린 결정

마찰 5·22는 **"배경/무인 에이전트가 main에 있을 수 없다"**는 실행 환경 사실에서 온다. 프로토콜이 이를 받아들일지(전이 커밋의 "main"을 "workstream 브랜치가 아닌 곳"으로 완화), 아니면 실행 환경 규약으로 남길지가 결정 사항이다.

---

## 군집 2 — 스킬 간 접합면

마찰 11·13·14·15·16·17. 각 스킬은 잘 쓰였으나 **스킬 A가 만든 상태를 스킬 B가 찾는 방법이 비어 있다.**

| 마찰 | 접합면 |
| --- | --- |
| 13 | kickoff이 "승인된 workstream 합의"에 게이트하는데 **승인이 어디 기록되는지** 없다. 승인은 align이 받는다 |
| 17 | kickoff이 "이슈에 시작을 기록"하고 promote가 "연관 이슈를 닫는데", 그 연결을 어디에 적어 나중 세션이 되찾는지 없다 |
| 16 | kickoff 1단계가 항목이 BACKLOG에 있다고 가정하는데, 이슈 트래커 레포에서 셰이핑 완료 항목은 **정의상 BACKLOG에 없다**(align 출구에서 제거됨) |
| 15 | promote가 "merge 후"만 말하고 누가 merge하는지·PR 필요 여부·squash 여부가 없다 |
| 14 | 단계 6개 중 **Develop·Resume에 스킬이 없다.** Skill routing이 4개만 매핑하고 두 단계의 실행 근거가 어디에도 없다 |
| 11 | kickoff의 sibling worktree(`../<repo>-<slug>`)와 Claude Code의 `.claude/worktrees/`가 충돌 |

**추가 (Round 3)**: 마찰 27 — **promote 5단계와 6단계의 경계가 없다.** 5단계는 "새로 드러난 repo 전체 작업 규칙 → `AGENTS.md`", 6단계는 "Learnings → `LEARNINGS.md`, 반복 확인되면 `AGENTS.md`"다. 그런데 이번 Learnings에는 명백히 작업 규칙인 것이 섞여 있었다 — "상태를 바꾸는 Orca 명령을 탐색 목적으로 실행하지 마라"는 되돌릴 수 없는 작업이라 반복 확인을 기다릴 이유가 없다. 6단계를 문자 그대로 따르면 두 번째 workstream까지 버퍼에 머문다. **제안**: 승격 기준에 "위반의 대가가 되돌릴 수 없으면 반복 확인을 기다리지 않는다"를 추가.

**제안**: 접합면을 스킬 본문이 아니라 **workstream 문서의 고정 필드**로 옮긴다. 승인 여부·이슈 번호·PR 번호가 workstream 문서에 있으면 kickoff·promote가 그것을 읽으면 되고, 스킬끼리 규약을 맞출 필요가 없다. 문서가 이미 handoff 역할을 맡고 있으므로(Document Index) 새 메커니즘이 아니다.

14는 별개 판단이다. Develop·Resume에 스킬이 없는 것이 의도인지(상시 규칙이라 스킬이 불필요) 공백인지 결정해야 한다.

---

## 군집 3 — 무인 실행 가정

마찰 2·12·18·21.

프로토콜과 스킬은 **사용자가 옆에 있는 대화형 세션**을 전제한다. 실제로는 무인 배경 세션에서 돌아갔고 그때 드러난 것들이다.

**가장 중요한 발견**: align의 네 갈래 라우팅 중 "사용자의 선호·권한에 속하면 → 사용자에게 묻는다"는 두 가지를 하나로 묶고 있는데, 무인 실행에서 **성질이 완전히 다르다.**

- **선호**는 리서치와 전제 도전으로 근거를 세워 대체할 수 있다. 이번에 기술 스택 결정이 그랬고, decision-log에 남겨 사용자가 뒤집을 수 있게 했다. 막히지 않았다.
- **권한**은 대체 불가다. `orca repo add`는 되돌릴 수 없는 외부 작용이라 승인 없이 실행할 수 없었고, 그 지점에서 실제로 막혔다.

**제안**: §2 grill 라우팅에서 선호와 권한을 분리한다. 선호는 무인 실행에서 "근거 있는 결정 + decision-log 기록"으로 진행할 수 있고, 권한은 진행할 수 없다.

관련하여 12(작업 크기 임계가 `non-trivial`·`workstream-scale`·`substantial`·`workstream-sized`·`small enough` 다섯 표현인데 정의가 하나도 없음)도 같은 성격이다. 사람이 옆에 있으면 "이건 큰 작업인가요"로 넘어가지만 무인 실행에는 판정 기준이 필요하다.

21은 별도: **align의 프로토타입 핸드오프가 되돌릴 수 없는 외부 부작용을 요구할 때의 규정이 없다.** 프로토콜은 프로토타입의 비용을 시간으로만 상정한다.

---

## 군집 4 — 이미 처리한 것 (기록용)

| 마찰 | 처리 |
| --- | --- |
| 1 | `marker-hash.sh` 신설 — 초안이 해시를 요구하면서 계산 도구를 동봉물에 안 넣었음 |
| 6 | pre-flight에 `decision_last_number` 추가 |
| 7 | setup-workflow ⑤와 cold-read 본문 개정 — 감사 대상 = 문서 + 라우팅된 것 |
| 2 | setup-workflow ②D에 무인 실행 규칙 명문화 |
| 3 | setup-workflow ④2에 매핑 우선순위 명문화 |
| 19 | persquad `AGENTS.md`의 봉합 3건 수정 (2차 cold-read가 검출) |
| 20 | cold-read 종료 조건에 세 번째 갈래 추가 |
| 23 | cold-read 적용 대상을 만료되는 문서로 한정 |
| 25 | cold-read 사각지대 명시 — 감사는 거짓을 못 잡는다 |

---

## 남은 것

**마찰 4** — 마커 블록의 원문 링크가 link-workflow 공개 여부에 걸려 있다. 현재 remote가 없어 생략했고, 그 결과 이식된 레포에서 프로토콜 원문에 도달할 경로가 사라졌다. 검토점 3의 논의는 "로컬 경로 vs URL"이었지 "URL 없음"의 경우를 계산하지 않았다.

**setup-workflow 승격** — 동봉물 검증은 끝났다(승격 계약 2번 충족). 남은 것은 계약 1번(결정 완료): `SKILL.md` 영어 실행본 저작과 마찰 4의 해소. **초안이 아니라 리뷰가 병목이다.**
