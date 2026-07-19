# setup-workflow — 초안

베이스: 신규 설계 — 이식 메커니즘 서베이(`digests/2026-07-18-setup-transplant-survey.md`: spec-kit·Agent OS·BMAD·GSD·superpowers·mattpocock·gstack, 2026-07-12 최초 조사 + 2026-07-18 전역/로컬 설정 라운드) 종합. 호출 방식: user-invoked.

link-workflow의 목적은 스킬 배포가 아니라 **워크플로우를 대상 git 레포에 이식**하는 것이고, 이 스킬이 그 진입점이다. 스킬(절차)은 유저 레벨 symlink로 이미 모든 레포에서 쓸 수 있으므로, setup-workflow가 맡는 것은 **레포 각인** — AGENTS.md 마커 블록, docs/ 최소 골격, 레포별 설정 — 이다.

```yaml
name: setup-workflow
description: Agent Workflow Protocol을 대상 레포에 이식하거나, 이식된 레포를 프로토콜 최신판으로 갱신할 때. 사용자가 "워크플로우 세팅해줘", "이 레포에 프로토콜 이식하자", "setup-workflow 돌려줘"라고 하면 사용.
```

> `[신규 · 저작규율1]` description은 트리거만 — 절차 요약 없음.
> `[검토점 1 → 확정 2026-07-13]` 스킬명 = `setup-workflow`. `setup` 단독은 전역 skills 네임스페이스의 범용어라 충돌·모호가 실재(gstack `setup-*` 3종, mattpocock이 굳이 `setup-matt-pocock-skills`를 쓴 선례). 트리거 자연어("워크플로우 세팅해줘")·기존 2어절 kebab 명명 패턴(cold-read·upstream-scout)과 합치. `adopt-workflow`는 greenfield에 부자연 + 사용자 자연어와 불일치로 기각.

---

## 이식 단위 (설계 불변식)

| 층 | 내용 | 소유 |
|---|---|---|
| 유저 레벨 | 스킬 전부(align/kickoff/promote/research/cold-read/setup-workflow) — link-workflow의 `scripts/link-skills.sh`가 symlink 설치 | link-workflow |
| 머신 레벨 (선택) | 전역 `~/.claude/CLAUDE.md`·`~/.codex/AGENTS.md`의 조건부 라우팅 마커 — 머신당 최초 1회만 물음(②D) | 전역 마커 안 = setup-workflow가 소유(재렌더링 대상), 그 외 = 사용자가 소유 |
| 레포 레벨 | ① AGENTS.md의 마커 블록 ② CLAUDE.md 포인터 ③ docs/ 최소 골격 ④ (선택) 결정 ID lint 스크립트 | 마커 블록 안 = setup-workflow가 소유(재렌더링 대상), 그 외 전부 = 레포가 소유(생성 후 절대 안 덮음) |

- **프로토콜 전문은 레포에 복사하지 않는다.** 마커 블록이 담는 것은 요약본이 아니라 운영 불변식 + 스킬 라우팅 + 레포별 설정이다.

이 설계가 spec-kit·superpowers·Agent OS에서 각각 무엇을 참조하고 반면교사로 삼았는지는 `upstream-sources.md`의 github/spec-kit·obra/superpowers·buildermethods/agent-os 항목 참고.

## 본문

**⓪ pre-flight.** `scripts/detect-repo-state.sh`(스킬 폴더 동봉)를 실행해 레포 상태를 JSON으로 받아라:

```json
{
  "has_git": true,          // .git 존재
  "already_setup": false,   // AGENTS.md 마커 블록 존재
  "protocol_stamp": null,   // 마커의 P-NNNN 스탬프 (already_setup일 때)
  "agents_md": "exists|missing",
  "claude_md": "exists|missing|pointer",  // pointer = AGENTS.md만 가리키는 한 줄
  "docs_dir": ["VISION.md", "adr/", ...], // docs/ 하위 실존 목록
  "doc_candidates": ["TODO.md", "CONTRIBUTING.md", ...], // 루트의 매핑 대상 문서
  "adr_dir": "docs/adr|null", "adr_last_number": 12,
  "remote": "github|gitlab|none",
  "tracker_hint": "github-issues|none",   // gh로 이슈 활성 여부 감지
  "machine_routing_asked": false,   // ~/.claude/agent-workflow-protocol/state.json 존재 여부 — 머신당 최초 1회 질문을 이미 했는지
  "machine_routing_choice": null,   // 물어봤다면 그때 기록: "global-claude"|"global-codex"|"global-both"|"local-only"
  "tool_hint": ["claude", "codex"]  // ~/.claude, ~/.codex 존재 여부로 추정한 후보(추천 답 선행용, 확정 아님)
}
```

분기는 이 출력으로 결정한다 — LLM의 감이 아니다. `has_git=false`면 `git init`부터 제안하고, `already_setup=true`면 **갱신 모드**(아래)로 전환한다(결정적 pre-flight는 GSD에서 참조 — `upstream-sources.md`의 get-shit-done-cc 항목 참고).

**① 발견 제시.** 탐색 결과를 요약해 보여라: 무엇이 있고 무엇이 없는지, 어느 모드로 진행할지(신규 각인 / 기존 문서 흡수 / 갱신). 탐색이 이미 결정한 질문은 묻지 마라.

**② 섹션별 질문.** 한 섹션에 하나씩, 추천 답을 선행하라:

- **A. 이슈 트래커.** `tracker_hint`가 있으면 그것을 추천. 선택지: GitHub Issues / 없음(BACKLOG 단독) / 기타(한 문단 서술). 프로토콜의 권위 경계(셰이핑 완료 = 트래커, fog = BACKLOG)가 이 답에 따라 마커 블록에 기록된다.
- **B. 기존 문서 매핑** (doc_candidates·docs_dir가 비어있지 않을 때만). 문서마다 하나씩 제안하라: **유지**(reference로 인정) / **변환**(VISION·ARCHITECTURE로 병합) / **이관**(BACKLOG 또는 이슈로) / **폐기**. ADR 디렉토리가 있으면 decision-logs 전환 여부를 묻고, 전환하든 안 하든 결정 ID는 기존 연번을 승계한다(`ADR-{n+1}`부터 — 프로토콜 §4).
- **C. VISION 초안** (docs/VISION.md가 없을 때만). 3~5문답으로 초안을 만들어라: 무엇을/누구를 위해/지금 아닌 것. 답을 모르는 신규 레포면 "TBD 골격만 생성"도 유효한 답이다.
- **D. 전역 라우팅** (`machine_routing_asked=false`일 때만 — 머신당 최초 1회, 이 레포와 무관). 두 질문을 순서대로:
  1. 도구 확인. `tool_hint`를 추천으로 제시하고 확정하라: Claude Code / Codex / 둘 다.
  2. 배치 확인. **전역(추천)** — 1에서 답한 도구의 전역 설정 파일(Claude: `~/.claude/CLAUDE.md`, Codex: `~/.codex/AGENTS.md`, 둘 다면 둘 다)에 조건부 라우팅 요약을 추가한다. 이후 이 머신의 어떤 레포에서 작업하든, 그 레포에 마커가 있으면 따르고 없어도 사용자가 이 워크플로우의 스킬을 직접 부르면 setup-workflow부터 제안하게 된다 — 레포마다 setup-workflow를 미리 돌려둘 필요가 없다. **로컬만** — 지금 하던 대로 이 레포의 마커 블록만 쓴다. 다른 레포에서 이 워크플로우를 쓰려면 그 레포에서 setup-workflow를 따로 실행해야 한다.
  답이 무엇이든 `~/.claude/agent-workflow-protocol/state.json`에 `{"tool": ..., "placement": ...}`로 기록해 다음부터 어느 레포에서 setup-workflow를 돌려도 다시 묻지 않는다. 사용자가 "전역 라우팅 다시 설정해줘"처럼 명시적으로 재요청하면 `machine_routing_asked` 값과 무관하게 이 단계를 다시 밟는다 — 상태 파일을 직접 지우라고 안내하지 않는다.

> `[신규]` 마커 블록은 "이 레포가 명시적으로 이식됐다"는 opt-in 신호라 다른 레포에 임의로 새지 않는다(팀 레포·컨벤션 있는 레포에서 원치 않는 강제가 되는 걸 막는 설계). 전역 배치는 이 필터를 깨지 않도록 **조건부**로만 쓴다 — "이 머신의 모든 레포는 이 워크플로우를 따른다"가 아니라 "마커가 있으면 따르고, 없어도 사용자가 부르면 setup-workflow부터 제안한다"는 두 문장으로 한정한다. 실제 문구는 아래 "전역 라우팅 템플릿" 참고.
> `[검토점 → 확정 2026-07-19]` 재진입 경로 — "전역 라우팅 다시 설정해줘"류 자연어를 ②D의 명시적 재트리거로 인식한다(`machine_routing_asked` 값과 무관하게 진입). gstack의 `gstack-config set`(상태 파일을 직접 지우게 하지 않고 항상 명령으로 재설정하게 하는 설계)을 그대로 채택 — `upstream-sources.md`의 garrytan/gstack 항목 참고. "상태 파일을 지우라"는 안내는 두지 않는다.

> `[참조 · ai-tab 문서 다이어트, 2026-07-10]` B의 매핑 4분류는 ai-tab 재구성에서 실증된 절차의 일반화.

탐색→발견 제시→섹션별 질문→초안 확인→쓰기 골격, 그리고 "생성기 하나 + 기존 레포 역채움" 설계가 mattpocock setup·Agent OS analyze-product에서 무엇을 가져왔는지는 `upstream-sources.md` 참고.

**③ 초안 확인.** 쓰기 전에 보여라: AGENTS.md 마커 블록 전문, 생성할 docs/ 골격 목록, B의 매핑 실행 계획. 사용자가 수정하게 하라.

**④ 쓰기.** 승인 후 한 커밋으로:

1. `AGENTS.md` — 있으면 마커 블록만 추가(기존 내용 불변), 없으면 마커 블록 + 빈 뼈대로 생성. `CLAUDE.md`가 실체 파일이면 내용을 AGENTS.md로 옮기고 포인터로 전환할지 물어라 — 어느 쪽이든 **이미 있는 파일을 편집하고, 반대쪽을 임의로 새로 만들지 마라.**
2. `docs/PROJECT_STATE.md`, `docs/BACKLOG.md` 골격 생성 (동봉 템플릿). VISION은 ②C의 초안. **그 외(GLOSSARY·LEARNINGS·decision-logs·features·workstreams)는 만들지 않는다** — 각 스킬이 필요해질 때 lazy 생성한다.
3. ②B의 매핑 실행 (변환·이관·폐기).
4. pre-commit을 쓰는 레포면 결정 ID lint(`lint-decision-logs.sh`) 복사를 제안하라 — 강제하지 마라.
5. 존재하는 파일은 절대 덮지 않는다. 스킵하고 보고하라.

1의 "있는 파일 편집, 반대쪽 생성 금지"(mattpocock setup)와 2의 lazy 생성(mattpocock domain.md)이 어디서 왔는지, 5의 사상이 spec-kit recovered와 어떻게 다른지는 `upstream-sources.md` 참고.

②D에서 전역을 선택했다면, 위 커밋과는 별개로 처리하라 — 대상이 레포 밖 파일(`~/.claude/CLAUDE.md` 또는 `~/.codex/AGENTS.md`)이라 이 레포의 커밋에 포함되지 않는다. 해당 파일에 아래 "전역 라우팅 템플릿"을 append하라. 파일이 없으면 새로 만들고, 있으면 마커 블록과 같은 원칙으로 기존 내용 뒤에 이어 쓴다 — 기존 내용은 건드리지 않는다.

**⑤ 검증.** `/cold-read`를 돌려라 — 검증 대상은 AGENTS.md(마커 블록 포함): "이 레포를 처음 보는 agent가 이 파일만 보고 워크플로우를 따를 수 있는가." 시작 불가 질문이 나오면 마커 블록을 보강하라.

> `[신규 · 프로토콜 §2 검토 게이트]` cold-read의 재사용 — setup-workflow 산출물도 핸드오프 문서다.

**갱신 모드** (`already_setup=true`). 강제 재초기화는 없다:

1. 마커의 스탬프(`P-NNNN`)와 프로토콜 변경 이력의 마지막 행 ID를 비교하고, 그 사이의 행들을 사용자에게 보여라.
2. 재렌더링 전에 마커 블록 안의 `agent-workflow-protocol-hash` 값과 현재 마커 내용의 실제 해시를 비교하라. 다르면 사용자가 마커 안쪽을 직접 고쳤다는 뜻이다 — "마커 블록을 직접 수정한 흔적이 있습니다. 계속하면 그 수정이 사라집니다"를 경고로 보여주고, 계속할지·중단할지 다시 확인받아라. 같으면(또는 첫 갱신이라 해시가 없으면) 조용히 다음 단계로.
3. 바뀐 불변식이 마커 블록에 영향을 주면 diff를 제시하고, 승인 후 **마커 블록 안만** 재렌더링하라(해시도 새로 계산해 갱신). 마커 밖과 docs/는 건드리지 않는다.
4. `lint-decision-logs.sh`가 레포에 복사돼 있으면 그 파일 상단의 `# P-NNNN` 스탬프도 비교하라. 스킬 폴더의 최신본과 다르면 diff를 보여주고, 승인받은 뒤에만 교체하라. 다른 마커 밖 파일과 달리 이 스크립트만 갱신 대상이다(검토점 4).

"changelog 먼저 보여주고 확인 후 갱신"(GSD update)과 "갱신≠강제 초기화"(spec-kit 안티패턴 반면교사)의 출처는 `upstream-sources.md`의 get-shit-done-cc·github/spec-kit 항목 참고.

## AGENTS.md 마커 블록 사양

```markdown
<!-- agent-workflow-protocol P-0011 start -->
<!-- agent-workflow-protocol-hash: <아래 마커 본문의 sha256> -->
## Agent Workflow

이 레포는 Agent Workflow Protocol을 따른다. 단계 어휘: Capture → Align → Kickoff → Develop → Resume → Promote.
원문: https://github.com/uoneway/link-workflow/blob/main/AGENT_WORKFLOW_PROTOCOL.md

### 재개 시 읽기 순서
이 파일 → docs/VISION.md → (docs/GLOSSARY.md) → docs/ARCHITECTURE.md → docs/PROJECT_STATE.md
→ 관련 docs/workstreams/<slug>.md → 관련 docs/decision-logs/의 Current Decision (필수)

### 상시 규칙 — park / mark
- 작업 중 새 가지는 쫓지 말고 한 줄로 착지한다: 현재 scope 안 → workstream 문서의 Next Step, 밖 → docs/BACKLOG.md (main에서만).
- 결정이 굳으면 그 자리에서 기록한다: 현재 구조는 docs/ARCHITECTURE.md, 이유·이력은 docs/decision-logs/ (레포 전역 연번 ID).

### Skill routing
셰이핑 → /align · 작업 시작 → /kickoff · 작업 완료 → /promote · 외부 사실 조사 → /research · 초안 감사 → /cold-read

### 이 레포의 설정
- 이슈 트래커: {GitHub Issues — 셰이핑 완료 작업은 이슈가 권위, fog·장기 후보는 docs/BACKLOG.md | 없음 — docs/BACKLOG.md 단독}
- 결정 ID: {D-0001부터 | 기존 ADR 연번 승계 — 다음은 ADR-00NN}
<!-- agent-workflow-protocol end -->
```

- 버전 스탬프는 이식·갱신 시점의 프로토콜 변경 이력 **마지막 행 ID**(`P-NNNN` — 변경 이력 규약 P-0011)다.
- 블록 안은 setup-workflow만 고친다. 레포 고유 규칙(빌드 명령, 코드 진입점, LEARNINGS 승격분)은 블록 **밖** — 레포 소유 영역 — 에 쌓인다.
- **원문 라인**은 `link-workflow` 레포의 GitHub URL을 가리킨다. 마커 경계 관리 섹션(밖은 불가침, 없으면 append) 자체가 GSD·spec-kit에서 참조한 패턴이라는 건 `upstream-sources.md` 참고.
- **`agent-workflow-protocol-hash`**는 마커 본문(해시 줄 자신은 제외, start~end 마커 사이 전체)의 sha256이다. 쓰기·갱신 직후 항상 재계산해 이 줄에 반영한다. 갱신 모드가 재렌더링 전에 이 값을 실제 내용과 대조해 사용자의 직접 수정을 감지하는 데 쓴다(아래 갱신 모드 참고) — vercel-labs/skills의 `update`가 로컬 수정 여부를 전혀 안 보고 조용히 덮어쓰는 것에 대한 반면교사, spec-kit의 자기 콘텐츠 SHA-256 추적과 같은 목적(`upstream-sources.md`의 mattpocock/skills·github/spec-kit 항목 참고).

> `[검토점 2 → 확정 2026-07-13]` 버전 표기 = 변경 이력 행 연번 `P-NNNN` (프로토콜 P-0011로 규약 신설·소급 부여 완료). 날짜 기각 — 같은 날 다수 행이 실존(2026-07-10에 7행)해 기준점을 유일하게 지목 못 함. semver(spec-kit constitution)·릴리스 버전(gstack VERSION) 기각 — 리뷰 세션 단위 일괄 개정에 호환성·릴리스 의미론이 부적합하고 판정 비용만 부과. 결정 ID 규약(D-NNNN)으로 이미 검증된 연번 패턴의 재사용.
> `[검토점 3 → 확정 2026-07-13]` 마커 블록에 프로토콜 원문 위치를 넣는다 — 로컬 절대경로가 아니라 **link-workflow의 GitHub URL**로. 애초 "넣지 않음(스킬이 안다)"이 잠정안이었던 이유는 로컬 경로 노출(사적 폴더 구조)과 stale 링크(link-workflow 자신이 이미 `~/docs` → `~/Project`로 한 번 이동한 전적) 둘 다였다. 이 문제는 로컬 경로일 때만 성립한다 — link-workflow를 GitHub public 레포로 전환하면 경로 노출 문제가 없고, URL은 레포를 옮기지 않는 한(별도 이벤트) 안정적이다. 그래서 "링크를 아예 안 넣는다"가 아니라 "GitHub URL로 넣는다"로 최종 결론을 냈다. link-workflow가 아직 private/미공개 상태라면 이 라인은 비워두거나 생략한다.

## 전역 라우팅 템플릿

②D에서 전역을 선택했을 때 대상 파일(`~/.claude/CLAUDE.md` 또는 `~/.codex/AGENTS.md`)에 append하는 내용. 레포 마커 블록과 달리 **조건부 문장으로만** 구성한다 — 이 머신의 모든 레포에 워크플로우를 강제하면 opt-in 필터(마커 블록)가 무의미해지기 때문이다.

```markdown
<!-- agent-workflow-protocol-global P-0011 start -->
<!-- agent-workflow-protocol-global-hash: <아래 마커 본문의 sha256> -->
## Agent Workflow (전역 라우팅)

다음 상황에서만 Agent Workflow Protocol을 따른다. 그 외에는 평소대로 작업한다 — 이 워크플로우를 강제하지 않는다.

- 지금 작업 중인 레포의 AGENTS.md에 `<!-- agent-workflow-protocol` 마커가 있다 → **이 전역 라우팅보다 그 마커 블록의 지시를 항상 우선한다.** 레포 로컬 설정이 전역보다 이긴다.
- 마커는 없지만 사용자가 align·kickoff·promote 중 하나를 이름으로 부르거나 "셰이핑하자"/"grill해줘"/"이 작업 마무리하자" 같은 트리거를 쓴다 → 해당 스킬을 실행하되, 이 세 스킬은 이슈 트래커·결정 ID 같은 레포별 설정에 의존하므로 이 레포가 아직 이식되지 않았다면 `setup-workflow` 실행 여부를 먼저 물어라.
- 마커는 없지만 사용자가 research·cold-read·setup-workflow·upstream-scout를 부른다 → 레포별 설정과 무관하게 곧바로 실행한다. setup-workflow를 먼저 제안하지 않는다.

원문: https://github.com/uoneway/link-workflow/blob/main/AGENT_WORKFLOW_PROTOCOL.md
<!-- agent-workflow-protocol-global end -->
```

- 마커 이름을 레포용(`agent-workflow-protocol`)과 다르게(`agent-workflow-protocol-global`) 둔 것은, 갱신 모드가 레포 마커와 전역 마커를 서로 다른 대상으로 착각하지 않게 하기 위함이다.
- 버전 스탬프·해시·갱신 로직은 레포 마커와 완전히 동일(`P-NNNN` 비교, 재렌더링 전 `agent-workflow-protocol-global-hash`로 사용자 수정 감지, 승인 후 마커 안쪽만 재렌더링) — 다만 갱신 대상 파일이 레포가 아니라 전역 파일이라는 점만 다르다.
- **align·kickoff·promote만 hard-dependency로 지정한 이유**: mattpocock ADR-0001의 hard/soft 의존성 구분을 그대로 적용했다. 이 셋은 이슈 트래커 권위·결정 ID 연번을 마커 블록에서 읽어야 틀리지 않게 동작하고, research·cold-read·upstream-scout는 레포별 설정을 아예 안 써서 setup-workflow 제안 자체가 불필요한 마찰이다(`upstream-sources.md`의 mattpocock/skills 항목 참고).
- link-workflow가 아직 private이면 마커 블록과 같은 이유로 원문 링크 줄은 비워두거나 생략한다.

## 동봉물 (스킬 폴더 위성 파일)

```
skills/setup-workflow/
├── SKILL.md
├── scripts/detect-repo-state.sh     # ⓪ pre-flight JSON
├── scripts/lint-decision-logs.sh    # ④4 복사용 (ai-tab 것 일반화, 상단에 # P-NNNN 스탬프 주석)
└── templates/
    ├── agents-block.md              # 마커 블록 템플릿 ({설정} 치환)
    ├── global-routing.md            # ②D 전역 선택 시 append하는 템플릿
    ├── PROJECT_STATE.md             # 프로토콜 Recommended Shape의 빈 골격
    └── BACKLOG.md
```

템플릿·스크립트를 스킬 폴더에 동봉하고 대상 레포에는 산출물만 남기는 패턴(spec-kit처럼 스크립트 트리를 심지 않는다)이 mattpocock setup에서 왔다는 근거는 `upstream-sources.md` 참고.

> `[검토점 4 → 확정 2026-07-13]` lint 스크립트는 마커 블록과 같은 방식으로 다룬다 — 새 메커니즘을 만들지 않고 이미 있는 `P-NNNN` 스탬프 비교를 재사용한다. 스크립트 상단에 `# P-NNNN`(복사 시점 프로토콜 변경 이력 행 ID) 주석을 남기고, 갱신 모드 1단계(마커 스탬프 비교)에서 이 스크립트의 스탬프도 함께 비교한다. 최신본과 다르면 diff를 보여주고 승인받은 뒤에만 교체한다 — 동결(A)처럼 버그가 영구 박제되지도, 자동 교체(B)처럼 레포가 커스터마이징한 스크립트를 조용히 덮어쓰지도 않는다. "존재하는 파일은 절대 안 덮는다"(④-5)의 예외는 이 스크립트 하나뿐이고, 그 예외도 자동이 아니라 매번 사용자 승인을 거친다.

## 금지

- 프로토콜 문서 전문을 대상 레포에 복사하기.
- 마커 블록 밖의 AGENTS.md 내용, 사용자 docs/를 수정·삭제하기 (②B에서 승인받은 매핑 실행은 예외).
- 빈 문서를 미리 깔아두기 (lazy 생성 원칙).
- pre-flight 없이 감으로 신규/기존을 판단하기.
- 전역 라우팅 마커 밖의 `~/.claude/CLAUDE.md` / `~/.codex/AGENTS.md` 내용을 건드리기.
- `machine_routing_asked=true`인데 ②D를 다시 묻기 (재설정은 사용자가 명시적으로 요청할 때만).

---

## 통째로 가져오지 않은 것 (기각 기록)

BMAD 해시 매니페스트·GSD map-codebase·superpowers SessionStart 훅·Agent OS index.yml을 왜 안 가져왔는지는 `upstream-sources.md`의 해당 소스 항목 참고.

> `[검토점 5 → 확정 2026-07-13]` 추적하지 않음(pull). 명단은 파생 가능 정보의 수동 사본이라 스스로 낡는다 — PROJECT_STATE `Last Updated` 삭제와 같은 원칙이고, link-workflow 자신의 경로 이동(~/docs → ~/Project)이 부패 시나리오의 실증. 갱신 수요는 방문과 동시에 발생하므로 미방문 레포의 낡음은 무비용(절차는 유저 레벨 스킬이라 항상 최신 — 낡는 건 마커 요약뿐). 일괄 점검이 필요한 드문 순간엔 `grep -rl "agent-workflow-protocol" ~/Project/*/AGENTS.md`로 그 시점의 진실을 즉석 파생 — 명단의 유일 효용이 한 줄로 대체된다.
