# Agent Workflow Protocol

이 문서는 AI agent와 함께 서비스를 개발해갈 때의 작업 워크플로우와 프로젝트 문서 운영 규칙을 정의한다. 기존 타 워크플로우 방식들이 문서를 너무 많이 생성하여 문서들조차 파악하기 어려운 문제, 특히 문서와 코드 간 불일치 문제를 줄이고자 하는 데서 시작했다.

## Principles

- Documentation은 동등한 두 목적을 갖는다. 첫째, 코드만으로는 알 수 없는 정보 중에서 본 프로젝트를 개발·유지하는 데 꼭 필요한 것을 기록해 재개 가능하게 한다. 둘째, 관리자인 사람이 시스템의 살아있는 멘탈 모델을 유지하여 agent의 산출물을 단순 승인하지 않고 다음 판단과 변화를 주도하게 한다.
- 따라서 코드 및 스키마는 특별한 사유가 없는 한 문서에 포함하지 않는다. 단 코드로 파악할 수 있더라도, 이를 위해 agent가 봐야 하는 코드의 범위나 드는 시간이 상당히 높거나, 사람이 의도·핵심 규칙·경계·트레이드오프를 빠르게 이해하고 다음 결정을 내리는 데 효용이 높은 정보는 문서화한다.
- 작업중 필요한 정보는 일시적으로 한 곳에 저장했다가 작업 완료 후에도 보존해야 할 정보만 적절한 기준 문서로 승격하고 나머지는 삭제한다. 이를 통해 작업중에는 별도의 handoff 과정 필요 없이 언제든 새로운 세션으로 시작할 수 있도록 돕고, 작업 후에는 코드를 source of truth로 하고 문서와의 괴리를 원천 차단한다.
- 문서가 담을 지식과 프로세스가 담당할 지식을 구분한다. 지식 4분면 중 문서는 "알고 있음을 아는 것" 가운데 장기 보존 가치가 있는 것만 담는다. 암묵지(알지만 당연해서 적지 않는 것)는 grill로 꺼내고, 인지된 무지는 리서치로 해소하고, 인지 못한 무지는 수직 슬라이스·해결책 공간 리서치·전제 도전으로 드러낸다. 문서 하나로 네 분면을 모두 커버하려는 시도가 spec 문서 부패의 근본 원인이다.
- git 추적 여부는 문서의 주제가 아니라 두 질문으로 정한다: ① 코드와 원자적으로 동기화되어야 하는가 (같은 커밋에 담는 것이 유일하게 강제력 있는 싱크 수단이다. 문서를 git 밖으로 빼는 것은 싱크 부담을 줄이는 게 아니라 싱크 깨짐을 안 보이게 만드는 것이다) ② 협업자(사람·agent)가 공유해야 할 진실인가. 하나라도 참이면 git 안에 둔다. 리서치 raw 정보도 기본은 git 안이다 — 리서치의 협업자는 미래의 나와 에이전트이고, git 밖 보관은 유실로 이어진다(§Research Documents).

**기준 문서와 이해 도구.** 기준 문서는 재개·유지·변경의 장기 기준으로 git 안에 남는다. 반면 Change Brief, explain-diff, micro-world 같은 이해 도구는 이번 변경의 멘탈 모델을 만드는 소비성 산출물이며, 대화·PR·일회성 데모로 충분하다. 이해 도구를 매번 파일로 축적하지 않는다. 시간이 지나도 사용·운영·확장 판단을 반복해서 돕는 내용만 `ARCHITECTURE.md`·`decision-logs/`·`features/` 등 기준 문서로 승격한다. 프로토타입과 마찬가지로 도구 자체의 착지점은 문서가 아니라 mark다.

## Sample Repo

```text
repo/
├── AGENTS.md
├── CLAUDE.md
├── docs/
│   ├── VISION.md
│   ├── GLOSSARY.md
│   ├── ARCHITECTURE.md
│   ├── PROJECT_STATE.md
│   ├── workstreams/
│   │   ├── payment-webhook-retry.md
│   │   └── auth-session-cleanup.md
│   ├── decision-logs/
│   │   ├── authentication.md
│   │   ├── payment-processing.md
│   │   └── agent-memory.md
│   ├── BACKLOG.md
│   ├── LEARNINGS.md
│   ├── features/
│   │   ├── payment-webhook-retry.md
│   │   └── team-permissions.md
│   ├── stripe-sandbox-quirks.md
│   └── _research/
│       ├── 2026-05-15-stripe-webhook-retry-strategies.md
│       └── 2026-05-19-agent-memory-systems-survey.md
├── src/
├── tests/
├── README.md
└── .gitignore
```

참고:

- 위 트리는 전체 lifecycle을 한 번에 보여주기 위한 예시다. 실제 운영에서는 `docs/workstreams/payment-webhook-retry.md`가 merge 후 승격되면 삭제되고, 필요할 때만 `docs/features/payment-webhook-retry.md`가 남는다.
- `docs/decision-logs/agent-memory.md`는 "repo 밖 memory를 기준으로 볼 것인가" 같은 장기 결정 주제의 예시다.
- `docs/stripe-sandbox-quirks.md`는 소문자 reference 문서의 예시다 — 소스 오브 트루스가 코드가 아닌 외부 시스템 실측(Document Index의 reference 행 참고).
- `CLAUDE.md`는 보통 아래처럼 `AGENTS.md`를 `@` import로 로드하는 얇은 포인터로 둔다:
  `@AGENTS.md`
  마크다운 링크(`[AGENTS.md](./AGENTS.md)`)는 세션 시작 시 컨텍스트에 자동 로드되지 않는다 — `@` import만 그렇다(Claude Code 공식 문서, Import additional files). Claude 전용 규칙이 꼭 필요하면 import 아래에 이어 쓴다: `@AGENTS.md` 다음 줄에 `## Claude Code` 같은 섹션을 추가하는 형태(Claude Code 공식 문서의 AGENTS.md 절 예시).

## AGENTS.md 가이드

AGENTS.md는 OpenAI Codex가 주도하고 Anthropic·Google 등이 채택해 현재 Agentic AI Foundation(Linux Foundation 산하)이 관리하는 공개 표준이다. Claude Code는 `AGENTS.md`를 직접 읽지 않고 `CLAUDE.md`의 `@AGENTS.md` import로 읽는다(위 참고 항목). 아래는 agents.md 표준, OpenAI Codex 공식 가이드, Claude Code 공식 문서(Write effective instructions)가 공통으로 제시하는 기준이다.

**원칙**

- 필수 필드는 없다 — 이 레포에 실제로 필요한 섹션만 채운다.
- 매 요청마다 항상 필요한 내용만 넣는다. `AGENTS.md`는 세션마다 전체가 로드되므로, 특정 파일·상황에서만 쓰는 조건부 규칙은 경로별 규칙(`.claude/rules/`의 `paths` frontmatter)이나 스킬로 뺀다 — "가끔 참고할 정보"가 아니라 "항상 참고해야 할 규칙"만 남긴다(Claude Code 공식 문서: rules는 매 세션 또는 매칭 파일 오픈 시 로드되고, 상시 필요 없는 작업별 지침은 스킬로 뺀다).
- 200줄 미만을 목표로 한다. 길어질수록 컨텍스트 소비가 늘고 준수율이 떨어진다 — 넘치면 경로별 규칙(`.claude/rules/`)이나 스킬로 쪼갠다.
- 검증 가능한 구체성으로 쓴다: "포맷을 잘 맞춰라"가 아니라 "2-space indentation을 쓴다", "커밋 전 테스트하라"가 아니라 "커밋 전 `npm test`를 실행한다".
- 처음부터 완성하지 않는다. agent가 같은 실수를 반복하는 지점을 관찰할 때마다 그 항목만 추가한다(OpenAI Codex 가이드의 명시적 권고) — 이 레포 §6 Promote의 승격 기준과 같은 사상이다.
- 모노레포에서는 하위 디렉터리별 `AGENTS.md`로 지역 규칙을 나눌 수 있다. 가장 가까운 파일이 우선한다.

**포함할 것 (예시)**

- 빌드·테스트·린트 실행 명령어 — agent가 그대로 실행 가능한 형태로 (`pnpm test`, `make lint`)
- 코드 스타일 규칙 (예: "TypeScript strict mode, single quotes, no semicolons")
- 커밋 메시지·PR 형식 규칙
- 의존성 추가·프로덕션 변경 시 승인/검토 프로세스
- 보안·자격증명 관련 주의사항
- agent가 이 레포에서 반복적으로 틀리는 패턴 (§6 Promote 예시와 동일 기준)

**넣지 말 것**

- 코드·스키마로 파악 가능한 정보 (§Principles와 동일 원칙)
- 현재 진행 상태, 브랜치별 임시 메모 (Document Index `AGENTS.md` 행 참고)
- 수정 불가능한 스펙 문서, 바이너리·코드 원문 그대로 붙여넣기
- 빈 섹션 — 일부 agent(Codex 등)는 빈 파일·섹션을 무시한다

## Document Index

행 순서는 Sample Repo 트리와 같고, 상단 8행(`AGENTS.md`~`decision-logs`)은 §5 Resume의 읽기 순서와 일치한다 — 포인터(`CLAUDE.md`)와 선택 문서(`GLOSSARY.md`)가 사이에 낀다. 그 아래는 필요할 때만 읽는 문서들이다.

| 문서                                    | 역할                                                                                                                  | 살아있는 기간                            | 넣지 말 것                                                          |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ---------------------------------- | --------------------------------------------------------------- |
| `AGENTS.md`                           | 작업 규칙의 기준이다. `CLAUDE.md`는 이 파일을 가리키는 포인터만 둔다.                                                                       | 장기                                 | 현재 진행 상태, 브랜치별 메모                                               |
| `CLAUDE.md`                           | `@AGENTS.md` import로 `AGENTS.md`를 자동 로드하는 호환용 포인터다(마크다운 링크는 자동 로드되지 않음). 추가 규칙은 두지 않는다.                              | 장기                                 | Claude 전용 별도 규칙, 현재 진행 상태                                       |
| `docs/VISION.md`                      | 서비스 목적, 타겟, 제품 방향을 담는다.                                                                                             | 장기                                 | sprint 계획, 구현 메모                                                |
| `docs/GLOSSARY.md` (선택)               | 도메인 용어집(ubiquitous language). 같은 개념에 어떤 단어를 쓰는지만 정의한다.                                                              | 장기                                 | 구현 스펙, 결정 rationale                                             |
| `docs/ARCHITECTURE.md`                | 현재 구조, 경계, 주요 흐름 같은 사실과 사람이 시스템을 이해하기 위한 핵심 모델을 담는다.                                                              | 장기                                 | 세션 로그, 긴 rationale                                              |
| `docs/PROJECT_STATE.md`               | active workstream의 인덱스와 우선순위를 보여준다.                                                                                 | 장기, 항목은 휘발성                        | branch별 상세 재개 메모                                                |
| `docs/workstreams/<slug>.md`          | 특정 작업의 합의(목표·멘탈 모델·핵심 trade-off)와 상세 상태를 담아 handoff 역할을 맡는다. 현재 작업의 `Next Step`도 여기에 둔다.                            | branch/worktree 수명 동안              | repo-wide 우선순위, 장기 구조 설명                                        |
| `docs/decision-logs/<topic>.md`       | 중요한 결정의 이유와 변경 이력을 담는다. rationale은 여기 둔다. 히스토리 항목은 레포 전역 연번 ID를 갖는다(§4 결정 ID 규약).                                   | 장기                                 | 사소한 임시 결정                                                       |
| `docs/BACKLOG.md`                     | 아직 시작하지 않은 작업 목록을 관리한다. 이슈 트래커를 쓰는 레포에서는 fog·장기 후보의 권위만 맡는다(표 아래 참고).                                               | 장기, 항목은 휘발성                        | 현재 진행 상태, 세션 메모                                                 |
| `docs/LEARNINGS.md`                   | 1회성 교훈의 중간 버퍼다. 반복 확인된 항목만 `AGENTS.md`로 승격하고 제거한다.                                                                  | 장기, 항목은 휘발성                        | 진행 상태, 결정 rationale                                             |
| `docs/features/<feature>.md`          | 완료 후에도 사람이 기능을 사용·운영·확장·제한할 판단을 하는 데 설명 가치가 있는 기능만 남긴다. 목적·관측 가능한 동작·핵심 모델·한계를 담는다.                         | 선택적 장기                             | 개발 중 진행 상태, 구현의 시간순 기록                                      |
| `docs/<reference>.md`                 | 소스 오브 트루스가 코드가 아닌 장기 사실만 담는 reference — 외부 시스템 실측(OS·서드파티 API 동작), 수동 절차(QA 매트릭스·운영 가이드) 등. 같은 소스를 다루는 문서는 하나로 합친다. | 장기                                 | 코드가 소스인 사실 (`ARCHITECTURE.md`나 코드 주석으로), 미래 설계 노트 (BACKLOG·이슈로) |
| `docs/_research/YYYY-MM-DD-<slug>.md` | 광범위한 외부 정보를 raw 형태로 보존하는 저장소. 비기준 문서라(`_` 접두가 그 표시) 다른 문서와 링크로 연결하지 않는다. 기본 git 추적, 예외는 §Research Documents.        | 장기, stale 무방 (업데이트 시 파일명·본문 일시 갱신) | 진행 중 작업 상태, 다른 문서에서 링크·참조되어야 하는 정보                              |

이슈 트래커(GitHub Issues 등)를 쓰는 레포에서는 백로그 권위를 둘로 가른다: **셰이핑이 끝나 수용 기준이 선 작업 = 이슈 트래커**, **아직 질문이 날카롭지 않은 fog·장기 후보 = `docs/BACKLOG.md`**. BACKLOG에는 열린 이슈의 한 줄 인덱스만 남겨도 된다. 항목이 Align을 통과하면 이슈로 승격하고 BACKLOG에서 제거한다.

**파일명 관례**: 대문자 = 레포당 하나뿐인 고정 역할 문서(전부 읽는 층), 소문자 = 주제·작업 단위로 늘어나는 문서(`workstreams/`, `decision-logs/`, `features/`, reference, `_research/` — 관련된 것만 골라 읽는 층)

**사람의 이해가 주 목적인 문서의 서술 기준.** `VISION.md`·`ARCHITECTURE.md`·`features/`는 사실을 나열하기보다 그 사실이 만드는 인과와 선택의 맥락을 먼저 쓴다. 배경 다음에 직관과 핵심 개념을 놓고, 세부 구현은 질문이 생겼을 때 내려갈 수 있는 층으로 둔다. 독자가 다음 판단을 할 수 있는 최소 멘탈 모델과, 보장하지 않는 경계를 함께 제공한다.

## Workflow

단계 어휘: **Capture → Align → Kickoff → Develop → Resume → Promote**. 횡단 규칙: **park**(가지 착지), **mark**(결정 기록), **explain**(사람의 멘탈 모델 정렬). 이 어휘를 문서·스킬·대화에서 동일하게 쓴다.

### 1. Capture — 아이디어 및 방향 수립

- 새 아이디어가 제품 방향 자체를 바꾸면 `docs/VISION.md`를 수정한다.
- 아직 시작하지 않을 작업이면 `docs/BACKLOG.md`에 넣는다.
- 외부 정보 조사는 `docs/_research/`에 raw 형태로 모은다. 어느 단계에서든 자유롭게 추가·갱신한다.

### 2. Align — 작업 셰이핑

BACKLOG의 항목을 실제 작업으로 전환하기 전, grill 세션으로 사용자의 의도·멘탈 모델과 agent의 이해를 동기화하고 작업을 착수 가능한 형태로 다듬는다. agent가 내부적으로 이해했다고 해서 Align이 끝난 것이 아니다. 사용자가 이 작업의 변화·선택·경계를 이해해 다음 판단에 참여할 수 있을 때까지 네 수(手)로 진행한다.

**① 접근안 벌리기.** 설계 트리를 내려가기 전에 접근안 2~3개를 트레이드오프와 함께 제시하고 방향을 고른다. 방향이 자명하면 건너뛴다.

**② grill 루프.** 공유된 이해에 도달할 때까지 설계 트리를 따라 내려가며 한 번에 하나씩 질문하고, 질문마다 추천 답을 함께 제시한다. 각 질문은 최적의 답 출처로 라우팅한다:

- 코드베이스로 답할 수 있으면 → 묻지 말고 탐색한다.
- 사용자의 선호·권한에 속하면 → 사용자에게 묻는다.
- 외부 세계의 사실이면 → 리서치로 핸드오프한다.
- 보거나 만져야 답할 수 있으면(고충실도) → 프로토타입으로 핸드오프한다.

**이해 정렬.** agent가 중요한 동작·핵심 규칙·선택의 trade-off를 이해했지만 사용자가 아직 같은 모델을 가졌는지 확신할 수 없으면, 먼저 배경과 직관을 평이한 언어로 설명한 뒤 대표 시나리오나 한 가지 질문으로 빈틈을 드러낸다. 질문은 사용자를 시험하는 장치가 아니라 설명의 실패를 찾는 장치다. 사용자는 답을 암기해 되풀이할 필요 없이, 설명을 수정·보완하거나 선택·우려를 제기할 수 있으면 된다. 규모가 작거나 변화가 자명하면 이 확인은 건너뛴다.

프로토타입 핸드오프의 산출물은 일회성 코드다. 착지 지점은 문서가 아니라 mark다 — 발견이 결정을 좌우하면 workstream 합의부나 `docs/decision-logs/`에 반영하고, 코드 자체는 폐기하거나 branch로 남긴다.

**리서치 핸드오프.** 다음 중 하나라도 참이면 grill을 멈추고 리서치를 발주한다:

- 되돌리기 비싼 결정이 검증되지 않은 사실 위에 서 있다.
- 결정이 외부 시스템의 실제 동작(서드파티 API, 표준, 생태계 관례)에 의존한다.
- 도메인이 빠르게 움직이거나 모델 컷오프 이후 정보가 필요하다.
- 사실 주장에 대해 사용자와 agent의 의견이 다르거나 둘 다 확신이 없다.

핸드오프 시 리서치 브리프 3줄을 함께 넘긴다: ① 질문 ② 이 리서치가 좌우하는 결정 ③ 무엇이 발견되면 마음을 바꿀 것인가. 리서치는 background agent가 1차 소스(공식 문서, 소스코드, 스펙) 기준으로 수행하고, 출처를 단 산출물을 `docs/_research/`에 남긴다. align 세션은 정제된 산출물만 읽는다 — raw 웹 콘텐츠로 align 컨텍스트를 오염시키지 않는다.

**전제 도전.** 리서치 복귀 후 첫 수는 "어떻게"가 아니라 "여전히 하는가"다. 다음 세 질문을 정확히 1라운드 돌린다:

1. 이 문제를 아예 안 푸는 방식으로 우회하는 곳이 있는가.
2. 우리 접근이 업계 대비 이례적인가. 이례적이라면 우리에게 그럴 이유가 있는가.
3. 남들이 시도했다 버린 흔적이 있는가. 왜 버렸는가.

1라운드로 제한하는 이유: 전제 도전이 무한 재심이 되면 과그릴링이다. 사용자가 전제를 의식적으로 재확인하거나 수정하면 다음으로 넘어간다. 여기서 나온 결정은 `docs/decision-logs/`의 1순위 후보다.

전제 도전은 agent가 사용자의 명시적 방향을 뒤집자고 제안하는 순간이므로 규격을 따른다: **사용자의 원래 방향이 기본값**이고, agent는 "우리가 놓쳤을 수 있는 맥락"과 "우리가 틀렸을 때의 비용"을 명시해 변경을 입증해야 한다. 복수의 모델이 합의해도 그것은 신호일 뿐 명령이 아니다 — 자동으로 결정하지 않는다.

**③ 초안 작성.** 합의가 수렴하면 workstream 문서의 합의부(Goal / Mental Model / Key Trade-off / Current Scope / Behavior Notes / Out of Scope) 초안으로 종합한다. 별도 PRD 문서는 만들지 않는다 — 이 초안이 그 역할이다. Mental Model은 이 변경 뒤 사람이 이해해야 할 핵심 규칙·흐름·경계이고, Key Trade-off는 검토한 선택지와 채택 기준이다. Current Scope는 각각 독립적으로 완결 가능한 **수직 슬라이스**로 쪼갠다. 모든 통합 레이어를 관통하는 얇은 조각이 미지의 미지를 가장 빨리 드러낸다. ADR급 결정은 `docs/decision-logs/<topic>.md` 초안으로 함께 뽑는다.

**④ 검토 게이트.** 사용자가 초안을 승인한다. 규모 있는 작업이면 두 확인을 추가한다. **cold-read audit**은 대화에 참여하지 않은 fresh agent가 초안만 읽고 "이것만으로는 답할 수 없는 질문" 목록을 낸다. **이해 확인**은 agent가 배경 → 직관 → 선택 순으로 설명하고, 사용자가 대표 시나리오·선택·우려 중 하나로 응답해 자신의 모델을 수정할 기회를 갖는다. 첫째는 fresh한 구현 에이전트가 질문 없이 시작할 수 있는가, 둘째는 프로젝트 책임자가 이 변경의 다음 판단에 참여할 수 있는가를 묻는다. align 참여자들은 대화 컨텍스트를 공유해 초안의 구멍이 보이지 않고, 미래의 구현 세션과 사용자는 fresh할 수 있기 때문에 둘 다 필요할 수 있다.

**출구.** align의 출구는 세 갈래다. 어느 쪽이든 align에서 내린 결정은 코드가 되거나 문서가 되어야 하며, 컨텍스트와 함께 버려져서는 안 된다.

- 지금 시작한다 → Kickoff로. 초안이 `docs/workstreams/<slug>.md`가 된다.
- 나중에 시작한다 → 이슈 트래커를 쓰는 레포면 초안(수용 기준 포함)을 이슈로 승격하고 BACKLOG에서 제거한다. 이슈 트래커가 없으면 초안의 핵심을 `docs/BACKLOG.md` 항목에 압축 병합한다.
- 하지 않는다 → 폐기한다. 죽인 이유가 남길 가치가 있으면 `docs/decision-logs/`에 기록한다.

align이 항상 Kickoff로 이어진다면 전제 도전은 연극이다. 작업을 죽일 수 있어야 게이트다.

피해야 할 것:

- 모든 작업에 리서치를 의무화하기 — 리서치 연극이 되어 아무도 다시 읽지 않을 제네릭 서베이만 쌓인다
- 리서치 결과를 지지적으로만 통합하고 전제 도전을 건너뛰기
- 셰이핑 결정을 문서화하지 않은 채 구현 세션으로 넘어가기
- 작은 작업에 네 수를 전부 강제하기 — ①은 방향이 자명하면, cold-read는 규모가 작으면 건너뛴다

### 3. Kickoff — 작업 시작

작업을 실제로 시작하면 같은 커밋에서 아래를 같이 갱신한다.

- `docs/BACKLOG.md`
- `docs/PROJECT_STATE.md`
- `docs/workstreams/<slug>.md`

규칙:

- `BACKLOG.md`에서는 시작한 항목을 제거한다.
- `PROJECT_STATE.md`에는 이름, 상태, owner, 상세 링크만 넣는다.
- `docs/workstreams/<slug>.md`에는 align의 초안(Goal / Mental Model / Key Trade-off / Current Scope / Behavior Notes / Out of Scope)을 합의부로 착지시키고, 상태부에 재개 정보를 적는다.
- 이 시작 전이 커밋은 main에서 만든 뒤 branch/worktree를 딴다. 이후 branch에서는 `docs/workstreams/<slug>.md`만 갱신한다.

피해야 할 것:

- 별도 `TODO.md`를 만들어 역할을 겹치게 만들기
- `CLAUDE.md`와 `AGENTS.md`를 둘 다 따로 유지하기

### 4. Develop — 개발 중

개발 중 변경되는 상세 정보는 `docs/workstreams/<slug>.md`의 상태부에만 두고 수시로 변경한다.

작업 중 새 가지가 뻗으면 — 추가 아이디어, 발견한 버그, "이것도 다시 봐야 할 것 같은" 항목 — 쫓아가지도, 머리에 담아두지도 말고 한 줄로 착지시킨 뒤 현재 작업으로 복귀한다 (park, don't chase):

- 현재 scope 안이면 → workstream 문서의 `Next Step`
- scope 밖이면 → `docs/BACKLOG.md`

착지 지점이 항상 이 두 곳뿐이라는 확신이 열린 루프를 닫는다. 발산 자체는 결함이 아니라 미지의 미지가 드러나는 순간이다. 문제는 발산이 아니라 포획 없는 발산이다.

결정이 굳으면 그 자리에서 기록한다 (mark):

- 의미 있는 기술 결정이 생기면 현재 구조 요약은 `docs/ARCHITECTURE.md`에, 결정 이유와 변경 이력은 `docs/decision-logs/<topic>.md`에 둔다.
- 기록 기준: 나중에 다시 물어볼 만한가 / 다른 기능에 영향을 주는가 / 뒤집는 비용이 큰가 — 두 개 이상이면 기록한다.
- workstream 문서의 합의부(Goal / Mental Model / Key Trade-off / Current Scope / Behavior Notes / Out of Scope)를 바꾸는 것도 결정이다. 조용히 고치지 말고 mark를 거친다.
- mark는 Develop 전용이 아니라 Align의 전제 도전 산출물에도 적용되는 횡단 규칙이다.

park와 mark는 한 쌍이다: 가지가 뻗으면 park, 결정이 굳으면 mark.

**explain.** 의미 있는 수직 슬라이스가 끝나거나, 사람의 다음 판단에 영향을 줄 결정·동작 변화가 생기면 agent는 코드 투어 대신 Change Brief로 사용자의 멘탈 모델을 갱신한다. 기본 순서는 결과 → 고려와 선택 → 이제의 모델 → 경계 → 검증이다. Change Brief는 대화·PR·일회성 데모로 전달하는 소비성 이해 도구이며, 코드 파일명·diff는 요청될 때만 다음 층으로 내린다. 정적 설명으로 부족하면 before/after 시나리오, 흐름 시각화, micro-world 같은 도구를 Develop에서도 발주할 수 있다. 도구가 드러낸 장기 규칙·결정만 mark로 기준 문서에 승격한다.

**결정 ID 규약.** mark로 `docs/decision-logs/`에 기록할 때:

- 결정마다 레포 전역 연번 ID를 부여하고 히스토리 항목 제목에 박는다: `### D-0012 — <제목> (YYYY-MM-DD)`. 네임스페이스는 레포당 하나다 — 신규 레포는 `D-0001`부터, 구 ADR 체계에서 전환한 레포는 `ADR-` 연번을 그대로 이어간다. 항목을 추가하면 같은 파일의 `Current Decision`을 함께 갱신한다.
- 결정 실질은 `Current Decision`에만 둔다. 히스토리 항목에는 그 시점의 배경(Why)과 supersede 사실만 적는다 — 같은 실질을 두 곳에 쓰면 다음 갱신 때 한쪽이 낡는다.
- 코드 주석·이슈·다른 문서는 결정을 파일 경로가 아니라 ID로 인용한다. ID → 파일 해소는 grep이 맡는다.
- 주제 파일은 ID들의 뷰다. 분류가 어색해지면 히스토리 항목을 ID째 다른 파일로 옮긴다 — ID 인용은 깨지지 않는다. 한 결정이 두 주제에 걸치면 본문은 한 곳에만 두고 다른 파일에서는 ID로 링크한다.
- 주제는 기능이 아니라 도메인 축(모듈·관심사) 단위로 자른다. 기능 단위 주제는 다른 주제에 흡수되며 소멸해 재편 비용을 만든다.
- 포맷은 md를 유지한다. 제목 규약 자체가 기계 검증 가능한 구조이며, 보장이 필요하면 중복 ID·형식·인용 해소 lint로 보강한다. JSONL 같은 구조화 포맷은 소비자(사람·LLM)와 실제 질의(grep, 파일 상단 읽기)에 이득이 없다.

작업 중 얻은 교훈 — agent가 반복할 만한 실수 패턴, 이 repo 특유의 함정 — 은 workstream 문서의 `Learnings`에 한 줄로 적는다. Promote 때 `docs/LEARNINGS.md`로 옮겨진다.

`docs/PROJECT_STATE.md`에는 이 작업이 active라는 사실(이름·상태·owner·상세 링크)만 남긴다.

피해야 할 것:

- backlog를 현재 상태판처럼 쓰기
- 개발 중 상세 상태를 `PROJECT_STATE.md`와 `docs/workstreams/*.md`에 동시에 적기
- 작업 중 발견한 가지를 즉시 쫓아가 scope를 넓히기
- `ARCHITECTURE.md`에 rationale을 길게 적어 `decision-logs`와 중복 만들기

### 5. Resume — 일시 중단 후 재개

재개 시 읽는 순서는 아래를 기본으로 한다.

1. `AGENTS.md`
2. `docs/VISION.md`
3. `docs/GLOSSARY.md` (있으면)
4. `docs/ARCHITECTURE.md`
5. `docs/PROJECT_STATE.md`
6. 관련 `docs/workstreams/<slug>.md`
7. 관련 `docs/decision-logs/*.md`의 `Current Decision` 섹션 — **필수**. 조용한 재론을 막는 것이 decision log의 존재 이유다. `Decision History`는 배경이 필요할 때만 읽는다.

별도의 handoff 파일은 두지 않는다. 그 역할은 `docs/workstreams/<slug>.md`가 맡는다.
아직 시작하지 않은 신규 후보를 다시 검토하는 경우에만 `docs/BACKLOG.md`를 추가로 읽는다.

읽기를 마친 agent는 사용자에게도 짧은 **reorientation**을 제공한다: 현재 멘탈 모델, 직전의 확정 선택, 남은 판단, 다음 행동이 그 판단에 미치는 영향을 말한다. 이를 별도 파일로 남기지 않는다. 기준 문서를 읽고도 재정향을 만들 수 없다면, 이전 Promote에서 장기 맥락을 제대로 승격하지 못했다는 신호다.

### 6. Promote — 작업 완료

전제: workstream 문서의 `Verification`이 실제 증거(테스트 결과, 실행 확인)로 채워져 있어야 완료를 선언할 수 있다. 주장보다 증거다. 이해 확인은 Verification에 섞지 않는다 — 테스트·실행의 객관적 증거와 사람의 멘탈 모델은 다른 게이트다.

작업이 끝나면 아래 순서로 정리한다. 이 정리는 merge 후 main에서 수행한다 — `PROJECT_STATE.md`·`BACKLOG.md`가 main 전용이기 때문이다(§Parallel Workstreams).

1. 사람의 다음 판단에 영향을 줄 규모 있는 변경이면 최종 Change Brief로 이해 확인을 한다. Change Brief는 결과 → 고려와 선택 → 이제의 모델 → 경계 → 검증을 빠짐없이 다루고, 각 항목에서는 배경과 직관을 구현 세부보다 먼저 설명한다. 사용자는 승인·수정·추가 질문 중 하나로 응답한다. 대표 시나리오나 질문은 필요할 때만 쓰며 사용자를 시험하지 않는다. 이 과정에서 드러난 장기 모델만 다음 단계에서 승격한다.
2. `docs/PROJECT_STATE.md`에서 active 상태를 제거한다. 완료 이력은 merge 커밋이 이미 기록하므로 별도 목록을 두지 않는다. 이슈 트래커에서 온 작업이면 이슈를 닫는다.
3. 현재 구조가 바뀌었으면 `docs/ARCHITECTURE.md`를 갱신한다.
4. 장기 가치가 있는 결정이면 `docs/decision-logs/*.md`를 갱신한다.
5. 설명서 가치가 있는 기능이면 `docs/features/<feature>.md`를 생성하거나 갱신한다. 판정 기준은 이 기능을 앞으로 사용·운영·확장·제한할 사람이 목적·관측 가능한 동작·핵심 모델·한계를 다시 알아야 하는가다.
6. repo 전체 작업 규칙이 새로 드러났다면 `AGENTS.md`를 갱신한다.
7. workstream 문서의 `Learnings`를 `docs/LEARNINGS.md`로 옮긴다. `LEARNINGS.md`에서 같은 교훈이 반복 확인되면 `AGENTS.md`로 승격하고 항목을 제거한다.
8. 승격이 끝나면 `docs/workstreams/<slug>.md`는 삭제한다.

즉, 진행 중 메모는 임시이고, 승격된 정보만 영속 문서로 남긴다.

피해야 할 것:

- 개발 중 진행 상태를 `docs/features/*.md`에 적기
- merge 후에도 `docs/workstreams/*.md`를 계속 쌓아두기

`AGENTS.md` 승격 예시:

- 항상 먼저 확인해야 하는 코드 진입점이 생겼다.
- 특정 테스트를 돌리기 위한 필수 명령이나 순서가 반복적으로 필요하다.
- agent가 이 repo에서 반복적으로 실수하는 패턴이 확인됐다.
- 작업 전에 반드시 읽어야 하는 문서나 폴더가 새로 생겼다.

`AGENTS.md`에 넣지 말 것:

- 특정 branch에서만 유효한 임시 메모
- 한 기능의 현재 진행 상태
- 일회성 디버깅 로그
- 장기 규칙이 아닌 구현 상세

## Parallel Workstreams

여러 작업을 동시에 굴리는 것 자체는 문제가 아니다. 동시 개수의 상한은 사람마다 다르므로 강제하지 않는다. 대신 병렬 운용이 무너지지 않게 하는 flow를 둔다.

- workstream 하나당 worktree 하나를 쓴다. `docs/workstreams/<slug>.md`는 해당 branch에서만 수정한다.
- `docs/PROJECT_STATE.md`와 `docs/BACKLOG.md`는 main에서만 갱신한다. 갱신 시점은 작업의 시작·종료·상태 전이 시점이다. 이렇게 하면 병렬 branch 간 merge 충돌이 원천 차단된다.
- 작업 A 중 발견한 작업 B 관련 가지는 B의 workstream 문서가 아니라 `docs/BACKLOG.md`(main)에 착지시킨다. A의 세션은 B의 branch 파일을 건드리지 않는다.
- align 세션은 병렬로 돌리기 좋다. 한 세션이 생각하는 동안 다른 세션의 질문에 답한다. 보통 2개가 편한 한계이고, 한쪽이 리서치 같은 장시간 작업이면 3개까지도 가능하다.
- 인지 부하가 다른 작업을 짝짓는다. 깊은 구현 1개 + 얕은 셰이핑·리서치 1개 조합이 깊은 구현 2개 조합보다 오래 버틴다.
- 상한 대신 좀비를 감지한다. `PROJECT_STATE.md`를 갱신할 때마다 오래 진전 없는 workstream을 확인하고, 살릴 계획이 없으면 닫아서 BACKLOG로 되돌린다. 열린 루프는 개수보다 방치가 문제다.

피해야 할 것:

- 병렬 branch 여러 곳에서 `PROJECT_STATE.md`·`BACKLOG.md`를 수정하기
- 진전 없는 workstream을 active 목록에 계속 방치하기

## Research Documents

외부 정보·기술 비교·시장 조사를 광범위하게 모아두는 개인 저장소다. 실제로 쓰이지 않을 정보도 포함하고 있으므로 기준 문서와 lifecycle도, git 추적 정책도 다르다.

### 생성 경로

- **align 중 핸드오프 (기본 경로):** align 세션이 리서치 브리프 3줄과 함께 background agent에 발주한다 (Workflow §2 참고). 산출물은 각 주장에 출처를 단 단일 Markdown 파일이다.
- **자유 리서치:** 어느 단계에서든 궁금한 주제를 자유롭게 조사해 쌓는다.

어느 경로든 raw 발견은 `_research/`에 남고, 결정에 필요한 내용만 전제 도전을 거쳐 기준 문서 본문으로 승격된다.

### 위치와 파일명

- 경로: `docs/_research/YYYY-MM-DD-<slug>.md`
- 날짜는 **마지막으로 본문을 갱신한 날**이다.
- 같은 주제를 다시 다듬을 때는 새 파일을 만들지 말고 기존 파일을 새 날짜로 rename하면서 본문의 `Update History`에 항목을 추가한다. 본문의 날짜 기록은 `Update History`가 유일하다 — 동기화 지점은 파일명과의 2중뿐이다.

### git 추적 정책

기본은 **git 추적**이다. 리서치의 협업자는 미래의 나와 에이전트다 — 새 머신·클라우드 세션이 clone만으로 기존 조사를 grep해 재사용할 수 있어야 하고, git 밖 보관은 유실로 이어진다(실증: ai-tab에서 gstack 산출물·구 와이어프레임이 도구 제거와 함께 소실된 반면, git 안의 리서치는 참조 0건으로 방치돼도 생존했다). 텍스트 위주라 레포 비용은 무시할 수준이다.

예외로 `.gitignore`에 등록하는 경우는 둘뿐이다: ① 레포가 공개이거나 공개 전환 가능성이 있다 ② 서드파티 비공개 정보·개인 메모가 섞인다. 커밋된 리서치는 히스토리에 영구히 남으므로 이 판단은 첫 리서치 커밋 전에 한다. 정말 민감한 개인 메모는 추적 여부와 무관하게 레포 밖 개인 저장소에 둔다.

추적하더라도 `_research/`의 지위는 변하지 않는다: raw 보관소이고, stale 무방하며, 유지보수 의무가 없다. `_` 접두가 이 비기준 지위의 표시다.

### 다른 문서와의 단절

리서치 문서는 기준 문서(`ARCHITECTURE.md`, `decision-logs/*.md`, `features/*.md`, `workstreams/*.md`)와 **링크로 연결되지 않는다.**

1. 리서치는 기준 문서의 근거가 아니라 raw 정보 저장소다. 기준 문서가 어떤 사실·결정을 필요로 하면 리서치를 가리키지 말고 **필요한 내용을 정리해 본문에 직접 포함한다.**
2. `.gitignore` 예외를 쓰는 레포에서는 기준 문서가 이 경로를 가리키면 다른 사람에게 dead link가 된다. 링크 금지를 추적 여부와 무관한 규칙으로 두면 예외 레포에서도 안전하다.

리서치는 stale되어도 무방하다. 기준 문서가 아니라 우리가 이런 결정을 하게 된 배경 지식이기 때문이다.

### 피해야 할 것

- workstream의 현재 진행 상태를 리서치 문서에 적기
- 기준 문서에서 `_research/` 경로를 링크하거나 참조 남기기
- 파일명만 rename하고 본문 갱신을 누락 (또는 그 반대)
- 같은 주제에 의도 없이 날짜만 다른 파일 여러 개 쌓기

## Recommended Shapes

`BACKLOG.md`·`LEARNINGS.md`에는 권장 형태가 없다 — 한 줄 항목의 목록이며, 형식보다 항목의 휘발(승격·제거)이 본질이다. 갱신 날짜류 메타데이터는 어느 문서에도 두지 않는다 — git log가 안다.

### `docs/PROJECT_STATE.md`

```md
# Project State

## Active Workstreams

### payment-webhook-retry
Status: IN PROGRESS
Owner: link
Detail: docs/workstreams/payment-webhook-retry.md

### auth-session-cleanup
Status: BLOCKED
Owner: link
Detail: docs/workstreams/auth-session-cleanup.md

## Repo-Wide Risks
- 결제와 인증 쪽 테스트 픽스처가 제각각이라 회귀 테스트 신뢰도가 낮음

## Immediate Priorities
- payment-webhook-retry 마무리
- auth-session-cleanup 결정 확정
```

### `docs/workstreams/<slug>.md`

```md
# payment-webhook-retry

Branch: feat/payment-webhook-retry
Worktree: ../repo-payment-webhook-retry

<!-- 합의부: Align 시점의 합의. 바꾸는 것은 결정이다 — mark를 거친다. -->

Goal:
결제 webhook 재전송 시 중복 반영과 누락을 줄인다.

Mental Model:
외부 시스템은 같은 이벤트를 여러 번 보낼 수 있다. 이 시스템은 수신 횟수가 아니라
이벤트 ID를 처리 단위로 삼아, 하나의 이벤트를 최대 한 번만 반영한다.

Key Trade-off:
사후 보정보다 수신 시점 차단을 선택한다. 중복 반영의 운영·신뢰 비용을 줄이는 대신,
이벤트 ID의 보관 기간과 조회 실패를 운영해야 한다.

Current Scope (수직 슬라이스):
- duplicate guard — 수신 → 중복 판정 → 멱등 처리까지 관통
- retry backoff — 실패 → 재시도 스케줄 → 성공/포기까지 관통
- failure logging — 포기 이벤트 → dead-letter 기록 → 조회까지 관통

Behavior Notes:
- 동일 이벤트 재전송 시 중복 반영하지 않아야 함
- 실패 이벤트는 재시도 후 로그로 남겨야 함

Out of Scope:
- 관리자 수동 재전송 UI

<!-- 상태부: 개발 중 수시로 변한다. Current State는 커밋 로그를 재서술하지 않는다 —
     로그가 못 담는 판정(슬라이스별 완료/미완, 1차/우회 같은 해석)만 적는다. -->

Current State:
- duplicate guard: 완료
- retry backoff: 1차 구현 (backoff 상한 재검토 필요)
- failure logging: 미착수

Blockers:
- sandbox 재전송 검증 제한

Next Step:
- duplicate delivery integration test 추가
- dead-letter 처리 규칙 확정

Learnings:
- sandbox는 서명 헤더가 실제 재전송과 달라 로컬 검증이 안 됨

Read First:
- src/payments/webhook.ts
- tests/payments/webhook.test.ts

Commands:
- pnpm test webhook

Verification:
- unit test 통과
- integration test 일부 미실행
```

### Change Brief (소비성 이해 도구)

Change Brief는 커밋 로그나 기준 문서의 대체물이 아니다. 의미 있는 변경 뒤 대화·PR·데모에서 전달하고, 장기 가치가 확인된 모델만 기준 문서로 승격한다.

```md
## 결과
- 사용자·운영·시스템 관점에서 새로 가능해진 일

## 고려와 선택
- 검토한 선택지, 채택한 선택, 선택 기준과 감수한 trade-off

## 이제의 모델
- 앞으로 이 동작을 어떤 규칙·흐름·경계로 이해하면 되는가

## 경계
- 이번에 바꾸지 않은 것과 다음에 결정할 것

## 검증
- 테스트·실행·관측으로 확인한 증거
```


### `docs/decision-logs/<topic>.md`

```md
# Authentication Decision Log

## Current Decision
JWT + refresh token rotation을 사용한다(D-0001). refresh 재발급 시 rotation을 강제한다(D-0004).

## Why This Is Current
- 모바일/웹 공통 처리 단순화
- 서버 세션 저장소 의존성 축소

## Decision History

### D-0001 — 서버 세션 대신 JWT + refresh rotation (2026-05-03)
Status: Accepted
Why:
- 다중 클라이언트 환경에서 세션 공유 부담이 큼
- 인증 인프라 단순화가 필요했음

### D-0004 — refresh 재발급 시 rotation 강제 (2026-05-12)
Status: Accepted (D-0001 보강)
Why:
- 탈취 시 피해 반경 축소 필요
```

결정 실질은 `Current Decision`에만 있다(§4 결정 ID 규약). 히스토리 항목은 제목 + 그 시점의 Why + supersede 사실만 갖는다.

### `docs/_research/YYYY-MM-DD-<slug>.md`

```md
# Stripe Webhook Retry Strategies

## Topic
Stripe webhook 재전송 전략 비교.

...

## Update History
- 2026-05-08 (link): 최초 조사
- 2026-05-15 (codex): Dashboard 재전송 동작 추가 검증, Implications 갱신
```

파일명의 `YYYY-MM-DD`는 가장 최근 `Update History` 항목의 날짜와 일치시킨다. 본문을 갱신하면서 파일명을 함께 rename하는 것이 규칙이다.

## 변경 이력

운영 중 마찰은 `protocol-friction-log.md`에 기록하고, 리뷰에서 확정된 프로토콜 변경만 여기에 남긴다. `field-notes/`의 실적용 기록과 `digests/`의 외부 검토는 **진행 중인 리뷰의 입력**일 뿐 기준 문서나 영구 아카이브가 아니다. 리뷰가 끝나면 결론은 이 변경 이력·스킬 rationale·`upstream-sources.md`에 직접 남기고, 처리한 로그 행과 review packet은 삭제한다. 각 행은 전역 연번 ID(`P-NNNN`)를 가지며, 인용은 날짜가 아니라 ID로 한다 — 이식된 레포의 AGENTS.md 마커가 이 ID를 버전 스탬프로 삼는다. 스킬 초안과 관계도는 `skill-drafts/` 참고. 레포별 "언제 어떤 스킬을 쓰나"는 각 레포 `AGENTS.md`의 Skill routing이 맡는다.

| ID | 날짜 | 변경 내용 | 사유 |
| --- | --- | --- | --- |
| P-0001 | 2026-07-05 | 지식 4분면·git 경계 원칙 추가, 작업 셰이핑(§2)·포획 규칙(§4)·Parallel Workstreams·리서치 생성 경로 신설                                                                                                                                                                                                                 | mattpocock 스킬 사상(grill·research 핸드오프·전제 도전) 흡수                                                                                                                                                                                                                                                                                                                         |
| P-0002 | 2026-07-07 | 단계 어휘 확정(Capture/Align/Kickoff/Develop/Resume/Promote + park/mark). Align을 4수 구조로 개편(접근안 벌리기·초안·검토 게이트·출구 3갈래), cold-read audit·수직 슬라이스·합의부/상태부 분리 도입. 기술 결정(구 §5)을 mark 횡단 규칙으로 Develop에 통합. 전제 도전에 User Challenge 규격, Resume에 Current Decision 필수화, Promote에 검증 게이트, `LEARNINGS.md` 버퍼 신설 | superpowers(brainstorming 접근안 벌리기·adversarial spec review·증거 우선)·gstack(User Challenge·결정 재주입·learnings 버퍼)·mattpocock 최신(to-issues 수직 슬라이스·구현자 기준 done) 비교 분석 흡수. plan 영속 보존(accretion)·공통 preamble·질문 학습 자동화는 기각                                                                                                                                                     |
| P-0003 | 2026-07-10 | 결정 ID 규약 신설(§4 — 전역 연번 ID·경로 아닌 ID 인용·주제 파일 = 뷰·md 유지 + lint 보강). 이슈 트래커 경계 규칙(셰이핑 완료 = 이슈 트래커 권위, fog·장기 후보 = BACKLOG, Align 출구에서 이슈 승격). Document Index에 reference 문서 행 추가(소스 오브 트루스가 코드가 아닌 것만 허용)                                                                                       | ai-tab 레포 적용(2026-07-09~10 재구성, PR #33) 리뷰에서 확정. 문서들이 결정을 파일 경로로 인용해 ADR→decision-log 전환 시 레포 전역 링크 치환이 필요했던 경험이 ID 인용 규칙의 근거. JSONL 등 구조화 포맷은 검토 후 기각 — 소비자(사람·LLM)와 질의(grep·상단 읽기)에 이득 없음                                                                                                                                                                            |
| P-0004 | 2026-07-10 | 리서치 git 추적 기본값 반전 — 기본 추적, 공개 레포·민감 정보 레포만 `.gitignore` 예외. 링크 금지·stale-OK·`_` 접두(비기준 표시)·파일명 규칙은 유지                                                                                                                                                                                        | git 밖 보관물의 유실 실증(ai-tab: gstack 산출물·구 와이어프레임 소실 vs git 안 리서치는 방치돼도 생존) + 에이전트 재사용 가치(clone만으로 grep) + 낮은 레포 비용. 유일한 반대 논거(민감 메모의 히스토리 잔존)는 전면 금지가 아니라 예외 조건으로 처리                                                                                                                                                                                                       |
| P-0005 | 2026-07-10 | 파일명 `AGENTS_DOC_PROTOCOL.md` → `AGENT_WORKFLOW_PROTOCOL.md`, 제목 「Agent Workflow Protocol」로 개정. `protocol-skill-guide.md` 폐기 — 스킬 초안·관계도는 `skill-drafts/`, 레포별 스킬 매핑은 각 레포 AGENTS.md Skill routing이 승계                                                                                       | "DOC"이 내용의 절반(Align 4수·park/mark·병렬 운용 등 작업 흐름)을 대표하지 못하고, `AGENTS_DOC`이 "AGENTS.md에 관한 문서"로 오독될 여지(이 프로토콜이 AGENTS.md라는 파일을 정의하므로 혼동 실재). skill-guide는 "스킬 없음 칸의 반복 감지 → 스킬 후보 발굴"이 존재 이유였는데 skill-drafts 탄생으로 완료 — 무착지 항목 2건(격주 정비 패스, grill 전 스코프 쪼개기)은 friction log에 park                                                                                           |
| P-0006 | 2026-07-10 | 파일명 관례 신설(대문자 = 코어 권위 문서, 소문자 = 주제별 reference) + 하드코딩 스킬용 1줄 포인터 패턴. `GLOSSARY.md` 행 신설(도메인 용어집 — `CONTEXT.md`라는 이름 불채택), reference 행에서 용어집 제거·"같은 소스 문서는 하나로 합친다"·"미래 설계 노트 금지" 보강                                                                                                         | ai-tab 문서 다이어트 리뷰에서 확정. `CONTEXT.md`는 mattpocock domain-modeling의 DDD Bounded Context 유래(CONTEXT-MAP + 컨텍스트별 CONTEXT.md 구조) — single-context 레포에서 의미가 소멸하고 파일명이 중의적("It is a glossary and nothing else"가 원문 정의). 단 그 스킬이 파일명을 하드코딩하고 없으면 lazy 생성하므로 포인터로 갈라짐 차단. 다이어트 사례: 미래 설계 노트(window-slot-migration)·코드 중복 스키마 나열(behavioral-data-strategy)이 reference 자격 미달로 확인됨 |
| P-0007 | 2026-07-10 | 합치 정정 — §4 상태부 예시 리스트 삭제, 결정 ID 규약에 실질 중복 금지 신설(실질은 `Current Decision`에만, 히스토리는 Why·supersede 사실만 — shape에도 반영), PROJECT_STATE 수명 "장기, 항목은 휘발성"으로 정정, 파일명 관례 재정의(대문자 = 레포당 하나뿐인 고정 역할·전부 읽는 층 / 소문자 = 주제·작업 단위·골라 읽는 층), §6에 수행 시점(merge 후 main)·이슈 닫기 명시, 프로토타입 산출물 착지(mark) 규칙 1줄, Resume에 GLOSSARY(있으면) 삽입 | 전면 합치 리뷰. §4 예시 리스트의 behavior notes가 합의부/상태부 분리와 모순(오정보), 중복 금지 패턴이 promote 초안에만 있어 "불변식은 프로토콜에" 규율 위반, 종전 관례가 decision-logs(소문자 권위 문서)를 설명 못함, 이슈 경계 규칙에 종료 전이 부재 |
| P-0008 | 2026-07-10 | 제시 순서 통일 — Sample Repo 트리·Document Index를 §5 Resume 읽기 순서로 재배열(VISION→GLOSSARY→ARCHITECTURE→PROJECT_STATE→workstreams→decision-logs, 이후 BACKLOG→LEARNINGS→features→reference→_research), 트리에 reference 예시(`stripe-sandbox-quirks.md`) 추가 | 세 곳(트리·인덱스·Resume)이 세 가지 순서를 쓰고 있었음. agent가 실제로 실행하는 유일한 순서(Resume)로 통일 — "인덱스 순서 = 읽기 순서" 한 규칙만 기억하면 됨 |
| P-0009 | 2026-07-10 | git 중복 제거 — PROJECT_STATE shape에서 `Last Updated`·`Current Summary`·`Completed (recent)` 삭제(§6 1단계 함께 개정), workstream `Current State`에 커밋 로그 재서술 금지(로그가 못 담는 판정만) 가이드, `_research`에서 `Created`·`Last Updated` 삭제(`Update History`로 일원화). features→reference 통합은 기각 | 원칙(git이 아는 정보 재기록 금지) 적용: 날짜는 git log가, 완료 이력은 merge 커밋이 진실 — 수동 사본은 갱신 누락 시 거짓이 됨. 단 `_research`의 `Update History`(gitignore 예외 레포 존재 + rename이 추적을 끊음)와 decision-log 제목 날짜(히스토리 항목이 파일 간 ID째 이동 가능)는 git 위임 불가라 유지. features 통합은 사용자 기각 — 기능 설명서 카테고리의 자명성 유지 |
| P-0010 | 2026-07-12 | CLAUDE.md 포인터 예시를 마크다운 링크에서 `@AGENTS.md` import로 정정(Sample Repo 참고 항목·Document Index `CLAUDE.md` 행). AGENTS.md 가이드 섹션 신설(원칙·포함할 것·넣지 말 것) — 원칙에 "매 요청마다 항상 필요한 내용만" 기준 추가(조건부 규칙은 경로별 규칙·스킬로) | 실제 `CLAUDE.md`를 마크다운 링크 → `@AGENTS.md`로 바꾼 뒤에야 AGENTS.md 규칙이 세션 컨텍스트에 실제로 로드됨을 확인(마크다운 링크는 자동 로드되지 않음, Claude Code 공식 문서). 프로토콜이 AGENTS.md라는 파일의 존재는 규정하면서 내용 기준은 없어 매 레포마다 임의로 채워지던 공백을, agents.md 표준·OpenAI Codex 공식 가이드·Claude Code 공식 문서 교차 확인으로 메움. 상시성 기준은 Claude Code 공식 문서의 rules/skills 구분(매 세션 로드 vs 필요시만 로드) 적용 |
| P-0011 | 2026-07-13 | 변경 이력 행 연번 규약 신설 — 각 행에 전역 연번 ID(P-NNNN) 소급 부여, 표에 ID 열 추가. 이식된 레포의 AGENTS.md 마커는 이식·갱신 시점의 마지막 행 ID를 버전 스탬프로 삼는다(setup-workflow 갱신 모드의 기준점). 인용은 날짜가 아니라 ID로 | setup-workflow 초안 검토에서 확정. 날짜는 기준점 역할 불가 — 같은 날 다수 행이 실데이터로 존재(2026-07-10에 7행). semver는 리뷰 세션 단위 일괄 개정에 호환성 의미론이 부적합하고 매 개정 판정 비용을 부과. 결정 ID 규약(§4, D-NNNN)으로 이미 검증된 연번 패턴의 재사용 — 프로토콜 사상의 자기 적용 |
| P-0012 | 2026-07-20 | 문서화 목적에 사람의 멘탈 모델 유지·다음 판단 참여를 동등하게 추가. 기준 문서와 소비성 이해 도구를 구분하고, 문서 서술 기준을 신설. Align에 agent와 사용자의 이해 정렬·이해 확인, workstream 합의부에 Mental Model·Key Trade-off, Develop에 Change Brief와 micro-world 일반화, Resume에 reorientation, Promote에 별도 이해 확인을 추가 | Geoffrey Litt의 "Understanding is the new bottleneck" 관점을 검토해, 이해를 agent 산출물의 정오 판정이 아니라 사람이 프로젝트를 다음으로 움직일 참여 능력으로 재정의. 매 diff 설명문을 영속화하면 문서 과잉이라는 창립 원칙과 충돌하므로, 설명은 기본 소비성 도구·반복 판단 가치가 확인된 모델만 기준 문서 승격으로 설계. Align에서 agent만 이해한 상태를 합의로 오인하지 않고, 질문·시나리오를 설명 실패 감지 장치로 사용 |
| P-0013 | 2026-08-02 | 프로토콜 레포도 문서 lifecycle 예외를 두지 않는다. `protocol-friction-log.md`는 미결 마찰 inbox, `field-notes/`·`digests/`는 진행 중 review packet으로 한정한다. 리뷰 뒤 결론은 변경 이력·스킬 rationale·`upstream-sources.md`에 직접 남기고, 처리한 로그 행과 packet을 삭제한다 | 실적용 기록과 다이제스트를 영구 아카이브로 축적하면 “임시 정보는 승격 후 삭제”라는 창립 원칙과 어긋나며, 같은 결론이 로그·회고·기준 문서에 중복된다. 실제 검증의 맥락은 판단 전까지 필요하지만, 판단 뒤 현재 규칙을 이해하는 데 필요한 것은 결론과 이유뿐이다. Git 이력은 필요할 때만 과거 packet을 되짚는 경로로 충분하다 |
