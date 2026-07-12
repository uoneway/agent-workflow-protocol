# setup-workflow — 초안

베이스: 신규 설계 — 2026-07-12 이식 메커니즘 서베이(`digests/2026-07-12-setup-transplant-survey.md`: spec-kit·Agent OS·BMAD·GSD·superpowers·mattpocock·gstack) 종합. 호출 방식: user-invoked.

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
| 레포 레벨 | ① AGENTS.md의 마커 블록 ② CLAUDE.md 포인터 ③ docs/ 최소 골격 ④ (선택) 결정 ID lint 스크립트 | 마커 블록 안 = setup-workflow가 소유(재렌더링 대상), 그 외 전부 = 레포가 소유(생성 후 절대 안 덮음) |

- **프로토콜 전문은 레포에 복사하지 않는다.** 마커 블록이 담는 것은 요약본이 아니라 운영 불변식 + 스킬 라우팅 + 레포별 설정이다.

> `[참조 · spec-kit constitution]` "형식만 이식, 내용은 레포 소유" — 전문 복사는 N-사본 동기화 문제를 만든다.
> `[참조 · superpowers 반례]` 유저 레벨에만 두면 레포에 흔적이 없어 협업자·미래 세션에 프로토콜이 전달되지 않는다 — 레포 각인이 이 스킬의 존재 이유.
> `[가져옴 · Agent OS v1.3 폐기 교훈 + spec-kit agent-context]` 지침 파일에 규칙 본문을 통주입하는 것은 "over-reading instructions into context"로 공식 폐기된 전례가 있다. 포인터 + 불변식 최소 주입만.

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
  "tracker_hint": "github-issues|none"    // gh로 이슈 활성 여부 감지
}
```

분기는 이 출력으로 결정한다 — LLM의 감이 아니다. `has_git=false`면 `git init`부터 제안하고, `already_setup=true`면 **갱신 모드**(아래)로 전환한다.

> `[가져옴 · GSD new-project]` 결정적 pre-flight — 신규/기존/이미 이식됨 분기를 스크립트 JSON으로.

**① 발견 제시.** 탐색 결과를 요약해 보여라: 무엇이 있고 무엇이 없는지, 어느 모드로 진행할지(신규 각인 / 기존 문서 흡수 / 갱신). 탐색이 이미 결정한 질문은 묻지 마라.

**② 섹션별 질문.** 한 섹션에 하나씩, 추천 답을 선행하라:

- **A. 이슈 트래커.** `tracker_hint`가 있으면 그것을 추천. 선택지: GitHub Issues / 없음(BACKLOG 단독) / 기타(한 문단 서술). 프로토콜의 권위 경계(셰이핑 완료 = 트래커, fog = BACKLOG)가 이 답에 따라 마커 블록에 기록된다.
- **B. 기존 문서 매핑** (doc_candidates·docs_dir가 비어있지 않을 때만). 문서마다 하나씩 제안하라: **유지**(reference로 인정) / **변환**(VISION·ARCHITECTURE로 병합) / **이관**(BACKLOG 또는 이슈로) / **폐기**. ADR 디렉토리가 있으면 decision-logs 전환 여부를 묻고, 전환하든 안 하든 결정 ID는 기존 연번을 승계한다(`ADR-{n+1}`부터 — 프로토콜 §4).
- **C. VISION 초안** (docs/VISION.md가 없을 때만). 3~5문답으로 초안을 만들어라: 무엇을/누구를 위해/지금 아닌 것. 답을 모르는 신규 레포면 "TBD 골격만 생성"도 유효한 답이다.

> `[가져옴 · mattpocock setup]` 탐색→발견 제시→섹션별 질문(추천 선행, 결정된 섹션 스킵)→초안 확인→쓰기 골격.
> `[참조 · ai-tab 문서 다이어트, 2026-07-10]` B의 매핑 4분류는 ai-tab 재구성에서 실증된 절차의 일반화.
> `[가져옴 · Agent OS v1 analyze-product]` 생성기는 하나 — 기존 레포는 B·C의 답을 기존 문서·코드에서 역채워 같은 흐름에 넣는다.

**③ 초안 확인.** 쓰기 전에 보여라: AGENTS.md 마커 블록 전문, 생성할 docs/ 골격 목록, B의 매핑 실행 계획. 사용자가 수정하게 하라.

**④ 쓰기.** 승인 후 한 커밋으로:

1. `AGENTS.md` — 있으면 마커 블록만 추가(기존 내용 불변), 없으면 마커 블록 + 빈 뼈대로 생성. `CLAUDE.md`가 실체 파일이면 내용을 AGENTS.md로 옮기고 포인터로 전환할지 물어라 — 어느 쪽이든 **이미 있는 파일을 편집하고, 반대쪽을 임의로 새로 만들지 마라.**
2. `docs/PROJECT_STATE.md`, `docs/BACKLOG.md` 골격 생성 (동봉 템플릿). VISION은 ②C의 초안. **그 외(GLOSSARY·LEARNINGS·decision-logs·features·workstreams)는 만들지 않는다** — 각 스킬이 필요해질 때 lazy 생성한다.
3. ②B의 매핑 실행 (변환·이관·폐기).
4. pre-commit을 쓰는 레포면 결정 ID lint(`lint-decision-logs.sh`) 복사를 제안하라 — 강제하지 마라.
5. 존재하는 파일은 절대 덮지 않는다. 스킵하고 보고하라.

> `[가져옴 · mattpocock setup]` 1의 "있는 파일을 편집, 반대쪽 생성 금지".
> `[가져옴 · mattpocock domain.md + 프로토콜 최소주의]` 2의 lazy 생성 — "없으면 조용히 진행".
> `[참조 · spec-kit recovered]` 5 — "생산하지 않은 파일"은 이후 갱신에서도 관리 대상이 아니다.

**⑤ 검증.** `/cold-read`를 돌려라 — 검증 대상은 AGENTS.md(마커 블록 포함): "이 레포를 처음 보는 agent가 이 파일만 보고 워크플로우를 따를 수 있는가." 시작 불가 질문이 나오면 마커 블록을 보강하라.

> `[신규 · 프로토콜 §2 검토 게이트]` cold-read의 재사용 — setup-workflow 산출물도 핸드오프 문서다.

**갱신 모드** (`already_setup=true`). 강제 재초기화는 없다:

1. 마커의 스탬프(`P-NNNN`)와 프로토콜 변경 이력의 마지막 행 ID를 비교하고, 그 사이의 행들을 사용자에게 보여라.
2. 바뀐 불변식이 마커 블록에 영향을 주면 diff를 제시하고, 승인 후 **마커 블록 안만** 재렌더링하라. 마커 밖과 docs/는 건드리지 않는다.

> `[가져옴 · GSD update]` "changelog 먼저 보여주고 확인 후 갱신".
> `[참조 · spec-kit 안티패턴]` 갱신과 강제 초기화를 한 동사로 뭉뚱그리면 사용자 커스텀이 날아간다 — 별도 모드 없음, 마커 안만이 setup-workflow의 영토.

## AGENTS.md 마커 블록 사양

```markdown
<!-- agent-workflow-protocol P-0011 start -->
## Agent Workflow

이 레포는 Agent Workflow Protocol을 따른다. 단계 어휘: Capture → Align → Kickoff → Develop → Resume → Promote.

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

> `[가져옴 · GSD claude-md 마커 + spec-kit agent-context]` 마커 경계 관리 섹션, 밖은 불가침, 없으면 append.
> `[검토점 2 → 확정 2026-07-13]` 버전 표기 = 변경 이력 행 연번 `P-NNNN` (프로토콜 P-0011로 규약 신설·소급 부여 완료). 날짜 기각 — 같은 날 다수 행이 실존(2026-07-10에 7행)해 기준점을 유일하게 지목 못 함. semver(spec-kit constitution)·릴리스 버전(gstack VERSION) 기각 — 리뷰 세션 단위 일괄 개정에 호환성·릴리스 의미론이 부적합하고 판정 비용만 부과. 결정 ID 규약(D-NNNN)으로 이미 검증된 연번 패턴의 재사용.
> `[검토점 3]` 마커 블록에 프로토콜 원문 위치(link-workflow 레포 경로/URL)를 넣을지 — 협업자 접근성 vs 사적 경로 노출. 현재 안은 넣지 않음(스킬이 안다).

## 동봉물 (스킬 폴더 위성 파일)

```
skills/setup-workflow/
├── SKILL.md
├── scripts/detect-repo-state.sh     # ⓪ pre-flight JSON
├── scripts/lint-decision-logs.sh    # ④4 복사용 (ai-tab 것 일반화)
└── templates/
    ├── agents-block.md              # 마커 블록 템플릿 ({설정} 치환)
    ├── PROJECT_STATE.md             # 프로토콜 Recommended Shape의 빈 골격
    └── BACKLOG.md
```

> `[가져옴 · mattpocock setup 위성 파일 패턴]` 템플릿·스크립트는 스킬 폴더에 동봉 — 대상 레포에는 산출물만 남기고, spec-kit처럼 스크립트 트리를 심지 않는다(규모 경계: 서베이 Implications 5).
> `[검토점 4]` lint 스크립트만은 예외적으로 레포에 복사된다(pre-commit이 레포 안에서 실행되므로). 이 파일의 이후 갱신 책임이 애매함 — 복사 시점 버전으로 동결 vs 갱신 모드가 함께 갱신.

## 금지

- 프로토콜 문서 전문을 대상 레포에 복사하기.
- 마커 블록 밖의 AGENTS.md 내용, 사용자 docs/를 수정·삭제하기 (②B에서 승인받은 매핑 실행은 예외).
- 빈 문서를 미리 깔아두기 (lazy 생성 원칙).
- pre-flight 없이 감으로 신규/기존을 판단하기.

---

## 통째로 가져오지 않은 것 (기각 기록)

- **BMAD 해시 매니페스트 3분류** — 마커 경계 + "존재 파일 불가침"만으로 충분한 규모. 코드 유지비가 이득을 초과.
- **GSD map-codebase / BMAD document-project 등가물(ARCHITECTURE 역생성)** — setup-workflow 범위 밖. brownfield에서 필요하면 별도 세션으로 제안만 한다 (setup-workflow가 비대해지면 실행 문턱이 올라간다).
- **superpowers SessionStart 훅 주입** — 훅은 하니스 종속이고, 우리 각인 대상은 사람도 읽는 AGENTS.md.
- **Agent OS index.yml 카탈로그** — 문서 수가 한 자릿수인 우리 docs/에는 Document Index(프로토콜)로 충분.

> `[검토점 5 → 확정 2026-07-13]` 추적하지 않음(pull). 명단은 파생 가능 정보의 수동 사본이라 스스로 낡는다 — PROJECT_STATE `Last Updated` 삭제와 같은 원칙이고, link-workflow 자신의 경로 이동(~/docs → ~/Project)이 부패 시나리오의 실증. 갱신 수요는 방문과 동시에 발생하므로 미방문 레포의 낡음은 무비용(절차는 유저 레벨 스킬이라 항상 최신 — 낡는 건 마커 요약뿐). 일괄 점검이 필요한 드문 순간엔 `grep -rl "agent-workflow-protocol" ~/Project/*/AGENTS.md`로 그 시점의 진실을 즉석 파생 — 명단의 유일 효용이 한 줄로 대체된다.
