# Setup/이식 메커니즘 서베이 — spec-kit · Agent OS · BMAD · GSD · superpowers · mattpocock · gstack

## Topic

워크플로우를 대상 git 레포에 이식하는 setup 스킬 설계를 위한 조사.
브리프: ① 유명 레포들은 setup/init을 어떻게 설계했나 ② 좌우되는 결정 — setup 스킬의 구조(이식 단위 / 신규·기존 분기 / AGENTS.md 주입 내용 / 스크립트 구성 / 재실행) ③ 마음을 바꿀 발견 — "레포 각인 없이 유저 레벨 설치만으로 충분하다"는 증거 (→ 발견되지 않음. superpowers가 그 경로인데, 레포에 워크플로우 흔적이 안 남아 협업자·미래 세션에 전달되지 않는 것이 우리 목적에는 반례로 확인됨).

## 채택 후보 (설계에 반영할 패턴)

1. **마커 블록 + 최소 주입** — AGENTS.md에는 `<!-- start/end -->` 마커 사이 관리 섹션만 두고, 규칙 본문이 아니라 포인터·불변식 요약만 넣는다 (spec-kit agent-context, GSD claude-md 렌더링, Agent OS v1.3의 "over-reading" 폐기 교훈).
2. **결정적 pre-flight** — 신규/기존/이미 이식됨 분기를 LLM 감이 아니라 스크립트의 JSON 출력으로 결정 (GSD `is_brownfield`/`needs_codebase_map`).
3. **생성기는 하나, 기존 레포는 입력 역채움** — greenfield/brownfield 별도 파이프라인이 아니라, 기존 레포는 분석으로 인터뷰 답을 미리 채워 같은 생성기에 넣는다 (Agent OS v1 analyze-product→plan-product, "Phase 0: Already Completed" 역기입).
4. **갱신 ≠ 강제 초기화** — 재실행을 별도 동사로 분리하고, setup 소유 영역(마커 안)과 레포 소유 영역(그 외 전부)의 경계를 지킨다. 존재하는 파일은 덮지 않는다 (spec-kit recovered 플래그의 단순화판; BMAD 3분류는 우리 규모에 과함).
5. **탐색 → 발견 제시 → 섹션별 질문(추천 선행) → 초안 확인 → 쓰기** — setup의 대화 골격 (mattpocock setup-matt-pocock-skills).
6. **lazy 생성** — 없는 문서를 미리 깔지 않는다. "없으면 조용히 진행, 실제로 필요해질 때 생성" (mattpocock domain.md; 프로토콜 최소주의와 합치).
7. **버전 스탬프 + 갱신 감지** — 마커에 프로토콜 버전을 박고 재실행 시 비교 (gstack VERSION + 버전별 idempotent 마이그레이션, spec-kit 매니페스트의 version 필드).
8. **역방향 동기화 루프** — 대상 레포에서 진화한 규칙을 베이스로 회수하는 공식 경로. 우리는 이미 friction log("마찰:")가 그 역할 — setup이 새로 만들 것은 없고 경로가 살아있음만 확인. (주의: 원래 Agent OS `sync-to-profile.sh`를 이 패턴의 근거로 들었으나 라운드 2에서 오독으로 정정 — 아래 "정정" 참고. 결론 자체는 유효.)

## 소스별 발견

### github/spec-kit (`specify init`)

- 유저 레벨은 CLI 엔진뿐, 규칙·템플릿·스크립트는 전부 레포 안 `.specify/`로 복사. 신규/기존은 별도 모드가 아니라 파일 단위 병합 정책(`--here` 경고+확인, 존재 파일 스킵).
- **recovered 개념**: 이미 존재해서 덮지 않은 파일은 매니페스트에 "관찰했을 뿐 생산하지 않음"으로 기록 → 이후 갱신이 그 파일을 관리 파일로 착각하지 않음 (`shared_infra.py`).
- CLAUDE.md/AGENTS.md는 본체가 안 건드림. opt-in 확장(agent-context)이 마커 섹션에 "plan은 여기 있다"는 포인터 한 문단만 주입. 에이전트→지침 파일 매핑 테이블로 멀티 에이전트 대응.
- constitution(`.specify/memory/constitution.md`): 템플릿(형식)만 이식하고 내용은 레포가 소유·semver 관리. "프로토콜 불변식의 레포 내 사본"의 정답 형태 — 복제 동기화가 아니라 레포별 ratify.
- 안티패턴: 업그레이드를 `init --here --force`로 뭉뚱그려 사용자 커스텀이 날아감 — 공식 문서가 "constitution 수동 백업" 안내까지 하는 지경 (`docs/upgrade.md`).

### Agent OS (buildermethods/agent-os)

- 3층 분리(v3 이전): instructions/commands(프레임워크 소유·고정) / standards(사용자 소유·커스터마이즈) / product·specs(산출물). 설치 플래그가 경계를 반영(`--commands-only`).
- v1 analyze-product: 코드 분석 → 사용자 인터뷰 → 결과를 파라미터로 plan-product 재사용 → roadmap에 기 구현 기능 역기입. v3에서는 `/discover-standards`로 분해 — 대표 파일을 읽고 "unusual/opinionated/tribal" 패턴만 추출, 표준 1건씩 "왜 이렇게 하나?" 질문→초안→승인 루프.
- **CLAUDE.md 주입을 v1.3에서 공식 제거** ("over-reading instructions into context") — 주입 채널은 슬래시 커맨드뿐.
- `index.yml` 카탈로그: 스크립트가 구조(파일 스캔)를, 에이전트가 의미(설명)를 관리. 재생성 시 기존 설명 보존.
- 안티패턴: v2의 1,000줄 bash 조건부 컴파일러({{IF}}/{{PHASE}}) — 도구가 진화하자 v3에서 통째 폐기. 도구 기능을 재발명하지 말 것.

### BMAD-METHOD (`bmad-code-org/BMAD-METHOD`)

- 설치는 분기하지 않고 워크플로우 레벨에서 brownfield 대응: `bmad-generate-project-context`(스택·관례 중 "unobvious한 것"만 추출), `bmad-document-project`(문서 역생성), 아키텍처 워크플로는 기존 코드를 "비준(ratify)" 대상으로 취급.
- 재설치 3분류: 미변경 stock은 덮어씀 / 사용자 추가 파일 보존 / 사용자 수정 stock은 새판 설치 + 기존본 `.bak`. 해시 files-manifest 기반.
- 팀/개인 2스코프 설정: `config.toml`(커밋) vs `config.user.toml`(gitignored, 자동 시드). 커스터마이즈는 수정이 아니라 오버레이(base→team→user TOML 머지).
- CLAUDE.md/AGENTS.md 주입 없음 — 네이티브 스킬 규격으로만.
- 안티패턴: 모놀리식 대량 이식(스킬 수십 개 + `_bmad/` 트리, installer 1,745줄) — setup이 이 규모를 흉내내면 유지보수가 본업을 잡아먹는다.

### GSD — 원조는 아카이브, 활성 계보는 open-gsd/gsd-core (라운드 2에서 확인)

- `.planning/` = 레포의 living memory: PROJECT.md(컨텍스트) / STATE.md(현재 위치 — 어느 세션이든 resume) / ROADMAP / config.json(산출물 커밋 여부까지 레포별 설정). 우리 프로토콜의 PROJECT_STATE+workstream에 해당.
- pre-flight를 스크립트로: `is_brownfield`, `needs_codebase_map`, `has_git`, `project_exists`를 JSON으로 받고, 기존 레포면 "map 먼저" 게이트 → 병렬 mapper가 `.planning/codebase/` 7문서(STACK/ARCHITECTURE/CONVENTIONS/...) 역생성 → 기존 기능을 "이미 검증된 요구사항"으로 시드.
- CLAUDE.md는 마커 섹션을 `.planning/` 문서에서 **렌더링** — 재생성 멱등, 마커 밖 사용자 영역 보존, 마커 없으면 append.
- 업데이트: 새 버전 감지 → changelog 표시 → 확인 → 재설치, 로컬 수정은 백업 후 재적용 제안.
- 안티패턴: 대형 install.js가 다수 런타임을 regex 콘텐츠 치환으로 지원 — "콘텐츠 변환 복사"가 아니라 단일 소스 참조로 설계할 것.

### superpowers (obra)

- 전부 유저 레벨 플러그인. 레포에는 산출물(specs/plans 문서)만 커밋되고 설치물 없음. CLAUDE.md 대신 SessionStart 훅으로 부트스트랩 스킬 1개만 주입(콜드 스타트 최소화).
- 우선순위 명문화: "User instructions (CLAUDE.md...) take precedence over skills".
- 우리 목적에는 반례: 레포에 워크플로우의 규칙·상태가 안 남아 플러그인 없는 협업자/미래 세션에 프로토콜이 전달되지 않음.

### mattpocock setup-matt-pocock-skills / gstack (로컬 확인)

- mattpocock: "prompt-driven skill, not deterministic script". 탐색(remote·기존 AGENTS/CLAUDE·모노레포 신호·prior output) → 발견 제시 → 섹션별 질문(추천 선행, 탐색이 결정한 섹션은 스킵) → 초안 확인 → 쓰기. 레포별 설정은 `docs/agents/*.md`로 착지해 다른 스킬이 소비("스킬이 X라고 하면 Y를 하라"는 소비자 계약 형식). 마커 섹션은 in-place 갱신, "CLAUDE.md가 있으면 그것을 편집, 절대 반대쪽을 새로 만들지 않기". 문서는 lazy 생성 — "없으면 조용히 진행".
- gstack: setup은 유저 레벨 설치 전용(멀티 하니스 symlink + Windows copy fallback). 업그레이드는 VERSION 파일 + `gstack-upgrade` 스킬 + 버전별 idempotent 마이그레이션 스크립트(`migrations/v*.sh`).

## Implications (setup 스킬 설계에 주는 함의 — 라운드 1)

1. 이식 단위는 2층: 스킬(절차)은 유저 레벨 symlink로 이미 해결 — setup이 새로 맡을 것은 **레포 각인**(AGENTS.md 마커 블록 + docs/ 최소 골격 + 레포별 설정)뿐이다.
2. AGENTS.md 주입물은 "프로토콜 요약본"이 아니라 **운영 불변식 + 라우팅 + 레포별 설정**의 마커 블록 하나. 프로토콜 전문 복사는 N-사본 동기화 문제를 만든다(constitution 교훈: 형식만 이식).
3. 신규/기존은 파이프라인 분리가 아니라 pre-flight 감지 + 입력 역채움. 기존 문서의 다이어트 매핑(ai-tab 선례)이 brownfield의 본체다. ARCHITECTURE 역생성(GSD map-codebase 등가)은 무거우므로 setup 범위 밖 — 선택 후속 세션.
4. 재실행은 "갱신 모드"로 분리: 마커의 프로토콜 버전 스탬프 비교 → diff 제시 → 마커 안만 재렌더링. 존재 파일은 절대 덮지 않는다.
5. 규모 경계: 해시 매니페스트·조건부 컴파일러·멀티 하니스 치환은 전부 우리 규모에 과함이 실증됨. 스크립트는 pre-flight 감지 1개 + (선택) 결정 ID lint 1개면 충분하다.

---

## 라운드 2 — 전역/로컬 설정 분리 (2026-07-18)

브리프: ① 7개 소스가 "머신 전체 적용 설정"과 "이 프로젝트만 적용 설정"을 어떻게 나누나, "한 번 묻고 다시 안 묻기" UX가 있나, 멀티 에이전트 도구를 어떻게 지원하나 ② 좌우되는 결정 — setup-workflow의 신설 기능 "머신 레벨 전역 라우팅"(머신당 1회 질문 + 상태 파일 기억 + 조건부 텍스트) 설계 검증 ③ 마음을 바꿀 발견 — 우리 패턴보다 나은 "머신당 1회 기억" 메커니즘이 있으면.

### 정정 — 라운드 1의 오독

- **Agent OS `sync-to-profile.sh`는 "묻고 기억"이 아니다.** 방향이 반대다 — 프로젝트에서 다듬은 표준을 **base 프로필로 되돌려 저장(promote)**하는 도구이고, 매 실행 대화형 체크박스, "다시 안 묻기" 상태 저장 없음. 채택 후보 8번("역방향 동기화 루프")의 결론("우리는 friction log가 그 역할") 자체는 유효하지만, 근거로 든 메커니즘의 실체가 달랐다.
- Agent OS "3층 분리"는 **v3.0(2026-01-20)에서 instructions 층이 은퇴**하고 standards+product 2층으로 단순화됐다. v3 커맨드 설치는 `.claude/commands/agent-os/`로 하드코딩 — README가 언급하는 Cursor 등 지원은 v3 스크립트에 없음(과거 버전엔 있었음).
- **GSD는 두 계보로 갈라졌다.** 원조 `gsd-build/get-shit-done`(라운드 1이 조사한 대상)은 **아카이브됨**, README가 후속으로 리다이렉트한다. 활성 후속은 **`open-gsd/gsd-core`**로, 원조보다 훨씬 정교하고 머신 레벨(`~/.gsd/`) 레이어가 실제로 존재한다 — 아래는 이 활성 레포 기준.

### 소스별 발견 — 전역/로컬 관점

**github/spec-kit** — 유저 전역(`~/.specify/`)은 "카탈로그가 어디 있나"만 가리키고 실제 콘텐츠는 전부 프로젝트에 물리 존재(카탈로그 해석은 프로젝트가 유저 전역을 override). `specify init`이 "한 번 묻고 기억" 정석 — `--integration` 미지정 시 대화형 → `.specify/integration.json`에 저장 → 재질문 안 함, 답 변경은 `specify integration use/switch`로 명시적. 단 **이 기억은 프로젝트당 1회**, 머신당이 아니다. 컨텍스트 파일(CLAUDE.md/AGENTS.md) 쓰기는 **opt-in 확장(`agent-context`)이 전담** — CLI 기본은 "no agent-context state whatsoever, never creates/updates/removes"라고 명문화. 자기가 쓴 내용은 SHA-256 해시로 추적해 사용자가 손댄 블록은 갱신/삭제 때 보존.

**Agent OS v3** — base(머신, `~/agent-os/`)→project로 **설치 시점 1회성 복사**(런타임 참조 아님). 프로필 상속(`config.yml`의 `inherits_from`)은 파일 직접 편집. 도구 확인 프롬프트·"don't ask again" 플래그 없음.

**BMAD-METHOD** — `config.toml`(팀, 커밋) vs `config.user.toml`(개인, gitignore)는 **팀/개인 스코프이지 머신/프로젝트 스코프가 아니다** — 둘 다 프로젝트 내부에 있다. 머신 전역 *설정* 파일은 없음(과거 있던 `global-core-config.md`는 제거됨). 단 **스킬 파일 설치 위치**엔 전역 개념이 있다(`platform-codes.yaml`의 `target_dir` vs `global_target_dir`, 예 Codex는 `~/.codex/skills`). 툴 선택은 설치 시 명시 프롬프트/플래그(`--tools`), 자동 감지 아님.

**GSD-core(활성)** — `~/.gsd/defaults.json`("save as global defaults")가 우리 "상태 파일"에 가장 가까운 선례이지만, **행동(behavior)은 항상 프로젝트 스코프**(`.planning/config.json`)에 두고 머신 레이어는 새 프로젝트 시드 기본값·시크릿·opt-in learnings 저장소로만 쓴다. **마커 구획이 전방위 표준**(Claude `CLAUDE.md` 마커, Cline 글로벌 `~/.agents/AGENTS.md` 마커, Kimi 훅 마커) — 마커 없는 기존 파일은 `--force` 없이 절대 안 덮음, uninstall은 자기 블록만 제거. **"마커/명시적 호출이 있을 때만 작동하는 조건부 텍스트"가 활성화 모델 그 자체** — config-reload 훅은 `.planning/config.json` 없으면 no-op, Copilot 훅은 `.planning/` 존재 여부만 advisory로 알린다. 툴 선택은 설치 시 프롬프트/플래그(`--claude`/`--codex`), 선택값을 config `runtime` 키에 저장.

**superpowers** — 전역/프로젝트 분리 **자체가 없음**(전부 유저 레벨, 프로젝트 설정 레이어를 코어 기여 가이드가 명시적으로 거부). "한 번 묻고 기억" 없음 — SessionStart 훅이 매 세션 무상태 재주입, 유저 전역 파일(`~/.claude/CLAUDE.md`)은 **건드리지 않고 세션마다 컨텍스트로 일시 주입만** 한다. 10개 하니스를 지원하지만 **하니스별로 따로 설치**해야 함(자동 감지·단일 설정 없음).

**mattpocock/skills** — "한 번 묻고 기억"(`/setup-matt-pocock-skills`)은 **철저히 레포 스코프** — 커밋되는 프로젝트 파일이지 머신 범위 재질문 억제 상태 파일이 아니다. 하드 의존 스킬은 per-repo 설정 없이 **작동 자체를 거부**(inert-until-seeded), 소프트 의존은 graceful degrade — opt-in 게이트의 또 다른 형태.

**gstack — 가장 근접한 선례.** 전역 설치가 **기본·권장**(프로젝트 로컬은 deprecated). "한 번 묻고 기억"이 여러 겹으로 구현됨: `gstack-config get/set`(CLI flag > 저장 config > 대화형 프롬프트 우선순위, 답을 저장해 재사용), 결정별 개별 마커 파일(`.plan-tune-hooks-prompted`, `.welcome-seen` — 하나의 거대 상태 파일이 아니라 결정마다 분리), 런타임 질문 선호 훅(`never-ask`/`always-ask`를 훅으로 결정론적 강제, **project-local이 global을 이김**). 비-TTY/CI는 항상 안전 기본값(무프롬프트, 타임아웃 자동선택). 멀티 툴은 선언적 `HostConfig`(호스트별 바이너리 감지 `command -v`, 경로 재작성, 심링크 전략) + `--host auto` 자동 감지 — Windows는 심링크 대신 복사 폴백. **유저 전역 설정 파일(`settings.json`)은 명시 동의 없이는 절대 조용히 변형하지 않는다**는 원칙이 문서화돼 있다. 팀 강제(`gstack-team-init required`)는 우리 우려와 반대 방향(레포가 전역 설치를 요구)이지만 설계 공간을 보여준다.

### Implications 갱신 — 전역 라우팅 설계에 주는 함의

1. **우리 설계("머신당 1회, 재질문 안 함")는 gstack 외엔 정확한 선례가 없다.** spec-kit·mattpocock은 프로젝트당 1회(새 레포마다 재질문), Agent OS·BMAD·GSD는 행동을 프로젝트 스코프에 두고 머신 레이어는 시드값·시크릿용으로만 쓴다. → 이례적으로 공격적인 설계라는 뜻이고, 그래서 **"나중에 재설정" 경로가 부가 기능이 아니라 필수 안전장치**다.
2. **재설정 경로는 "상태 파일을 지우라"가 아니라 명시적 명령으로 열어야 한다** — gstack의 `gstack-config set` 선례. 이전에 열어둔 검토점("전역↔로컬 재진입 방법")의 답으로 채택할 것.
3. **레포 로컬 마커가 항상 전역 라우팅을 이겨야 한다** — gstack의 `project-local > global` 우선순위 원칙을 그대로 채택. 지금 템플릿엔 이 우선순위가 암묵적("마커가 있으면 따르고")이지만 명시적으로 못박을 것.
4. **전역 파일에 쓴 내용은 마커 경계로만 보호되고 있어, 사용자 편집 보존 장치가 없다** — spec-kit의 SHA-256 추적, gstack의 "explicit consent, never silently mutate" 원칙 참고. 갱신 모드가 전역 마커를 재렌더링할 때 사용자가 마커 안쪽을 직접 고쳤으면 덮어쓰기 전에 알릴 것.
5. **"세션마다 일시 주입" vs "영구 파일 편집"은 다른 리스크 등급이다** — superpowers는 훅으로 일시 주입해 전역 파일을 아예 안 건드린다. 우리가 영구 편집을 택한 건(레포 마커가 원래 풀려던 "사람도 읽는 흔적" 문제가 전역 레이어엔 없는데도) 재고할 가치는 있으나, Codex엔 세션 훅 개념이 없어 두 도구를 동일하게 다루려면 결국 파일 편집이 필요하다는 반론도 있다 — 기각 후보로만 남김.
6. **멀티 툴 "한 답, 여러 하니스" 자동 감지가 필요해지면 gstack의 HostConfig(바이너리 감지+경로 재작성+심링크/복사 폴백)가 레퍼런스** — 지금 우리 `tool_hint`(디렉토리 존재 감지)는 그 경량판으로 충분하지만, 도구가 3개 이상으로 늘면 이 패턴을 정식 채택할 것.

## Update History

- 2026-07-12 (claude): 최초 조사 — 병렬 서브에이전트 3(spec-kit / Agent OS·BMAD / superpowers·GSD, 전부 클론 후 소스 정독) + 로컬 클론 직접 확인 2(mattpocock, gstack)
- 2026-07-18 (claude): 전역/로컬 설정 분리 관점으로 재조사(병렬 서브에이전트 3: spec-kit·Agent OS / BMAD·GSD / superpowers·mattpocock·gstack). Agent OS sync-to-profile 오독 정정, GSD 활성 계보(open-gsd/gsd-core) 반영. 전역 라우팅 설계(머신당 1회 질문+상태 파일+조건부 텍스트) 검증 — gstack이 가장 근접한 선례로 확인, 재설정 경로·우선순위 명시·편집 보존을 보강 필요 항목으로 도출
