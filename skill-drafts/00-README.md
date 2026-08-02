# Skill Drafts — 합의용 초안

실 스킬 파일로 재작성하기 전, **무엇을 왜 실행해야 하는지 합의하기 위한 한국어 작업 문서**. 초안은 실행 대상도, 영어 스킬의 병행 사본도 아니다. 확정되면 이 폴더의 해당 초안은 삭제하고, 그 검토 기록은 `skill-rationales/<name>.md`로 보존한다. 확정된 목적·절차·경계를 바탕으로 `skills/<name>/SKILL.md`를 영어 실행본으로 새로 작성한다. 즉 문장별 번역이 아니라, 그 사상으로 처음부터 영어 스킬을 쓴다면 자연스러울 표현과 구조를 선택한다.

설치는 `scripts/link-skills.sh`가 같은 스킬을 `~/.claude/skills/<name>`(Claude Code)와 `~/.agents/skills/<name>`(Codex)에 symlink로 처리한다 — 레포가 source of truth고 `git pull`이 곧 업데이트다. 플러그인 패키징은 여러 스킬·MCP·훅을 함께 배포해야 할 때까지 보류한다.

## 승격 계약

초안 하나를 `skills/`로 옮길 수 있는 것은 아래를 모두 만족할 때다.

1. **결정 완료** — 본문의 `[검토점]`이 해결됐고, 프로토콜과 충돌하지 않는다.
2. **실행 가능** — 실제로 필요한 스크립트·템플릿·참조 파일이 함께 존재하며, 미구현 산출물을 전제하지 않는다.
3. **독립성** — 실행본은 이 초안·대화·주석을 읽지 않아도 행동할 수 있다. 배경 조사와 흡수·기각 이유는 `upstream-sources.md`에 남긴다.
4. **영어 재저작** — 실행본에는 초안의 검토 메모·출처 주석·번역투를 옮기지 않는다. 사용 시점에 필요한 지시만 명료한 영어로 쓴다.
5. **원자적 전환** — `skills/<name>/SKILL.md`(및 필요한 동봉물)와 `skill-rationales/<name>.md`를 추가하고, 같은 변경에서 이 폴더의 한국어 초안을 삭제한다. YAML front matter와 링크·스크립트를 검증한다.

스킬은 두 언어 버전을 동기화하는 체계가 아니다. **초안은 결정을 만드는 곳, `skill-rationales/`는 확정된 한국어 판단을 보존하는 곳, `skills/`는 그 결정을 실행하는 곳**이다. 이후 행동을 바꿔야 하면 새 한국어 초안과 리뷰로 다시 결정하고, 기록과 기존 영어 실행본을 그 결정에 맞춰 갱신한다.

## 주석 태그

- `[가져옴 · 출처]` — 원문을 거의 그대로 (번역 포함)
- `[변형 · 출처]` — 가져오되 수정함. 무엇을 왜 바꿨는지 병기
- `[신규 · 근거]` — 우리가 만든 것. 근거는 프로토콜 섹션 또는 세션 합의
- `[참조 · 출처]` — 아이디어만 빌리고 문장은 새로 씀
- `[검토점]` — 리뷰 때 결정할 열린 논점

`[가져옴]`·`[변형]`·`[참조]`가 가리키는 실제 흡수·기각 내용은 **`upstream-sources.md`로 옮겨 영구 보존한다**(2026-07-13). 이 폴더는 초안이 확정되는 순간 통째로 삭제되는데, 그 전까지 태그만 본문에 남겨두면 근거가 삭제와 함께 증발하기 때문이다. 리뷰가 끝나는 대로 세 태그는 본문에서 지우고 `upstream-sources.md`의 해당 소스 항목으로 옮긴다 — 초안 본문에는 `[신규]`(우리 자체 근거)와 `[검토점]`(아직 열린 논점)만 남는다.

## 적용한 저작 규율 (2026-07-07 비교 분석에서 채택)

1. **description은 트리거 전용** — "언제 쓰는가"만. 절차를 요약하면 에이전트가 본문 대신 설명만 따른다 (superpowers)
2. **no-op 테스트** — 기본 동작을 바꾸지 않는 문장은 삭제 (mattpocock writing-great-skills)
3. **조건부만 분리** — 무조건 이어지는 수(手)는 한 스킬에, 조건부 트리거는 위성 스킬로 (세션 합의)
4. **불변식은 프로토콜에, 절차는 스킬에** — 스킬은 AGENT_WORKFLOW_PROTOCOL.md를 재서술하지 않고 실행 절차만 담는다

## 남은 초안

```
setup-workflow (user-invoked, 이식 진입점 — 레포당 1회 + 갱신)
```

`align`, `kickoff`, `promote`, `workflow-research`, `cold-read`, `upstream-scout`는 2026-07-26에 `skills/` 영어 실행본으로 승격되어 이 폴더에서 삭제됐다. 현재 실행 관계는 [skills/](../skills/)에서 확인한다. `setup-workflow`는 선언한 스크립트·템플릿이 실제로 구현·검증되기 전까지 이 폴더에 남는다.

## 동기화 이력

- 2026-07-10 | 프로토콜 개정(결정 ID 규약·이슈 트래커 경계·reference 문서 기준)을 align 출구·kickoff 1/4단계·promote 1/3단계에 반영. ai-tab 적용 세션(PR #33)의 저작 패턴(Current Decision↔히스토리 중복 금지)도 promote에 수록. align의 구 "트래커 불채택" 기각 기록은 뒤집힘 표시.
- 2026-07-10 | 전면 리뷰 반영: promote 1단계에서 `Completed (recent)` 기록 제거(완료 이력은 merge 커밋이 담당), promote 검토점 1(merge 순서) 해소 표시, 중복 금지·이슈 닫기의 프로토콜(§4·§6) 편입 표시, research 착지 관례에서 `Created`·`Last Updated` 폐지(Update History로 일원화). 확정 스킬 착지가 `~/.claude/skills` 직접 재작성 → 레포 `skills/` + symlink 설치로 변경.
- 2026-07-12 | setup 초안 신설 — 레포 이식 진입점(레포 각인: AGENTS.md 마커 블록·docs/ 최소 골격·레포별 설정 + 갱신 모드). 근거: 이식 메커니즘 서베이와 [upstream-sources.md](../upstream-sources.md)의 spec-kit·Agent OS·BMAD·GSD·superpowers·mattpocock·gstack 흡수 기록. link-workflow의 목적을 "스킬 배포"가 아니라 "워크플로우 이식"으로 리프레이밍(사용자 방향).
- 2026-07-13 | setup 초안 검토점 3건 확정: ① 스킬명 `setup-workflow`(전역 네임스페이스 충돌 회피·트리거 자연어 일치 — 초안 파일명도 `setup-workflow.md`로 변경) ② 마커 버전 스탬프 = 변경 이력 행 연번 `P-NNNN`(프로토콜 P-0011로 규약 신설·소급 부여) ③ 이식 레포 추적 없음 — pull 방식(명단은 수동 사본이라 부패, 일괄 점검은 grep으로 즉석 파생).
- 2026-07-13 | link-workflow를 GitHub public 레포로 전환하기로 결정하면서 공개 전 정리: `upstream-sources.md`를 추적 표(4개→8개 소스, spec-kit·Agent OS·GSD·BMAD-METHOD 신규 등록) + 소스별 상세 흡수 기록(가져온 것/가져오지 않은 것과 그 이유)으로 전면 재작성. 이에 맞춰 6개 초안(align·cold-read·kickoff·promote·research·upstream-scout)에서 `[가져옴]`·`[변형]`·`[참조]` 태그를 본문에서 제거하고 `upstream-sources.md` 참조 문장으로 대체(`[신규]`·`[검토점]`은 유지). setup-workflow 초안의 남은 검토점 2건도 확정: 검토점 3(마커 블록에 프로토콜 원문 위치 — link-workflow GitHub URL로 포함, 로컬 경로 대신), 검토점 4(레포에 복사되는 `lint-decision-logs.sh`의 갱신 책임 — 마커 블록과 동일한 `P-NNNN` 스탬프 비교 방식 재사용, 승인 후 교체).
- 2026-07-17 | setup-workflow 초안에 "머신 레벨(선택)" 이식 단위 신설 — ②D 전역 라우팅 질문(머신당 최초 1회, `~/.claude/agent-workflow-protocol/state.json`으로 재질문 방지). Claude/Codex 도구 확인 후 전역(추천, `~/.claude/CLAUDE.md`/`~/.codex/AGENTS.md`) vs 로컬만(현행) 중 선택. 전역 배치는 레포 마커 블록의 opt-in 필터를 깨지 않도록 조건부 문장으로만 구성(`templates/global-routing.md`, 마커명 `agent-workflow-protocol-global`로 레포 마커와 구분). 근거: 스킬만 유저 레벨 설치하고 setup-workflow를 안 돌린 레포는 agent도 워크플로우를 모른다는 문제 제기 — 마커 블록은 "사람 협업자 가시성" 문제를, 전역 라우팅은 "이 머신의 모든 세션이 알게" 문제를 푸는 별개 메커니즘으로 병존시킴.
- 2026-07-19 | mattpocock/skills 설치·갱신 메커니즘(로컬 플러그인 캐시 + ADR-0001/0002 + vercel-labs/skills CLI 소스) 정밀 조사 후 5건 반영. ① kickoff·promote의 결정 ID 단계, align의 이슈 트래커 단계에 mattpocock ADR-0001 hard-dependency 패턴 적용 — 마커 블록에 값이 없으면 임의 진행 대신 setup-workflow부터 확인. ② 전역 라우팅 템플릿의 setup-workflow 제안 조건을 align·kickoff·promote(hard-dependency)로만 좁히고 research·cold-read·setup-workflow·upstream-scout는 무조건 즉시 실행하도록 분리 — 불필요한 마찰 제거. ③ 레포 마커·전역 마커 양쪽에 `*-hash`(sha256) 라인 신설, 갱신 모드에 재렌더링 전 사용자 직접 수정 감지·경고 단계 추가 — vercel-labs/skills의 `update`가 로컬 수정을 무경고로 덮어쓰는 것과 spec-kit의 자기 콘텐츠 해시 추적을 비교 분석해 후자를 채택. ④ 전역 라우팅 재설정 경로를 "전역 라우팅 다시 설정해줘" 명시 트리거로 확정(gstack `gstack-config set` 선례) — 열려 있던 검토점 해소. ⑤ 전역 라우팅 템플릿에 "레포 로컬 마커가 항상 우선" 명문화(gstack `project-local > global` 선례).
- 2026-07-20 | 프로토콜 P-0012 동기화: Align에 agent와 사용자의 이해 정렬(설명 뒤 대표 시나리오·질문으로 설명의 빈틈 확인)을 추가하고, 합의부를 Goal / Mental Model / Key Trade-off / Current Scope / Behavior Notes / Out of Scope로 확장. kickoff은 이 합의부를 착지하고, promote는 규모 있는 변경의 Change Brief·이해 확인과 기능 설명서 판정 기준을 실행한다. setup-workflow의 레포·전역 마커 템플릿은 P-0012 및 park / mark / explain 규칙으로 갱신.
- 2026-07-26 | 승격 전 검토 결정을 반영: promote는 merge 후 main에서만 실행·자동 커밋 금지, cold-read는 새 fresh agent로 한 번만 재감사, kickoff은 workstream 전용·branch/worktree 자동 생성으로 확정. workflow-research는 범용 research와의 Codex 설치 경로 충돌을 피하도록 분리하고, align은 하니스별 슬래시 문법 대신 역할명으로 핸드오프한다. upstream-scout는 2~3주마다 변화만 감지하고 minor 이상 릴리스 또는 의미 있는 변경이 있을 때만 검토용 다이제스트를 만들며, 결론 반영 뒤 삭제한다. setup-workflow는 동봉물 구현·검증 전까지 초안으로 유지하고, 완결된 작은 스킬의 승격을 먼저 진행한다.
- 2026-07-26 | 위 6개 확정 초안을 `skills/`의 영어 실행본으로 원자적으로 승격하고, 한글 원문은 `skill-rationales/`의 한국어 의사결정 기록으로 보존했다. 실행본은 문장별 번역이 아니라 확정된 목적·절차·경계를 독립 실행 가능한 영어 지시로 재저작했다.
