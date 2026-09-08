# Upstream Sources

이 문서는 두 역할을 겸한다.

1. **추적 표** — `upstream-scout`가 참조하는 소스와 마지막 리뷰 지점(얕고 자주 갱신).
2. **소스별 흡수 기록** — 각 소스에서 실제로 무엇을 가져왔고, 무엇을 보고도 가져오지 않았고, 왜 그렇게 판단했는지(깊고 안정적으로 유지).

`skill-drafts/*.md`의 `[가져옴 · X]` `[변형 · X]` `[참조 · X]` 주석은 초안이 `skills/<name>/SKILL.md`로 확정되는 순간 통째로 삭제되는 임시 스캐폴딩이다(`skill-drafts/00-README.md` 참고). 그 근거가 초안 삭제와 함께 증발하지 않도록, 실제 흡수·기각 판단은 전부 이 문서로 옮겨 영구 보존한다. 스킬 초안 본문에는 더 이상 이 세 태그가 남지 않는다 — `[신규 · X]`(우리 자체 근거)와 `[검토점]`(아직 열린 논점)만 남는다.

## 추적 표

| 소스 | 종류 | 마지막 리뷰 | 지점 |
|---|---|---|---|
| mattpocock/skills | repo | 2026-09-06 | main `3cca18b` (2026-09-04) |
| obra/superpowers | repo | 2026-09-06 | v6.3.0 |
| garrytan/gstack | repo (로컬 클론 — fetch만, merge/pull 금지) | 2026-07-07 | v1.58.5 |
| aihero.dev | blog | 2026-09-06 | Skills v1.2 변경 안내·grilling 문서(2026-08-24) |
| github/spec-kit | repo | 2026-07-12 | 이식 서베이 조사 시점 (커밋 해시 미기록) |
| buildermethods/agent-os | repo | 2026-09-06 | v3 migration 재검토 |
| open-gsd/gsd-core (GSD, 활성 계보) | repo | 2026-07-24 | 원조 `gsd-build/get-shit-done`은 아카이브됨; 활성 계보 검증 |
| bmad-method (BMAD-METHOD) | repo | 2026-07-12 | 이식 서베이 조사 시점 |
| Geoffrey Litt | blog | 2026-09-06 | "Understanding is the new bottleneck" 재해석 |
| Anthropic Engineering | blog | 2026-09-06 | 2025 장기 실행 harness·2026 후속 단순화 |
| Microsoft Research | paper | 2026-09-06 | CHI 2025 지식노동자 설문 |
| Anthropic·OpenAI prompting guidance | official docs | 2026-07-24 | 목표·제약·경계 중심 저작 원칙 |

spec-kit·Agent OS·GSD·BMAD-METHOD 4개는 2026-07-12 이식 메커니즘 서베이에서 `setup-workflow` 설계를 위해 처음 조사됐다. 이 문서가 갱신되기 전까지는 추적 표에 등록되지 않은 채 검토 packet에만 있었다.

## 소스별 흡수 기록

### mattpocock/skills

초기 `align`·`kickoff`·`promote`·research 골격에 가장 큰 영향을 준 소스다. 2026-09 리뷰에서는 질문 묶음과 무거운 흐름의 적용 경계를 다시 비교했고, `kickoff`·`promote`는 폐기했다.

**가져온 것**

- **grill 루프와 round-based 질문** — 초기에는 한 번에 한 질문과 추천 답을 `align`의 뼈대로 삼았다. v1.2가 독립적인 질문을 round로 묶도록 바뀐 뒤, 관련 선택을 함께 볼 때 사용자가 관계와 빠진 관점을 더 잘 판단한다는 사용자 피드백과 합쳐 질문 묶음을 채택했다. 다만 업스트림의 모든 decision frontier 소진은 가져오지 않고 결과·증거·경계·위임·재논의 조건이 맞으면 실행으로 넘어간다. [v1.2 변경 안내](https://www.aihero.dev/skills/skills-changelog-v12-wait-what-writing-for-agents-claude-code-plugin-and-more), [grilling 설명](https://www.aihero.dev/skills-grilling)
- **grill-with-docs의 교차검증** — "사용자가 진술한 작동 방식이 코드와 맞는지 확인하라", "구체적 시나리오로 압박 테스트하라" 두 항목만 가져왔다. 같은 스킬의 CONTEXT.md 용어집 생성 절차는 가져오지 않았다 — domain-modeling 자체를 이 워크플로우에 들일지가 보류 상태라, 그 위성 절차만 먼저 들이면 앞뒤가 안 맞는다고 판단했다.
- **research의 조사 원칙** — 1차 소스까지 따라가고 사실과 해석을 구분하는 원칙을 가져왔다. 처음에는 결과를 단일 Markdown에 기본 저장했고, P-0020에서는 맥락 이동·재조사 비용·검증 한계를 보존할 때만 note를 만들도록 줄였다. P-0024에서 외부 evidence는 코드 상태와 달리 사후 복원이 불가능할 수 있음을 구분해, 결정형 synthesis와 참조 원문 목록은 기본 보존하고 원본 evidence는 휘발성·비용·정확성·복수 해석 가능성에 따라 cold archive에 보존하도록 보강했다.
- **to-prd의 태도와 골격** — "사용자를 인터뷰하지 말고 이미 나온 합의를 종합만 하라"는 태도, 그리고 문제/해결/범위 밖 3분할 구조를 workstream 문서의 합의부(Goal/Current Scope/Behavior Notes/Out of Scope) 형식으로 변형해 가져왔다. 원문의 이슈 트래커 게시 스텝은 처음엔 뺐다("무인 병렬 구현 전까지 트래커 불채택"이라는 2026-07-07 결정 때문) — 그러다 2026-07-10에 ai-tab 레포 적용 리뷰를 계기로 이 결정을 뒤집었고, 이슈 트래커를 쓰는 레포에서는 "나중에" 출구가 이슈 승격이 되도록 다시 들여왔다(프로토콜 변경 이력 P-0003).
- **to-issues의 수직 슬라이스 개념** — 이슈로 쪼개는 방식 자체는 안 가져오고, "각 조각이 통합 레이어를 관통하는 독립 완결 단위"라는 수직 슬라이스 개념만 workstream의 Current Scope 항목 형식으로 가져왔다.
- **setup-matt-pocock-skills의 대화 골격** — 탐색 → 발견 제시 → 섹션별 질문(추천 답 선행, 이미 결정된 섹션은 스킵) → 초안 확인 → 쓰기, 이 5단계 흐름을 `setup-workflow`의 본문 ①~④ 구조로 그대로 가져왔다. "CLAUDE.md가 있으면 그것을 편집하고 반대쪽(AGENTS.md)을 임의로 새로 만들지 않는다"는 안전장치도 함께 가져왔다. 레포별 설정을 `docs/agents/*.md`라는 별도 파일로 착지시키는 부분은 안 가져왔다 — 우리는 그 정보를 AGENTS.md 마커 블록 안에 직접 넣는 설계라, 별도 파일을 하나 더 만들 이유가 없었다.
- **lazy 생성 원칙** — 문서가 없다는 이유로 미리 만들지 않고 실제 필요가 생길 때 생성한다는 원칙을 가져왔다. 처음에는 PROJECT_STATE·BACKLOG를 예외로 즉시 생성했지만, P-0020에서 PROJECT_STATE를 폐기하고 BACKLOG도 트래커가 없으며 실제 후보가 있을 때만 만들도록 더 엄격하게 적용했다.
- **changelog를 산출물로 남기는 관행** — `upstream-scout`가 리뷰 결과를 다이제스트 파일로 남기는 착상의 참조점.
- **skill 명명 선례** — 스킬명을 정할 때(검토점 1) mattpocock이 굳이 `setup-matt-pocock-skills`처럼 긴 이름을 쓴 선례가, "setup" 단독은 전역 네임스페이스 충돌 위험이 있다는 판단의 근거 중 하나가 됐다.
- **ADR-0001의 hard/soft 의존성 구분** — 처음에는 이 구분을 근거로 kickoff·promote의 결정 ID와 align의 트래커 설정을 setup hard dependency로 삼았다. P-0021·P-0022에서 두 스킬과 전역 연번을 없애고 align이 현재 레포의 실제 원천을 읽도록 바꾸면서 hard dependency도 함께 제거했다. 구분 자체는 유용했지만, 설정을 요구하는 기능을 없애는 편이 더 깊은 단순화였다.
- **`scripts/link-skills.sh`(비공식 dev-script)의 안전장치** — mattpocock 자신의 유지보수용 스크립트에서 순환 symlink를 거부하는 가드를 참고했다. 우리 현재 배포 스크립트는 직접 도구 경로를 소유하지 않고 dotfiles snapshot을 만든 뒤 dotfiles 설치·검증에 위임한다. 과거 직접 링크 흔적만 안전하게 정리한다.
- **vercel-labs/skills(`npx skills`, skills.sh 레지스트리 엔진)의 갱신 메커니즘 비교** — mattpocock/skills 자체가 아니라 그걸 배포하는 별도 오픈소스 CLI다. `.skill-lock.json`에 설치 시점 GitHub tree SHA를 저장해뒀다가 `skills update` 실행 시 최신 해시와 비교하는데, **로컬에서 사용자가 그 스킬을 고쳤는지는 전혀 추적하지 않아 업데이트가 있으면 그냥 조용히 덮어쓴다.** 이 반면교사가, 우리 마커 블록·전역 라우팅 마커 양쪽에 `agent-workflow-protocol-hash`(사용자 직접 수정 감지용) 라인을 추가하는 결정의 직접 근거가 됐다 — spec-kit의 자기 콘텐츠 SHA-256 추적과 같은 목적.

**가져오지 않은 것 / 기각**

- **CONTEXT.md(domain-modeling)** — DDD Bounded Context에서 유래한 용어집 파일. 도입 자체를 보류했다. 명분상 문제가 아니라 실효성 문제였다: 이 워크플로우가 다루는 레포 대부분이 single-context(경계가 여러 개로 안 갈라짐)라 "Bounded Context별 CONTEXT.md"라는 구조 자체가 성립하지 않고, 파일명도 "용어집"이라는 실제 역할과 안 맞았다(원문 정의: "It is a glossary and nothing else"). 프로토콜의 `GLOSSARY.md`가 그 자리를 대신 채웠다.
- **plan 영속 보존(accretion)** — 2026-07-07 비교 분석에서 기각. 우리는 workstream 문서를 승격 후 삭제하는 휘발성 설계라, 모든 plan을 영구 보존하는 accretion 모델과 정면으로 반대 방향이다.

---

### obra/superpowers

병렬 처리보다 게이트·검증 쪽에서 많이 가져온 소스. 동시에 "유저 레벨 설치만으로 충분한가"라는 이 워크플로우의 핵심 전제를 테스트하는 반례 역할도 했다.

**가져온 것**

- **brainstorming의 접근안 벌리기** — "본격적으로 설계하기 전에 접근안 2~3개를 트레이드오프와 함께 제시하라"는 한 조각만 2026-07-08 세션에서 채택해 `align`①로 삼았다. 같은 스킬의 YAGNI 심문·설계문서 작성 등 나머지 절차는 가져오지 않았다 — 우리 grill 루프(②)가 그 역할을 이미 하고 있어 중복이었다.
- **Spec Review(adversarial)** — "완성된 plan을 대화 맥락이 없는 다른 subagent에게 감사시킨다"는 개념을 `cold-read`의 베이스로 가져왔다. 단, superpowers는 감사 결과로 plan을 subagent가 직접 고치게 하지만, 우리는 질문 목록만 받아서 맥락을 가진 align 세션이 처리를 판단하게 했다 — 문서를 고치는 손과 맥락을 아는 손을 분리하는 쪽이 더 안전하다고 봤다.
- **컨텍스트 격리를 검증 도구로 쓰는 발상** — superpowers는 "세션 히스토리를 상속하지 않는다"를 오염 방지 특성으로만 취급하지만, `cold-read`는 그 격리 자체를 검증 메커니즘의 핵심으로 삼았다(대화에 참여한 사람은 초안의 구멍이 안 보이기 때문에, 안 보인 적 없는 fresh 에이전트를 일부러 쓴다).
- **verification-before-completion의 "주장보다 증거"** — 처음에는 `promote` 입구 게이트에 배치했지만, P-0021에서 별도 완료 의식을 없애며 Act의 상시 완료 조건으로 옮겼다. 검증은 유지하고 전이 절차만 제거한 것이다.
- **작업 규모에 따른 ceremony 축소** — v6.3.0이 작은 작업에서 두 문서 절차를 생략하고 controller가 비치명적인 모호함을 근거와 함께 처리하도록 바꾼 흐름을 참고했다. 새 크기 분류표를 만들지는 않고, 맥락 이동이 없으면 작업 계약을 만들지 않는 단일 조건으로 단순화했다. [v6.3.0](https://github.com/obra/superpowers/releases/tag/v6.3.0)
- **에스컬레이션 패턴** — 반복 수정에도 같은 문제가 남으면 문구가 아니라 합의나 아키텍처 문제로 보라는 원칙을 가져왔다. 처음에는 cold-read 2회 상한으로 구현했지만 현재는 횟수를 고정하지 않는다. 사용자 합의가 필요한 질문은 즉시 Align으로, 실제 시스템만 답할 질문은 unknown·fallback·관찰 계획으로 넘긴다.

**가져오지 않은 것 / 기각**

- **SessionStart 훅으로 스킬을 주입하는 방식** — 이건 채택 여부를 검토한 게 아니라, 이 워크플로우 전체의 존재 이유를 되짚게 한 반례였다. superpowers는 전부 유저 레벨 플러그인이고 레포에는 산출물만 남긴다. 그런데 그러면 플러그인이 없는 협업자나 미래 세션에는 워크플로우의 흔적이 전혀 전달되지 않는다 — 이게 바로 `setup-workflow`가 "레포 각인"(AGENTS.md 마커 블록)을 반드시 만들어야 하는 이유의 근거가 됐다(2026-07-12 이식 서베이: "레포 각인 없이 유저 레벨 설치만으로 충분하다는 증거를 찾으려 했으나, 오히려 반례로 확인됨").
- **공통 preamble·질문 학습 자동화** — 2026-07-07 비교 분석에서 기각. 세 소스(mattpocock/superpowers/gstack)를 비교하며 함께 검토했지만, 우리 규모에서는 과한 장치로 판단했다.

---

### garrytan/gstack

로컬 클론으로만 확인하는 소스 — fetch는 하되 merge/pull은 하지 않는다(추적 표 정책). User Sovereignty(사용자 주권) 철학이 우리와 잘 맞아 여러 조각을 가져왔다.

**가져온 것**

- **User Challenge 규격** — "사용자의 원래 방향이 기본값이고, agent가 방향 전환을 제안하려면 '놓쳤을 수 있는 맥락'과 '틀렸을 때의 비용'을 명시해서 입증해야 한다"는 규격을 거의 그대로 가져와 align의 전제 도전과 upstream-scout의 검토 세션 양쪽에 적용했다(같은 규격을 "사용자의 방향" 대신 "기존 프로토콜"에 대상만 바꿔 재사용). 같은 스킬의 decision brief 서식(ELI10 설명, Completeness 점수 등 정량화 장치)은 과한 기계장치로 판단해 가져오지 않았다.
- **learn(관찰→학습 승격 루프)** — 처음에는 `docs/LEARNINGS.md` 버퍼에서 반복 규칙을 AGENTS로 승격하는 형태로 가져왔다. P-0020에서 기본 버퍼를 없애고, 운영 마찰은 이 레포의 friction log처럼 명확한 수신처가 있을 때만 capture하며 반복이 확인된 상시 규칙만 AGENTS에 남기도록 더 좁혔다.
- **ship의 백로그 대조** — "완료 항목을 TODOS와 diff 대조해 자동으로 정리한다"는 개념은 참조했지만, 자동 이동이 아니라 "제안만 하고 실제 삭제는 사용자가 결정"하는 쪽으로 약화시켰다 — User Sovereignty(사용자가 최종 결정)와 우리 쪽의 "강제 대신 가이드" 선호가 둘 다 같은 방향을 가리켜서, 이 지점에서는 원문보다 약하게 가져오는 게 오히려 두 철학 모두에 더 충실했다.

**가져오지 않은 것 / 기각**

- **plan-review 체인(ceo/design/eng/devex 4연속 리뷰)** — 팀 단위 다중 관점 리뷰 체인인데, 1인 워크플로우를 전제로 하는 이 프로토콜에는 과했다. `cold-read` 하나로 축약했다.
- **VERSION 파일 + 버전별 idempotent 마이그레이션** — "마커에 버전을 박고 재실행 시 비교"라는 아이디어 자체는 채택 후보에 들었지만(spec-kit의 매니페스트 version 필드와 함께), 최종 채택안은 release 버전이 아니라 프로토콜 변경 이력의 전역 연번 `P-NNNN`이다. release 버전·semver는 "리뷰 세션 단위 일괄 개정"이라는 우리 갱신 단위와 의미론이 안 맞고 판정 비용만 얹는다고 판단했다.

---

### aihero.dev

Matt Pocock 스킬의 공식 설명과 변경 의도를 확인하는 1차 저자 채널로 쓴다. 2026-09 리뷰에서 v1.2의 round-based grilling, wayfinder를 한 세션에 담기 어려운 문제로 제한한 점, handoff를 실제 맥락 이동에만 쓰는 점을 확인했다. 질문 묶음과 조건부 작업 계약은 채택했고, 별도 결정 티켓 체계와 모든 결정 가지 소진은 우리 규모에 과해 가져오지 않았다. 설명이 전달되지 않았을 때 배경과 익숙한 용어로 다시 설명하는 `wait-what`은 문서 감량과 설명 감량이 다르다는 근거로 참고했다.

---

### Geoffrey Litt

2026-07-02 글 ["Understanding is the new bottleneck"](https://www.geoffreylitt.com/2026/07/02/understanding-is-the-new-bottleneck.html)을 2026-07-20 리뷰에서 검토했다. agent가 작성하는 코드가 늘수록 사람의 병목은 검증만이 아니라, 시스템을 이해해 다음 변화를 제안하는 참여 능력이라는 문제의식이 핵심이다.

**가져온 것**

- **이해의 목적 재정의** — P-0012에서는 문서화의 목적에 retrieval과 participation을 동등하게 뒀다. P-0020에서 participation이라는 목적은 유지하되 저장 책임은 분리했다. 코드·live source·보존된 의도를 조합한 설명은 agent와 도구가 판단 시점에 생성하고, 영속 문서는 복원 불가능한 공유 진실만 맡는다.
- **교육적 이해 도구** — 배경·직관을 먼저 제시하고, 필요할 때 코드 설명·확인 질문·조작 가능한 작은 예시로 내려가는 흐름을 Change Brief·이해 확인·micro-world로 흡수했다. 질문은 사용자 평가가 아니라 agent 설명의 빈틈을 찾는 장치로 변형했다.
- **소비성 설명물** — explainer와 micro-world는 대개 읽거나 써서 멘탈 모델을 만들면 임무가 끝나는 도구다. P-0020에서는 reorientation과 Change Brief도 같은 범주로 명확히 두고, AI 없이 반복 사용해야 하는 설명만 장기 보존하도록 좁혔다.

**가져오지 않은 것 / 보류**

- **전용 explain 스킬** — 코드 설명의 서사 순서와 확인 질문을 자동화하는 스킬은 후보지만, 실제로 어떤 요청·산출물·수명 규칙이 반복되는지 관찰하기 전에는 새 스킬을 만들지 않는다. P-0012의 `explain` 횡단 규칙으로 먼저 운영한다.
- **shared space** — 팀 단위 공유 이해 도구는 현재 1인-다중 agent 중심의 프로토콜에서 실사용 마찰이 아직 관찰되지 않아 도입하지 않는다. 협업 규모에서 같은 문제가 반복되면 friction log에 capture한다.

---

### Anthropic Engineering

장기 실행 agent harness가 모델 능력 변화에 따라 어떻게 단순화됐는지를 비교하는 근거로 사용했다.

**가져온 것**

- 2025년 실험의 세션 간 진행 기록과 실제 앱을 사용하는 평가에서, 맥락 이동 시 열린 의도와 검증 증거가 필요하다는 결론을 확인했다. [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- 2026년 후속 실험이 강제 context reset·고정 sprint 구조를 제거하고 평가 빈도를 낮춘 사례에서, 과거 모델의 한계를 보충하던 절차는 영구 불변식이 아니라 제거 실험 대상이라는 원칙을 강화했다. 실제 산출물 기반 독립 평가는 유지했다. [Harness design for long-running application work](https://www.anthropic.com/engineering/harness-design-long-running-apps)

**가져오지 않은 것 / 경계**

- 특정 benchmark harness의 구조를 일반 개발 프로토콜로 복제하지 않았다. 목표·경계·증거는 유지하되 세션·sprint·평가 횟수를 고정하지 않는다.

---

### Anthropic·OpenAI prompting guidance

2026-07-24 공식 문서 비교에서 최신 모델은 이전 모델용 세부 절차를 그대로 유지할 때 품질이 떨어질 수 있고, 목표·이유·hard constraint·승인 경계·성공 조건을 명시한 뒤 구현 절차는 모델에 맡기는 방향으로 두 회사의 지침이 수렴한다고 판단했다. 이 결론을 `skills/README.md`의 저작 규율로 채택했다. reasoning depth는 프롬프트 문구가 아니라 runtime 설정으로 취급한다. [Anthropic prompt engineering](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview), [OpenAI reasoning best practices](https://developers.openai.com/api/docs/guides/reasoning-best-practices)

당시 모델별 이름·가격·effort 권장표는 빠르게 낡지만, 그 결론을 만든 공식 문서의 정확한 표현은 이후 워크플로우 단순화를 재평가할 evidence다. P-0024에 따라 조사 synthesis와 참조 원문 목록을 장기 보존하고, 당시 snapshot은 기본 읽기 경로 밖의 evidence archive로 재분류한다. 다음 모델 세대에서는 과거 snapshot을 현재 사실로 갱신하지 않고 새 원천을 별도 시점의 evidence로 더한다.

---

### Microsoft Research

CHI 2025의 지식노동자 319명 설문은 생성형 AI에 대한 높은 신뢰와 낮은 자기보고 비판적 사고 사이의 연관성을 보고했다. 자기보고 상관 연구이므로 AI가 인지 능력을 영구 저하시킨다는 인과 근거로 사용하지 않는다. 매 단계 승인 횟수보다 사람이 의미 있는 비교·반례·다음 방향을 제시할 수 있게 하는 Align과 Reorient가 중요하다는 보조 근거로만 사용했다. [논문 안내](https://www.microsoft.com/en-us/research/publication/the-impact-of-generative-ai-on-critical-thinking-self-reported-reductions-in-cognitive-effort-and-confidence-effects-from-a-survey-of-knowledge-workers/)

---

### github/spec-kit

2026-07-12 이식 메커니즘 서베이에서 `setup-workflow` 설계를 위해 처음 조사한 소스. "형식만 이식하고 내용은 레포가 소유한다"는 철학이 우리 마커 블록 설계의 핵심 근거가 됐다.

**가져온 것**

- **마커 블록 + 최소 주입** — `<!-- start/end -->` 마커 사이에만 관리 섹션을 두고, 규칙 본문 전체가 아니라 포인터·불변식 요약만 넣는 패턴. GSD의 렌더링 방식, Agent OS v1.3의 폐기 교훈과 함께 이 패턴을 세 번 확인한 뒤 확신을 굳혔다.
- **constitution 패턴** — `.specify/memory/constitution.md`는 템플릿(형식)만 이식하고 내용·semver 관리는 레포가 소유한다. 이게 "프로토콜 불변식을 레포 안에 어떻게 사본으로 둘 것인가"라는 질문에 대한 정답 형태로 읽혔다 — 복제 동기화 문제가 아니라 레포별 승인(ratify) 문제로 재정의하게 해줬다. 우리 AGENTS.md 마커 블록도 같은 철학이다: 프로토콜 전문을 복사하지 않고, 요약 + 레포별 설정만 담는다.
- **version 필드** — 매니페스트의 버전 필드가 "버전 스탬프 + 갱신 감지"라는 채택 후보의 근거 중 하나였다(gstack VERSION과 함께). 최종적으로는 release 버전이 아니라 `P-NNNN` 연번으로 구체화했다(gstack 항목 참고).

**가져오지 않은 것 / 기각**

- **recovered 개념** — "이미 존재해서 덮지 않은 파일을 매니페스트에 '관찰했을 뿐 생산하지 않음'으로 기록해두는" 장치. 아이디어 자체는 정교하지만, 이는 결국 "이 레포에 무엇을 심었는지"를 목록으로 관리하는 방식이고, 우리는 정반대 결론(이식 레포 목록 자체를 추적하지 않는다)을 냈다. 명단은 파생 가능한 정보의 수동 사본이라 스스로 낡는다는 게 이유였다 — recovered 매니페스트도 같은 문제를 겪을 것이라 판단해 들이지 않았다.
- **`init --here --force`로 업그레이드를 뭉뚱그리는 방식** — 이건 반면교사다. 공식 문서가 "업그레이드 전 constitution을 수동 백업하라"고 안내할 정도로, 강제 재초기화가 사용자 커스텀을 날리는 사고를 실제로 일으킨다. 그래서 우리는 "갱신 ≠ 강제 초기화"를 설계 불변식으로 못박고, 갱신 모드가 마커 안쪽만 재렌더링하도록 분리했다.

---

### buildermethods/agent-os

버전을 거듭하며(v1 → v1.3 → v2 → v3) 스스로 기능을 추가했다가 폐기한 이력이 있는 소스라서, "먼저 저지르고 나중에 후회한 것"을 미리 피하는 데 특히 유용했다.

**가져온 것**

- **CLAUDE.md 주입 제거 교훈** — v1.3에서 "규칙 본문을 지침 파일에 통주입하는 것"("over-reading instructions into context")을 공식적으로 폐기했다는 사실이, 우리가 마커 블록에 프로토콜 전문을 넣지 않고 요약·포인터만 넣기로 확신하게 된 가장 직접적인 근거였다(spec-kit constitution, GSD 렌더링과 함께 세 번째 확인).
- **생성기 하나 + 입력 역채움** — v1의 analyze-product(코드 분석 → 사용자 인터뷰 → 결과를 plan-product의 입력으로 재사용, 기 구현 기능을 roadmap에 "이미 완료된 Phase 0"으로 역기입하는) 패턴을, `setup-workflow`의 "신규/기존 레포를 별도 파이프라인으로 안 가르고, 기존 레포는 분석 결과로 같은 생성기의 질문에 미리 답을 채워 넣는다"는 설계로 가져왔다.
- **3층 소유권 분리의 아이디어** — instructions/commands(프레임워크 소유)·standards(사용자 소유)·product(산출물) 3층 분리는, 우리 마커 블록 설계의 "마커 안 = setup-workflow 소유, 마커 밖 = 레포 소유" 2층 분리로 단순화해 가져왔다. 3층까지는 우리 규모에 필요 없다고 판단했다.

**가져오지 않은 것 / 기각**

- **index.yml 카탈로그** — 스크립트가 구조를, 에이전트가 의미를 관리하는 문서 카탈로그는 기각했다. 처음에는 프로토콜의 작은 Document Index면 충분하다고 봤고, P-0020 이후에는 고정 카탈로그도 두지 않고 필요 시 파일과 live source를 탐색한다.
- **sync-to-profile.sh(역방향 동기화)** — "대상 레포에서 다듬은 규칙을 유저 레벨로 회수한다"는 개념은 참고했지만 새로 구현하지 않았다 — 이미 있는 `protocol-friction-log.md`("마찰:" 캡처)가 사실상 같은 역할을 하고 있어서, 새 메커니즘을 만들 이유가 없었다.
- **v2의 1,000줄 bash 조건부 컴파일러({{IF}}/{{PHASE}})** — v3에서 통째로 폐기된 전례. "도구가 진화하면 직접 구현한 기능이 애물단지가 된다"는 반면교사로 삼아 setup의 자동화 범위를 감지와 마커 무결성처럼 결정적인 작은 스크립트로 제한했다. P-0021에서는 전역 결정 연번과 함께 선택적 lint 스크립트도 제거했다.
- **v3의 축소** — 모델과 도구가 직접 수행할 수 있게 된 spec 작성·task breakdown·구현 orchestration 구조를 걷어낸 이행을 재검토했다. 이를 개별 기능 모방이 아니라, 모델 결핍을 보충하던 kickoff·promote·수기 상태 전이를 제거 실험할 근거로 사용했다. [v3 migration](https://buildermethods.com/agent-os/migration)

---

### GSD — active lineage: open-gsd/gsd-core

처음 조사한 `gsd-build/get-shit-done`은 아카이브되었고, 현재 추적 대상은 `open-gsd/gsd-core`다. 아래의 마커 렌더링·갱신 모드·결정적 pre-flight 평가는 이 활성 계보와 2026-07-18 이식 서베이를 기준으로 유지한다.

마커 블록 렌더링·갱신 모드 설계에서 가장 구체적으로 참고한 소스다. `.planning/` 상태 저장소는 예전 `PROJECT_STATE` + workstreams 설계와 닮았지만, P-0020 이후에는 상태 저장 철학은 따르지 않고 결정적 감지와 마커 갱신 기법만 유지한다.

**가져온 것**

- **결정적 pre-flight** — `is_brownfield`/`needs_codebase_map`/`has_git` 같은 판정을 LLM의 감이 아니라 스크립트의 JSON 출력으로 내리는 방식을, `setup-workflow`의 `scripts/detect-repo-state.sh`(⓪ pre-flight)로 그대로 가져왔다. "분기는 이 출력으로 결정한다 — LLM의 감이 아니다"라는 문장이 이 스킬 본문에 직접 들어갔다.
- **마커 렌더링 + 갱신 모드** — CLAUDE.md의 마커 7섹션을 `.planning/` 문서에서 렌더링하되 재생성이 멱등이고 마커 밖 사용자 영역은 보존한다는 설계, 그리고 SessionStart 훅이 새 버전을 감지하면 changelog를 보여주고 확인받은 뒤에만 재설치하는 흐름을, 우리 갱신 모드(마커의 `P-NNNN` 스탬프와 프로토콜 변경 이력의 마지막 행을 비교 → 그 사이 변경분을 보여줌 → 승인 후 마커 안쪽만 재렌더링)로 가져왔다.
- **단일 소스 참조 설계의 반면교사** — 11,376줄에 달하는 install.js가 16개 런타임을 정규식 콘텐츠 치환으로 지원하는 것을 보고, "콘텐츠를 변환해서 복사하는" 방식이 아니라 "심볼릭 링크로 단일 소스를 참조하는" 우리 스킬 설치 방식(`scripts/link-skills.sh`)이 옳은 방향이라는 확신을 얻었다.

**가져오지 않은 것 / 기각**

- **map-codebase(ARCHITECTURE 역생성)** — 병렬 mapper가 `.planning/codebase/`에 STACK/ARCHITECTURE/CONVENTIONS 등 7개 문서를 역생성하는 기능. 무거운 작업이라 `setup-workflow`의 범위 밖으로 뒀다 — brownfield 레포에서 정말 필요하면 별도 세션으로 제안만 하는 선까지만 남겼다.

---

### bmad-method (BMAD-METHOD)

가장 많이 조사하고 가장 적게 가져온 소스. "이 정도 규모의 장치는 우리한테 과하다"는 판단 기준을 세우는 데 반면교사로 크게 기여했다.

**가져온 것**

- 브라운필드를 별도 분기가 아니라 워크플로우 레벨에서 대응한다는 태도, 기존 코드를 "비준(ratify)해야 할 대상"으로 보는 관점 정도만 참고했다 — 구체적 산출물(`bmad-generate-project-context`, `bmad-document-project`)은 GSD의 map-codebase와 같은 이유로 범위 밖에 뒀다.

**가져오지 않은 것 / 기각**

- **해시 매니페스트 기반 3분류 재설치** — 미변경 stock 파일은 덮어쓰고, 사용자 추가 파일은 보존하고, 사용자가 수정한 stock 파일은 새 버전 설치 + 기존본을 `.bak`으로 백업하는 정교한 3분류 시스템. "마커 경계 + '존재하는 파일은 불가침'만으로 충분한 규모"라고 판단해 완전히 기각했다 — 코드 유지비가 얻는 이득을 초과한다고 봤다.
- **config.toml(팀, 커밋) / config.user.toml(개인, gitignore) 2스코프 설정** — 팀·개인 설정을 분리하는 아이디어는 참고했지만 도입하지 않았다. 예전에는 마커 안의 작은 레포 설정으로 충분하다고 봤고, P-0022 이후 마커 자체도 실행 원칙과 라우팅만 가지므로 별도 설정 계층이 필요 없다.
- **모놀리식 대량 이식(스킬 수십 개 + `_bmad/` 트리, installer 1,745줄)** — 가장 강력한 반면교사. "setup이 이 규모를 흉내내면 유지보수가 본업(워크플로우 자체를 다듬는 일)을 잡아먹는다"는 판단 그대로 `setup-workflow`의 기각 기록에 남겼다.
