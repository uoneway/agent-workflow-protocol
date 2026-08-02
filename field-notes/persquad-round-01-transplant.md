# persquad · Round 01 — 워크플로우 이식

- 날짜: 2026-07-26
- 적용 레포: `persquad` (github.com/uoneway/persquad, private)
- 실행한 스킬: `setup-workflow`(초안, 수동 실행) · `cold-read`
- 프로토콜 버전: P-0012

## Round 목표

| 축 | 목표 |
| --- | --- |
| 서비스 | persquad를 문서 한 덩어리(`product-concept.md` 216줄)에서 프로토콜이 상정하는 문서 층으로 옮긴다. 다음 회차가 align부터 바로 시작할 수 있는 상태를 만든다. |
| 플로우 | `setup-workflow` 초안의 승격을 막고 있던 미구현 동봉물을 실제 이식으로 검증하며 구현한다. |

이 회차를 첫 번째로 고른 이유: persquad는 아직 이식되지 않은 레포였고, `setup-workflow`는 6개 확정 스킬 중 유일하게 초안으로 남은 스킬이었다. 두 결핍이 정확히 맞물린다 — 이식을 실제로 해봐야 동봉물의 사양이 맞는지 알 수 있고, 동봉물이 있어야 이식이 재현 가능해진다.

## 실행 로그

### ⓪ pre-flight

초안이 요구하는 `scripts/detect-repo-state.sh`가 없어 먼저 구현했다. 실행 결과:

```json
{
  "has_git": true, "already_setup": false, "protocol_stamp": null,
  "agents_md": "missing", "claude_md": "missing", "docs_dir": [],
  "doc_candidates": ["concept-notes.md", "product-concept.md", "research/"],
  "adr_dir": null, "adr_last_number": null, "decision_last_number": null,
  "remote": "github", "tracker_hint": "github-issues",
  "machine_routing_asked": false, "machine_routing_choice": null,
  "tool_hint": ["claude", "codex"]
}
```

`already_setup: false` → 신규 각인 모드. `tracker_hint`가 `gh issue list`로 실제 확인되어 ②A의 답이 탐색으로 결정됐다 — 초안의 "탐색이 이미 결정한 질문은 묻지 마라"가 그대로 작동했다.

사양에 없던 두 필드를 추가했다. `repo_root`는 worktree에서 실행할 때 어느 트리를 봤는지 출력에 남기기 위해서고, `decision_last_number`는 아래 마찰 6의 이유다.

### ② 섹션별 질문

- **A. 이슈 트래커** — GitHub Issues. pre-flight가 확정했으므로 묻지 않았다.
- **B. 기존 문서 매핑** — 3건 모두 처리:
  - `product-concept.md` → **변환** (아래 분해 참고)
  - `concept-notes.md` → **이관**. 내용이 "future consideration: agent as coordinator" 한 항목뿐이라 BACKLOG의 fog 항목으로 병합 후 삭제.
  - `research/` → **이관**. `docs/_research/`로 `git mv` (프로토콜 경로 규약).
- **C. VISION 초안** — `product-concept.md` 기반으로 작성.
- **D. 전역 라우팅** — **건너뜀**. 마찰 2 참고.

### ④ 쓰기

`product-concept.md` 216줄의 분해 결과:

| 착지 문서 | 원문에서 가져온 것 | 근거 |
| --- | --- | --- |
| `docs/VISION.md` | 결과, 사용자와 핵심 문제, 다섯 가지 일, Personal Work Team, 제품 경계, 최소 멘탈 모델 | Document Index의 VISION 행 |
| `docs/GLOSSARY.md` | Project·Task·Session·앵커·Triage·맥락 전환 패킷 등 12개 용어 | 같은 개념에 쓰는 단어만 |
| `docs/decision-logs/coordination-model.md` | 관계 인식 원칙, 강한 신호의 자동 포착 → D-0001~D-0003 | 세 기준(다시 물어볼 만한가/다른 기능에 영향/뒤집는 비용) 전부 충족 |
| `docs/decision-logs/task-context.md` | 초기 Task Context/Memory → D-0004 | 도메인 축이 다름(persistence 관심사) + shared memory 리서치가 이 축에 붙을 예정 |
| `docs/BACKLOG.md` | 보류한 검증 과제 7건, 다음 검증 순서 4건, 기반 결정 2건 | fog·장기 후보 |

핵심 판단은 **어디까지가 VISION이고 어디부터가 결정인가**였다. `product-concept.md`의 "관계 인식 원칙"과 "강한 신호의 자동 포착"은 제품 방향처럼 읽히지만 실제로는 뒤집는 비용이 큰 설계 결정이다. VISION에 두면 나중에 조용히 바뀌고, decision-log에 두면 mark를 거쳐야 바뀐다. 후자를 택했다.

Triage·알림 정책은 반대로 판단했다. `product-concept.md`에 방향은 적혀 있지만 같은 문서의 "보류한 검증 과제"에 "triage 후보의 우선순위 모델과 설명 품질"이 미해결로 명시돼 있다 — 아직 결정이 아니다. BACKLOG 항목에 방향을 한 줄로 압축 병합했다.

### ⑤ 검증

- `marker-hash.sh` 자체 테스트 6케이스 통과 (정상/마커 없음/변조/멱등성/global 마커 구분/파일 없음).
- 구현 중 실제 버그 1건 발견: `body | sha256` 파이프라인이 마커 부재를 삼켜 빈 입력의 해시를 반환했다. 파이프라인의 exit status가 마지막 명령의 것이기 때문. `actual_hash()`로 분리해 수정.
- `lint-decision-logs.sh` 구현(background agent) 후 persquad에 실행: **0 error, 0 warning, 2 files, 4 decisions**. 손으로 쓴 decision-log가 프로토콜 형식을 만족한다는 독립 검증이다. 픽스처 12케이스(중복 ID·연번 공백·잘못된 날짜·해소 불가 인용·미인용 ID·prefix 혼용·ADR 승계·빈 디렉터리 등)도 함께 통과.
- `cold-read` 감사 **2회**. 두 감사의 결과가 질적으로 달라 아래에 따로 적는다.

#### 1차 감사 — 초안 사양대로 (`AGENTS.md` 단독)

판정 `시작 불가`. blocking 5건. 내용은 전부 "절차가 없다"였다 — 어느 단계인지, 브랜치인지 main인지, slug를 어떻게 정하는지. **이 감사가 초안의 설계 모순을 드러냈다** (마찰 7).

#### 2차 감사 — 수정 사양으로 (`AGENTS.md` + 라우팅된 5개 스킬)

판정 여전히 `시작 불가`, blocking 5건. 그러나 **질문의 층이 완전히 바뀌었다.** 1차의 blocking 5건은 전부 해소됐고, 새로 드러난 것은 이런 것들이다:

- "the backlog"가 GitHub Issues인지 `docs/BACKLOG.md`인지, 둘 다 항목이 있으면 어느 쪽이 이기는지
- align 승인이 **어디에 기록되는지** — kickoff이 "approved workstream agreement exists"에 게이트하는데 그 증거의 소재가 없다
- `main`이 어디 있고 이 worktree를 떠나도 되는지 (마찰 5의 재확인)
- 작업 크기 임계가 다섯 표현으로 나타나는데 어느 것도 정의되지 않았다

그리고 **내가 마찰 8·10을 봉합하려고 쓴 규칙이 스킬과 모순을 만든 것을 잡아냈다** — 마찰 19 참고. 이것이 2차 감사의 가장 큰 소득이다. 봉합이 새 모순을 만드는 것은 혼자서는 보이지 않는다.

cold-read 스킬은 "2차 감사 후에도 blocking이 남으면 또 교정하지 말고 align으로 돌아가라 — 문제는 불완전한 합의이지 교정 부족이 아니다"라고 규정한다. 그 지시에 따라 **3차 감사를 하지 않고 여기서 멈췄다.** 남은 blocking은 이 레포의 `AGENTS.md`로 봉합할 수 있는 것이 아니라 프로토콜·스킬 레벨의 미결이다 (마찰 11~18).

## 마찰

`protocol-friction-log.md`에 한 줄씩 남긴 항목의 맥락.

### 1. 공백 — 해시를 요구하면서 해시 도구가 없다

초안은 마커 블록에 `agent-workflow-protocol-hash`(sha256)를 두고, 갱신 모드가 재렌더링 전에 이 값으로 사용자의 직접 수정을 감지하도록 규정한다. 그런데 동봉물 목록(`scripts/`, `templates/`)에 그 해시를 계산·비교·기록하는 도구가 없다.

이대로면 agent가 매번 "start~end 사이에서 해시 줄만 빼고 sha256"을 손으로 구성해야 한다. 절차가 아니라 **불변식을 매번 재구현**하는 것이라 어긋나기 쉽고, 실제로 어긋나면 갱신 모드가 멀쩡한 블록을 "수정됨"으로 오판한다. 해시의 존재 이유가 무결성인데 계산 방식이 불안정하면 기능 자체가 성립하지 않는다.

→ `scripts/marker-hash.sh` 신설 (compute / check / stamp).

### 2. 공백 — 사용자 부재 시 ②D의 기본 행동이 없다

②D 전역 라우팅은 "머신당 최초 1회" 사용자에게 묻고, 답을 `~/.claude/agent-workflow-protocol/state.json`에 기록해 다시 묻지 않는다. 그런데 이 회차는 배경 세션이었고 사용자가 자리에 없었다.

초안에는 이 경우가 없다. 세 선택지가 전부 문제가 있다:

- **물어보고 멈춘다** — 레포 이식은 전역 라우팅과 무관한데 전체가 막힌다.
- **전역으로 진행한다** — 사용자 홈 파일을 동의 없이 고친다.
- **로컬만으로 진행하고 상태 파일을 쓴다** — "물어봤다"는 거짓 기록이 남아 사용자는 영영 질문받지 못한다.

이번엔 네 번째를 택했다: **로컬만으로 진행하되 상태 파일을 쓰지 않는다.** 다음에 사용자가 있는 세션에서 setup-workflow를 돌리면 `machine_routing_asked=false`이므로 정상적으로 질문받는다. 레포 이식은 완료되고 전역 결정만 연기된다.

이 처리가 맞다면 초안에 명문화해야 한다 — "②D는 사용자 응답 없이 진행할 수 없다. 무인 실행에서는 로컬만으로 진행하고 상태 파일을 쓰지 않는다."

### 3. 공백 — ②B 매핑의 착지점이 ④2의 금지 목록과 겹친다

④2는 "PROJECT_STATE·BACKLOG 골격 + VISION만 만들고, **GLOSSARY·LEARNINGS·decision-logs·features·workstreams는 만들지 않는다** — lazy 생성"이라고 못박는다. 그런데 ②B의 매핑 대상이 그 문서들로 가야 하는 경우가 실재한다.

`product-concept.md`는 VISION 하나로 담을 수 없었다. 용어 정의는 GLOSSARY로, 되돌리기 비싼 설계 결정은 decision-log로 가는 것이 프로토콜에 맞고, 그렇게 하지 않으면 VISION이 다시 216줄짜리 잡탕이 된다 — 이식이 해결하려던 바로 그 상태다.

lazy 생성 원칙과 매핑 실행이 충돌하는 것이 아니라, **초안이 두 규칙의 우선순위를 정하지 않았다.** 판단은 명확하다: lazy 생성은 "빈 문서를 미리 깔지 마라"는 규칙이고, 매핑은 "실재하는 내용을 올바른 층에 착지시켜라"는 규칙이다. 내용이 있으면 매핑이 이긴다.

### 4. 어색 — 원문 링크가 공개 여부에 걸려 있다

마커 블록의 `원문:` 라인은 link-workflow의 GitHub URL을 가리키도록 확정됐고(검토점 3), "아직 private/미공개면 이 라인은 비워두거나 생략한다"는 단서가 붙어 있다. 현재 link-workflow는 remote가 아예 없어 생략했다.

결과적으로 이식된 레포에서 프로토콜 원문에 도달할 경로가 사라졌다. 마커 블록은 "이 레포가 이식됐다"는 신호 + 불변식 + 라우팅을 담지 원문 조회가 목적이 아니므로 치명적이진 않다. 다만 **생략의 대가가 검토점 3의 논의에 계산되지 않았다** — 그 논의는 "로컬 경로 vs URL"의 선택이었지 "URL 없음"의 경우가 아니었다.

### 5. 어색 — 배경 세션의 worktree 격리와 Kickoff의 main 전이가 충돌한다

프로토콜 §3 Kickoff는 "시작 전이 커밋을 **main에서** 만든 뒤 branch/worktree를 딴다"를 요구한다. `PROJECT_STATE.md`·`BACKLOG.md`가 main 전용인 것이 병렬 workstream의 merge 충돌을 원천 차단하는 근거이므로, 이 순서는 장식이 아니라 불변식이다.

그런데 배경 에이전트 세션은 시작 시점에 worktree 격리를 강제한다 — 공유 체크아웃의 편집이 거부된다. 즉 agent는 main에 있을 수 없다.

이번 회차는 이식이라 workstream이 아니었고 전이 커밋이 필요 없어 충돌이 표면화되지 않았다. **Round 2에서 정면 충돌한다.** 미리 결정할 것: worktree 안의 진입 브랜치를 "main 대리"로 삼고 전이 커밋을 거기서 만들 것인가, 아니면 Kickoff의 main 요구를 "PROJECT_STATE·BACKLOG를 수정하는 커밋은 workstream 브랜치와 분리한다"로 완화할 것인가.

### 6. 공백 — pre-flight가 이미 decision-log를 쓰는 레포의 다음 ID를 모른다

초안의 pre-flight JSON에는 `adr_dir`과 `adr_last_number`가 있다. 구 ADR 체계에서 전환하는 레포를 위한 것이다. 그런데 **이미 이 프로토콜을 쓰던 레포를 재이식하거나 갱신할 때** 필요한 `docs/decision-logs/`의 마지막 ID는 없다.

결정 ID는 레포 전역 연번이고 hard-dependency다(마커 블록에 값이 없으면 임의 진행 금지). 갱신 모드가 이 값을 모르면 마커의 "결정 ID: D-0001부터"가 실제 상태와 무관한 문자열이 된다. `decision_last_number` 필드를 추가했다.

### 7. 어색 — ⑤ cold-read의 판정 기준이 초안의 설계와 모순된다

이 회차에서 가장 중요한 발견이다.

초안은 두 곳에서 서로 반대되는 말을 한다.

- **이식 단위 표**: "프로토콜 전문은 레포에 복사하지 않는다. 마커 블록이 담는 것은 요약본이 아니라 운영 불변식 + 스킬 라우팅 + 레포별 설정이다."
- **⑤ 검증**: "cold-read를 돌려라 — 검증 대상은 AGENTS.md(마커 블록 포함): '이 레포를 처음 보는 agent가 이 파일만 보고 워크플로우를 따를 수 있는가.' 시작 불가 질문이 나오면 마커 블록을 보강하라."

마커 블록이 프로토콜 요약본이 아니라면, AGENTS.md 단독으로는 **언제나** 워크플로우를 따를 수 없다. 즉 ⑤의 판정은 구조적으로 항상 "시작 불가"다. 그리고 그 지시대로 마커 블록을 보강해 나가면, 종착점은 초안이 명시적으로 금지한 프로토콜 요약본이다.

실제로 fresh agent의 감사는 판정 `시작 불가`와 함께 blocking 5건을 냈다. 그중 대표적인 것:

- 어느 단계에 있는지, 파이프라인이 모든 작업에 필수인지 판정 기준이 없다
- 브랜치인지 main인지, 그 상태를 누가 만드는지 없다
- 관련 workstream·decision-log를 식별하는 규칙(slug 유래)이 없다

이 셋은 모두 **스킬이 답을 갖고 있다.** `kickoff`이 브랜치와 worktree를 만들고 slug를 정하며, `align`이 파이프라인 진입 기준을 정한다. 감사 대상에서 스킬을 뺀 것이 사양 오류다.

→ **처리안**: ⑤의 감사 대상을 `AGENTS.md + Skill routing이 가리키는 스킬`로 바꾼다. 그리고 마커 블록에 "이 블록은 불변식·라우팅·설정만 담고 절차는 스킬에 있다"는 한 줄을 넣어, agent가 이 파일만으로 절차를 재구성하려 시도하지 않게 한다. 이번 회차에서 템플릿과 persquad AGENTS.md 양쪽에 반영했다.

### 8. 공백 — park의 착지점이 브랜치에서 실행 불가능하다 *(프로토콜)*

cold-read가 스킬로도 해소되지 않는 진짜 공백을 함께 잡아냈다.

프로토콜 §4는 "scope 밖이면 → `docs/BACKLOG.md`"라 하고, §Parallel Workstreams는 "`BACKLOG.md`는 main에서만 갱신한다"고 한다. 그런데 Develop 단계의 agent는 정의상 workstream 브랜치/worktree에 있다. **한 규칙이 다른 규칙을 실행 불가능하게 만든다.**

park는 "착지 지점이 항상 이 두 곳뿐이라는 확신이 열린 루프를 닫는다"가 존재 이유인데, 두 곳 중 하나가 도달 불가능하면 그 확신이 성립하지 않는다.

→ **이번 적용의 잠정 규약** (persquad `AGENTS.md`의 마커 밖에 기록): 브랜치에서는 workstream 문서의 `Parked (out of scope)`에 남기고, promote가 main에서 `BACKLOG.md`로 옮긴다. promote는 이미 merge 후 main에서 수행하므로 추가 단계가 필요 없다. 대가는 park한 항목이 workstream 종료까지 BACKLOG에 안 보인다는 것 — 병렬 세션의 중복 발견 위험을 merge 충돌보다 싸게 본 것이다.

이것이 맞다면 프로토콜 §4의 park 규칙 자체를 고쳐야 한다. 리뷰 대상.

### 9. 공백 — 결정 ID의 동시 할당 규칙이 없다 *(프로토콜)*

결정 ID는 레포 전역 연번이고 hard-dependency다. 그런데 병렬 workstream이 각자 브랜치에서 결정을 기록하면 둘 다 같은 다음 번호를 잡는다. 프로토콜 §4의 결정 ID 규약에 동시성에 대한 언급이 없다.

→ **잠정 규약**: 브랜치에서 잠정 할당하고 promote 시점에 main의 최대 ID로 확정한다. 충돌하면 나중에 merge되는 쪽이 재번호한다. 프로토콜이 "인용은 경로가 아니라 ID로" 하도록 이미 규정했으므로 재번호 비용은 grep 치환이다 — 이 규약이 성립하는 이유가 P-0003의 설계에 이미 들어 있었다.

### 10. 공백 — decision-logs의 쓰기 위치가 규정되지 않았다 *(프로토콜)*

§Parallel Workstreams가 main 전용으로 지정한 것은 `PROJECT_STATE.md`와 `BACKLOG.md` 둘뿐이다. `decision-logs/`와 `ARCHITECTURE.md`는 언급이 없다. 그런데 이 둘도 레포 전역 공유 상태이고, 브랜치에서 쓰는지 main에서 쓰는지에 따라 merge 충돌 양상이 달라진다.

→ **독해**: 명시된 둘만 main 전용이고 나머지는 브랜치에서 쓰고 merge로 올라간다. §4가 "결정이 굳으면 **그 자리에서** 기록한다"고 하므로 이 독해가 맞다. 다만 명시되지 않아 매번 추론해야 하는 것이 마찰이다.

### 11~18. 2차 감사가 드러낸 스킬 레벨 미결 *(프로토콜·스킬)*

봉합하지 않고 기록만 한 항목들. 전부 `protocol-friction-log.md`에 한 줄씩 있다.

| # | 유형 | 내용 |
| --- | --- | --- |
| 11 | 어색 | kickoff은 sibling worktree(`../<repo>-<slug>`)를 명시하는데 Claude Code의 EnterWorktree·배경 세션은 `.claude/worktrees/`를 쓴다. 어느 규약이 이기는지 없다 |
| 12 | 공백 | 작업 크기 임계가 다섯 표현(non-trivial, workstream-scale, substantial, workstream-sized, small enough)인데 정의가 하나도 없다 |
| 13 | 공백 | kickoff의 게이트인 "승인된 workstream 합의"가 **어디에 기록되는지** 없다 |
| 14 | 공백 | 단계 6개 중 Develop·Resume에 스킬이 없다. Skill routing이 4개만 매핑하고, 그 두 단계의 실행 근거가 어디에도 없다 |
| 15 | 공백 | promote가 "merge 후"만 말하고 누가 merge하는지·PR이 필요한지·squash 여부가 없다 |
| 16 | 어색 | kickoff 1단계가 항목이 BACKLOG에 있다고 가정하는데, 이슈 트래커 레포에서 셰이핑 완료 항목은 정의상 BACKLOG에 없다(align 출구에서 제거됨) |
| 17 | 공백 | 이슈 번호와 workstream을 잇는 위치가 없어 나중 세션이 연결을 재발견할 수 없다 |
| 18 | 공백 | promote가 요구하는 "concrete evidence"의 기준이 코드 없는 문서 전용 변경에 대해 정의되지 않았다 |

### 19. 봉합이 새 모순을 만들었다 *(이번 회차의 자기 발견)*

마찰 8·10을 해소하려고 persquad `AGENTS.md`에 세 규칙을 썼는데, 2차 감사가 그중 셋 다 스킬과 충돌함을 잡아냈다.

| 내가 쓴 것 | 충돌한 스킬 지시 |
| --- | --- |
| "decision-logs는 브랜치에서 쓰고 merge로 main에 들어간다" | kickoff 4단계는 decision-log 초안을 **main의 전이 커밋**에 착지시킨다. promote 3단계도 **main**에서 쓴다 |
| "promote가 `Parked (out of scope)`를 BACKLOG로 옮긴다" | promote 스킬의 7단계에 그런 단계가 **없다**. 내가 없는 약속을 했다 |
| (worktree 경로를 규정하지 않음) | kickoff은 `../<repo>-<slug>`를 명시하는데 실제 worktree는 `.claude/worktrees/`에 있다 |

세 건 다 수정했다. decision-log는 "쓰는 시점이 브랜치를 결정한다"는 표로 바꿔 kickoff(main)·Develop(브랜치)·promote(main) 셋을 모두 인정했고, Parked 이관은 "promote 스킬에 없으므로 이 레포가 추가하는 단계"라고 출처를 명시했고, worktree 경로는 레포 규약으로 못박았다.

**교훈**: 프로토콜 공백을 레포 레벨에서 봉합할 때, 그 봉합이 스킬의 기존 지시와 충돌하는지 확인할 방법이 필요하다. 이번엔 cold-read가 우연히 잡았다 — 감사 대상에 스킬을 넣었기 때문이다. 1차 사양(AGENTS.md 단독)이었으면 영영 못 봤다.

## 회고

### 무엇이 잘 작동했나

**pre-flight가 질문을 실제로 줄였다.** 초안의 "탐색이 이미 결정한 질문은 묻지 마라"는 원칙이 결정적이었다. 이슈 트래커·기존 문서 목록·도구 힌트가 전부 탐색으로 확정되어, 남은 질문은 사람의 선호에 속하는 ②D 하나뿐이었다. 이것이 무인 실행이 거의 끝까지 갈 수 있었던 이유다.

**문서 층 분해가 실제로 정보를 잃지 않았다.** 216줄이 5개 문서로 갈라지면서 삭제된 것은 없고, 각 조각이 자기 lifecycle을 갖게 됐다. 특히 "관계 인식 원칙"이 VISION(조용히 바뀜)에서 decision-log(mark를 거쳐야 바뀜)로 옮겨간 것이 이 이식의 실질적 이득이다.

### 무엇이 비었나

19건의 마찰을 층으로 나누면 분포가 뚜렷하다.

| 층 | 건수 | 마찰 |
| --- | --- | --- |
| `setup-workflow` 초안의 결함 | 4 | 1, 3, 6, 7 |
| 프로토콜 본문의 공백 | 4 | 8, 9, 10, 12 |
| 스킬 간 규약의 공백·충돌 | 6 | 11, 13, 14, 15, 16, 17 |
| 실행 환경 가정의 불일치 | 3 | 2, 5, 18 |
| 외부 조건 파생 | 1 | 4 |
| 봉합의 부작용 | 1 | 19 |

세 가지가 읽힌다.

**첫째, 가장 큰 덩어리가 "스킬 간 규약"이다.** 6개 스킬이 각각은 잘 쓰였지만, 스킬 A가 만든 상태를 스킬 B가 어떻게 찾는지가 비어 있다. kickoff이 승인을 확인하지만 승인을 기록하는 주체는 align이고 기록 위치는 아무도 말하지 않는다(13). kickoff이 이슈에 시작을 기록하지만 그 연결을 나중에 되찾는 방법이 없다(17). 스킬을 하나씩 승격하면서 **인접 스킬과의 접합면을 검증하지 않은 결과**다.

**둘째, 프로토콜은 단일 브랜치 작업을 암묵적으로 가정한다.** 마찰 5·8·9·10은 전부 "브랜치/worktree에 있는 agent가 main 전용 자원에 닿아야 한다"는 하나의 뿌리에서 나왔다. §Parallel Workstreams는 병렬 운용을 명시적으로 다루는데, 정작 그 안에서 park·mark를 어떻게 실행하는지는 다루지 않는다.

**셋째, 초안은 사용자가 옆에 있는 대화형 세션을 전제한다.** 실제로는 무인 배경 세션에서 돌아갔고 ②D가 막혔다(2). 크기 임계가 정의되지 않은 것(12)도 같은 성격이다 — 사람이 옆에 있으면 "이건 큰 작업인가요?"로 넘어가지만, 무인 실행에는 판정 기준이 필요하다.

### 검증 도구가 실제로 값을 했다

이번 회차에서 도구가 잡아낸 것들:

- `marker-hash.sh` **자체 구현 중** 파이프라인 exit status 버그 (사람 눈으로는 안 보임)
- `lint-decision-logs.sh`가 손으로 쓴 decision-log 4건을 형식 검증 — 통과
- `cold-read` 2차 감사가 **내 봉합의 부작용**(마찰 19) 검출

특히 마지막이 중요하다. 마찰 19는 자기 검토로는 원리적으로 못 찾는다 — 봉합을 쓴 사람은 그 봉합이 옳다고 믿고 있기 때문이다. cold-read의 "대화에 참여하지 않은 fresh agent" 요건이 장식이 아님이 실증됐다.

### 처리 경로 판단

| 마찰 | 처리 경로 | 이번 회차에서 |
| --- | --- | --- |
| 1 | 동봉물 신설 | ✅ `marker-hash.sh` 구현·검증 완료 |
| 6 | pre-flight 사양 보강 | ✅ `decision_last_number` 추가 완료 |
| 7 | 초안 ⑤ 사양 수정 + 마커 템플릿 보강 | ✅ 템플릿·persquad 양쪽 반영, 수정 사양으로 재감사까지 실증 |
| 19 | — | ✅ persquad `AGENTS.md` 3건 수정 완료 |
| 2, 3 | 초안 보강 (무인 실행 규칙 / 규칙 우선순위) | 판단 기록. 초안 수정은 리뷰 세션 |
| 4 | 검토점 3 재검토 | 리뷰 대상 |
| 5, 8, 9, 10 | **프로토콜 §4·§Parallel Workstreams 개정** | persquad `AGENTS.md`에 잠정 규약 기록. 한 뿌리이므로 함께 다뤄야 함 |
| 11, 13~18 | 스킬 개정 (접합면) | 리뷰 대상 |
| 12 | 프로토콜 또는 align 스킬 | 리뷰 대상 |

`protocol-friction-log.md`가 **19건**으로 리뷰 트리거(10건)를 크게 넘었다. 한 번의 실적용이 2~3주치 마찰을 만들어냈다는 뜻이고, 이는 로그가 그동안 비어 있던 이유가 "마찰이 없어서"가 아니라 "적용이 없어서"였음을 보여준다.

## 다음 회차로 넘기는 것

### 결정 필요 (Round 2 착수 전)

마찰 5·8·9·10은 한 뿌리다: **브랜치에 있는 agent가 main 전용 자원에 닿는 방법.** persquad `AGENTS.md`에 잠정 규약을 기록했으나, 프로토콜 레벨의 답이 아니면 이식하는 레포마다 각자 발명하게 된다.

이번 적용에서 채택한 잠정 규약:

- `PROJECT_STATE.md`·`BACKLOG.md`만 main 전용. 나머지는 쓰는 시점이 브랜치를 결정
- scope 밖 park는 workstream 문서의 `Parked (out of scope)` → promote가 main에서 BACKLOG로 이관
- 결정 ID는 브랜치에서 잠정 할당 → promote에서 확정, 충돌 시 나중 merge 쪽이 재번호
- worktree는 `.claude/worktrees/<slug>`

### Round 2 목표

`docs/BACKLOG.md`의 **"기술 스택과 앱 셸"**. 고른 이유:

- 이후 모든 슬라이스가 이 위에 서므로 되돌리기 비싸다 → decision-log의 1순위 후보
- 외부 세계의 사실(Electron/Tauri의 현재 상태, ADE 연동 가능성)에 의존한다 → `workflow-research` 핸드오프를 실제로 검증할 수 있다
- 접근안이 여럿이고 트레이드오프가 뚜렷하다 → align ①(접근안 벌리기)과 전제 도전을 진짜로 쓸 수 있다

즉 Round 1이 `setup-workflow`+`cold-read`를 검증했다면, Round 2는 **`align`+`workflow-research`+`kickoff`**를 검증한다.

### 보류

`setup-workflow`의 `skills/` 승격. 동봉물 4종은 이번에 구현·검증했으나(승격 계약 2번 충족), 초안의 마찰 2·3·7이 미해결이라 계약 1번(결정 완료)을 아직 만족하지 않는다. 초안이 아니라 **리뷰가 병목**이다.
