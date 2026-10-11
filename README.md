# Agent Workflow Protocol

AI agent와 함께 개발할 때 사람이 방향과 경계를 결정하고, agent가 그 합의 안에서 실행을 완결하도록 돕는 워크플로우 프로토콜입니다. **코드와 live source로 복원할 수 없는 공유 진실만 남기고, 현재 이해와 상태 설명은 필요할 때 생성하는 방법**을 정의합니다.

## 지금 할 수 있는 일

이 레포는 프로토콜과 **5개의 배포 스킬**, 그리고 이 레포 안에서만 쓰는 유지보수 스킬 `upstream-scout`를 관리합니다.

- 워크플로우 자체를 이해하려면 [AGENT_WORKFLOW_PROTOCOL.md](./AGENT_WORKFLOW_PROTOCOL.md)를 읽습니다.
- 운영 중 어색함·공백·반복 지시·위반을 발견하면 `마찰: …`로 남깁니다. agent는 [protocol-friction-log.md](./protocol-friction-log.md)에 한 줄만 기록하고, 그 자리에서 프로토콜을 고치지 않습니다.
- 마찰이 10개 쌓이거나 2~3주가 지나면 리뷰 세션에서 한 항목씩 결정합니다. 확정된 변경만 프로토콜과 변경 이력에 반영합니다.
- 같은 주기로 `upstream-scout`를 자동 또는 수동 실행할 수 있습니다. 정기 탐지는 먼저 업스트림 버전·변화만 확인하며, 버전 소스는 minor 이상 변화가 있을 때 검토할 내용을 제시합니다. 특정 소스·버전 검토를 요청하면 그 범위를 따릅니다. 리뷰 뒤 결론을 권위 문서에 반영합니다. 자동 실행은 프로토콜이나 추적 표를 바꾸지 않고 사용자 리뷰를 요청하는 데서 멈춥니다.

## 워크플로우 한눈에 보기

`Orient → Align → Act → Reorient`

매 요청마다 별도 승인 단계를 밟지는 않습니다. 기존 요청과 합의에서 실행 위임이 명확하면 필요한 검증까지 이어가고, 상담·리뷰 요청은 근거 있는 답변으로 마칩니다.

| 단계 | 하는 일 |
| --- | --- |
| Orient — 상황 파악 | 코드·git·worktree·PR·issue 같은 현재 원천에서 목표와 현재 상태를 파악하고 다음 행동을 제안한다. |
| Align | 결과·증거·경계·위임 범위·재논의 조건을 사람과 agent가 맞춘다. |
| Act | agent가 합의 안에서 탐색·구현·검증·정리를 이어서 완결한다. |
| Reorient | 사람이 내릴 판단이 남았으면 그것부터, 없으면 결과와 검증부터 설명한다. 판단을 바꾸는 주장은 원천과 확인 방식을 밝힌다. |

`capture`는 어느 단계에서나 열린 가지를 적절한 원천에 착지시키는 횡단 행동입니다. 언제나 지키는 세 가지는 다음입니다.

- **park**: 작업 중 새로 나온 가지는 바로 해결하지 말고, 나중에 볼 곳에 착지한다.
- **mark**: 코드 밖에 남지 않으면 사라질 비싼 결정·증거·운영 제약만 이유와 함께 남긴다.
- **explain**: 중요한 변경은 현재 원천에서 사람이 직접 확인할 수 있게 설명하되, 설명 자체를 기준 문서로 축적하지 않는다. 텍스트로 판단하기 어려울 때만 표·다이어그램·HTML을 쓴다.

## 이 레포를 다루는 법

| 목적 | 먼저 볼 곳 |
| --- | --- |
| 원칙과 전체 절차 확인 | [AGENT_WORKFLOW_PROTOCOL.md](./AGENT_WORKFLOW_PROTOCOL.md) |
| 운영 중 마찰 남기기·리뷰 대상 확인 | [protocol-friction-log.md](./protocol-friction-log.md) |
| 확정 스킬의 한국어 의도·업그레이드 판단 확인 | [skill-rationales/](./skill-rationales/) |
| 배포 스킬 확인·배포 | [skills/](./skills/) · `setup-workflow`, `orient`, `align`, `workflow-research`, `cold-read` |
| 레포 유지보수 스킬 | [.agents/skills/](./.agents/skills/) · `upstream-scout` (Claude Code는 `.claude/skills/` symlink로 읽음) |
| 외부 사례와 현재 흡수 판단 | [upstream-sources.md](./upstream-sources.md) |
| 결정형 리서치와 재해석용 원본 evidence | [research/](./research/) — synthesis는 읽기 경로, `evidence/`는 필요할 때만 여는 cold archive |

확정 스킬에서는 영어 실행본이 행동을, [skill-rationales/](./skill-rationales/)의 한국어 기록이 목적·선택·경계를 맡습니다. 두 문서는 문장별 번역이나 병행 명세가 아닙니다.

확정 스킬의 기준 실행본은 이 레포의 `skills/`에 둡니다. 개인 장비에 배포하려면 다음 명령을 실행합니다.

```bash
scripts/link-skills.sh
```

이 명령은 확정 스킬을 `~/dotfiles/config/ai/skills`에 배포한 뒤, dotfiles 설치 스크립트로 Claude Code의 `~/.claude/skills`와 Codex의 `~/.agents/skills`에 연결하고 결과를 검증합니다. dotfiles 사본은 배포용 스냅샷이므로 직접 수정하지 않습니다. 다른 config 경로에 배포하려면 `--config-dir PATH`, 로컬 도구에 설치하지 않으려면 `--publish-only`를 사용합니다.

같은 이름의 비관리 스킬이 dotfiles에 있고 내용이 다르면 스크립트는 덮어쓰지 않고 중단합니다. 이 레포가 이전에 배포한 스킬은 `config/ai/skills/.agent-workflow-protocol-managed`로 구분하므로, 확정 스킬을 삭제하거나 이름을 바꾸면 다음 실행에서 배포 사본도 정리됩니다. 플러그인 패키징은 여러 스킬·MCP·훅을 함께 배포해야 할 때까지 보류합니다.

## 변경 원칙

- 프로토콜 본문은 리뷰 세션에서 확정된 변경만 수정합니다.
- 확정·기각 어느 결정이든 프로토콜의 변경 이력에 이유를 남깁니다.
- 외부 스킬이나 글의 문구를 복사하지 않고, 검토를 거쳐 필요한 사상만 흡수합니다.

레포 작업 규칙의 기준은 [AGENTS.md](./AGENTS.md)입니다.
