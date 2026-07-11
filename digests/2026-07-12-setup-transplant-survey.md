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
8. **역방향 동기화 루프** — 대상 레포에서 진화한 규칙을 베이스로 회수하는 공식 경로 (Agent OS sync-to-profile). 우리는 이미 friction log("마찰:")가 그 역할 — setup이 새로 만들 것은 없고 경로가 살아있음만 확인.

## 소스별 발견

### github/spec-kit (`specify init`)

- 유저 레벨은 CLI 엔진뿐, 규칙·템플릿·스크립트는 전부 레포 안 `.specify/`로 복사. 신규/기존은 별도 모드가 아니라 파일 단위 병합 정책(`--here` 경고+확인, 존재 파일 스킵).
- **recovered 개념**: 이미 존재해서 덮지 않은 파일은 매니페스트에 "관찰했을 뿐 생산하지 않음"으로 기록 → 이후 갱신이 그 파일을 관리 파일로 착각하지 않음 (`shared_infra.py`).
- CLAUDE.md/AGENTS.md는 본체가 안 건드림. opt-in 확장(agent-context)이 마커 섹션에 "plan은 여기 있다"는 포인터 한 문단만 주입. 에이전트→지침 파일 매핑 테이블로 멀티 에이전트 대응.
- constitution(`.specify/memory/constitution.md`): 템플릿(형식)만 이식하고 내용은 레포가 소유·semver 관리. "프로토콜 불변식의 레포 내 사본"의 정답 형태 — 복제 동기화가 아니라 레포별 ratify.
- 안티패턴: 업그레이드를 `init --here --force`로 뭉뚱그려 사용자 커스텀이 날아감 — 공식 문서가 "constitution 수동 백업" 안내까지 하는 지경 (`docs/upgrade.md`).

### Agent OS (buildermethods/agent-os)

- 3층 분리: instructions/commands(프레임워크 소유·고정) / standards(사용자 소유·커스터마이즈) / product·specs(산출물). 설치 플래그가 경계를 반영(`--commands-only`).
- v1 analyze-product: 코드 분석 → 사용자 인터뷰 → 결과를 파라미터로 plan-product 재사용 → roadmap에 기 구현 기능 역기입. v3에서는 `/discover-standards`로 분해 — 대표 파일을 읽고 "unusual/opinionated/tribal" 패턴만 추출, 표준 1건씩 "왜 이렇게 하나?" 질문→초안→승인 루프.
- **CLAUDE.md 주입을 v1.3에서 공식 제거** ("over-reading instructions into context") — 주입 채널은 슬래시 커맨드뿐.
- `index.yml` 카탈로그: 스크립트가 구조(파일 스캔)를, 에이전트가 의미(설명)를 관리. 재생성 시 기존 설명 보존.
- sync-to-profile.sh: 프로젝트에서 다듬은 표준을 유저 레벨 프로필로 회수(백업 후).
- 안티패턴: v2의 1,000줄 bash 조건부 컴파일러({{IF}}/{{PHASE}}) — 도구가 진화하자 v3에서 통째 폐기. 도구 기능을 재발명하지 말 것.

### BMAD-METHOD (`npx bmad-method install`)

- 설치는 분기하지 않고 워크플로우 레벨에서 brownfield 대응: `bmad-generate-project-context`(스택·관례 중 "unobvious한 것"만 추출), `bmad-document-project`(문서 역생성), 아키텍처 워크플로는 기존 코드를 "비준(ratify)" 대상으로 취급.
- 재설치 3분류: 미변경 stock은 덮어씀 / 사용자 추가 파일 보존 / 사용자 수정 stock은 새판 설치 + 기존본 `.bak`. 해시 files-manifest 기반.
- 팀/개인 2스코프 설정: `config.toml`(커밋) vs `config.user.toml`(gitignored, 자동 시드). 커스터마이즈는 수정이 아니라 오버레이(base→team→user TOML 머지).
- CLAUDE.md/AGENTS.md 주입 없음 — 네이티브 스킬 규격으로만.
- 안티패턴: 모놀리식 대량 이식(스킬 수십 개 + `_bmad/` 트리, installer 1,745줄) — setup이 이 규모를 흉내내면 유지보수가 본업을 잡아먹는다.

### GSD (get-shit-done-cc)

- `.planning/` = 레포의 living memory: PROJECT.md(컨텍스트) / STATE.md(현재 위치 — 어느 세션이든 resume) / ROADMAP / config.json(산출물 커밋 여부까지 레포별 설정). 우리 프로토콜의 PROJECT_STATE+workstream에 해당.
- pre-flight를 스크립트로: `is_brownfield`, `needs_codebase_map`, `has_git`, `project_exists`를 JSON으로 받고, 기존 레포면 "map 먼저" 게이트 → 병렬 mapper가 `.planning/codebase/` 7문서(STACK/ARCHITECTURE/CONVENTIONS/...) 역생성 → 기존 기능을 "이미 검증된 요구사항"으로 시드.
- CLAUDE.md는 마커 7섹션(`<!-- GSD:x-start/end -->`)을 `.planning/` 문서에서 **렌더링** — 재생성 멱등, 마커 밖 사용자 영역 보존, 마커 없으면 append.
- 업데이트: SessionStart 훅이 새 버전 감지 → changelog 표시 → 확인 → 재설치, 로컬 수정은 백업 후 재적용 제안.
- 안티패턴: 11,376줄 install.js가 16개 런타임을 regex 콘텐츠 치환으로 지원 — "콘텐츠 변환 복사"가 아니라 단일 소스 참조로 설계할 것.

### superpowers (obra)

- 전부 유저 레벨 플러그인. 레포에는 산출물(specs/plans 문서)만 커밋되고 설치물 없음. CLAUDE.md 대신 SessionStart 훅으로 부트스트랩 스킬 1개만 주입(콜드 스타트 최소화).
- 우선순위 명문화: "User instructions (CLAUDE.md...) take precedence over skills".
- 우리 목적에는 반례: 레포에 워크플로우의 규칙·상태가 안 남아 플러그인 없는 협업자/미래 세션에 프로토콜이 전달되지 않음.

### mattpocock setup-matt-pocock-skills / gstack (로컬 확인)

- mattpocock: "prompt-driven skill, not deterministic script". 탐색(remote·기존 AGENTS/CLAUDE·모노레포 신호·prior output) → 발견 제시 → 섹션별 질문(추천 선행, 탐색이 결정한 섹션은 스킵) → 초안 확인 → 쓰기. 레포별 설정은 `docs/agents/*.md`로 착지해 다른 스킬이 소비("스킬이 X라고 하면 Y를 하라"는 소비자 계약 형식). 마커 섹션은 in-place 갱신, "CLAUDE.md가 있으면 그것을 편집, 절대 반대쪽을 새로 만들지 않기". 문서는 lazy 생성 — "없으면 조용히 진행".
- gstack: setup은 유저 레벨 설치 전용(멀티 하니스 symlink + Windows copy fallback). 업그레이드는 VERSION 파일 + `gstack-upgrade` 스킬 + 버전별 idempotent 마이그레이션 스크립트(`migrations/v*.sh`).

## Implications (setup 스킬 설계에 주는 함의)

1. 이식 단위는 2층: 스킬(절차)은 유저 레벨 symlink로 이미 해결 — setup이 새로 맡을 것은 **레포 각인**(AGENTS.md 마커 블록 + docs/ 최소 골격 + 레포별 설정)뿐이다.
2. AGENTS.md 주입물은 "프로토콜 요약본"이 아니라 **운영 불변식 + 라우팅 + 레포별 설정**의 마커 블록 하나. 프로토콜 전문 복사는 N-사본 동기화 문제를 만든다(constitution 교훈: 형식만 이식).
3. 신규/기존은 파이프라인 분리가 아니라 pre-flight 감지 + 입력 역채움. 기존 문서의 다이어트 매핑(ai-tab 선례)이 brownfield의 본체다. ARCHITECTURE 역생성(GSD map-codebase 등가)은 무거우므로 setup 범위 밖 — 선택 후속 세션.
4. 재실행은 "갱신 모드"로 분리: 마커의 프로토콜 버전 스탬프 비교 → diff 제시 → 마커 안만 재렌더링. 존재 파일은 절대 덮지 않는다.
5. 규모 경계: 해시 매니페스트·조건부 컴파일러·멀티 하니스 치환은 전부 우리 규모에 과함이 실증됨. 스크립트는 pre-flight 감지 1개 + (선택) 결정 ID lint 1개면 충분하다.

## Update History

- 2026-07-12 (claude): 최초 조사 — 병렬 서브에이전트 3(spec-kit / Agent OS·BMAD / superpowers·GSD, 전부 클론 후 소스 정독) + 로컬 클론 직접 확인 2(mattpocock, gstack)
