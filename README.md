# link-workflow

AI agent와 함께 개발할 때, 사람이 다음 결정을 이해하고 주도할 수 있도록 돕는 워크플로우 프로토콜입니다. 문서를 많이 만드는 방법이 아니라, **필요한 지식만 남기고 작업의 의도·선택·경계를 이어 가는 방법**을 정의합니다.

## 지금 할 수 있는 일

이 레포는 프로토콜과 **6개의 확정 스킬**, 그리고 아직 구현·검증이 남은 `setup-workflow` 초안을 함께 관리합니다. 확정 스킬은 설치할 수 있지만, `setup-workflow` 초안을 일반 스킬처럼 호출하거나 대상 레포에 이미 이식된 것으로 가정하지 마세요.

- 워크플로우 자체를 이해하려면 [AGENT_WORKFLOW_PROTOCOL.md](./AGENT_WORKFLOW_PROTOCOL.md)를 읽습니다.
- 실제 서비스 레포에 적용하며 회차별로 무엇이 동작하고 무엇이 비었는지 [field-notes/](./field-notes/)에 남깁니다. 마찰 로그가 **한 줄**의 장소라면, 여기는 **그 한 줄이 나온 맥락**의 장소입니다.
- 운영 중 어색함·공백·반복 지시·위반을 발견하면 `마찰: …`로 남깁니다. agent는 [protocol-friction-log.md](./protocol-friction-log.md)에 한 줄만 기록하고, 그 자리에서 프로토콜을 고치지 않습니다.
- 마찰이 10개 쌓이거나 2~3주가 지나면 리뷰 세션에서 한 항목씩 결정합니다. 확정된 변경만 프로토콜과 변경 이력에 반영합니다.
- 같은 주기로 `upstream-scout`를 자동 또는 수동 실행할 수 있습니다. 실행은 먼저 업스트림 버전·변화만 감지하며, 버전 소스는 minor 이상 변화가 있을 때만 검토용 다이제스트를 만듭니다. 자동 실행은 프로토콜이나 추적 표를 바꾸지 않고 사용자 리뷰를 요청하는 데서 멈춥니다.

## 워크플로우 한눈에 보기

`Capture → Align → Kickoff → Develop → Resume → Promote`

| 단계 | 하는 일 |
| --- | --- |
| Capture | 아이디어·외부 조사·운영 마찰을 적절한 곳에 남긴다. |
| Align | 목표, 멘탈 모델, 핵심 선택과 범위를 함께 다듬는다. |
| Kickoff | 합의한 작업을 시작 가능한 문서와 작업 단위로 착지한다. |
| Develop | 구현하며 결정은 기록하고, 사람이 이해해야 할 변화는 설명한다. |
| Resume | 문서에서 현재 맥락을 복원하고 다음 판단을 다시 맞춘다. |
| Promote | 검증 증거를 확인한 뒤, 오래 남길 지식만 기준 문서로 승격한다. |

언제나 지키는 세 가지는 다음입니다.

- **park**: 작업 중 새로 나온 가지는 바로 해결하지 말고, 나중에 볼 곳에 착지한다.
- **mark**: 되돌리기 어렵거나 넓게 영향을 주는 결정은 이유와 함께 남긴다.
- **explain**: 중요한 변경은 코드 나열보다 결과·선택·모델·경계·검증의 순서로 설명한다.

## 이 레포를 다루는 법

| 목적 | 먼저 볼 곳 |
| --- | --- |
| 원칙과 전체 절차 확인 | [AGENT_WORKFLOW_PROTOCOL.md](./AGENT_WORKFLOW_PROTOCOL.md) |
| 운영 중 마찰 남기기·리뷰 대상 확인 | [protocol-friction-log.md](./protocol-friction-log.md) |
| 다음 스킬의 내용 검토 | [skill-drafts/](./skill-drafts/)와 [초안 관계도](./skill-drafts/00-README.md) |
| 확정 스킬의 한국어 의도·업그레이드 판단 확인 | [skill-rationales/](./skill-rationales/) |
| 확정 스킬 확인·설치 | [skills/](./skills/) · `align`, `kickoff`, `promote`, `workflow-research`, `cold-read`, `upstream-scout` |
| 실제 서비스 레포에 적용한 회차 기록 | [field-notes/](./field-notes/) |
| 외부 사례와 흡수 판단 확인 | [upstream-sources.md](./upstream-sources.md), [digests/](./digests/) |

스킬 초안은 합의용 문서입니다. 리뷰에서 확정되면 `skills/<name>/SKILL.md`로 **영어 실행본을 새로 작성**하고, 초안은 더 이상 실행 명세로 유지하지 않습니다. 대신 확정된 한국어 검토 기록은 `skill-rationales/<name>.md`에 남겨 이후 업그레이드의 판단 기준으로 사용합니다. 이는 한글 초안의 문장별 번역이나 두 언어판의 병행 유지가 아닙니다. 영어 실행본은 행동을, 한국어 기록은 목적·선택·경계를 맡습니다. 자세한 관계는 [skill-rationales/](./skill-rationales/)와 [skills/](./skills/)의 안내를 따릅니다.

그때 [scripts/link-skills.sh](./scripts/link-skills.sh)를 실행하면 같은 확정 스킬을 Claude Code의 `~/.claude/skills`와 Codex의 `~/.agents/skills`에 심볼릭 링크로 설치합니다. 플러그인 패키징은 여러 스킬·MCP·훅을 함께 배포해야 할 때까지 보류합니다.

## 변경 원칙

- 프로토콜 본문은 리뷰 세션에서 확정된 변경만 수정합니다.
- 확정·기각 어느 결정이든 프로토콜의 변경 이력에 이유를 남깁니다.
- 외부 스킬이나 글의 문구를 복사하지 않고, 검토를 거쳐 필요한 사상만 흡수합니다.

레포 작업 규칙의 기준은 [AGENTS.md](./AGENTS.md)입니다.
