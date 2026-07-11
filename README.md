# link-workflow

AI agent와 함께 개발하는 워크플로우 프로토콜을 정의하고, 그것을 **임의의 git 레포에 이식·운영**하기 위한 스킬을 관리하는 레포. 스킬 배포 자체가 목적이 아니라 워크플로우의 이식이 목적이다.

이식은 2층으로 나뉜다: 스킬(절차)은 유저 레벨 symlink로 모든 레포에서 쓰이고, 레포 각인(AGENTS.md 마커 블록 + docs/ 골격 + 레포별 설정)은 setup 스킬(초안: `skill-drafts/setup.md`)이 담당한다.

## 구성

| 경로 | 역할 |
|---|---|
| `AGENT_WORKFLOW_PROTOCOL.md` | 권위 문서 — 워크플로우 단계·문서 운영 규칙·불변식 |
| `protocol-friction-log.md` | 프로토콜 자신의 BACKLOG — 운영 중 마찰의 캡처 지점 |
| `skill-drafts/` | 합의용 스킬 초안 — 확정 전 검토 대상 |
| `skills/` | 확정 스킬 실체 — 레포가 source of truth, `git pull`이 곧 업데이트 |
| `scripts/link-skills.sh` | `skills/`를 `~/.claude/skills`에 symlink로 설치 |
| `upstream-sources.md` | upstream-scout의 추적 대상과 마지막 리뷰 지점 |
| `digests/` | 워크플로우 자체에 대한 리서치·업스트림 다이제스트 착지점 |

## 루프

1. **캡처** — 운영 중 마찰을 `protocol-friction-log.md`에 한 줄로 append (원인 분석 금지 — park, don't chase)
2. **리뷰** — 2~3주마다 또는 항목 10개 도달 시, grill 세션으로 {프로토콜 수정 / 스킬 결정화 / AGENTS.md 강화 / 기각} 결정
3. **기록** — 확정 변경은 프로토콜의 변경 이력에 사유와 함께 (기각도 남긴다), 스킬은 `skill-drafts/` → `skills/`로
4. **업스트림** — upstream-scout로 참조 레포의 변경을 흡수 검토. 다이제스트 없이 프로토콜을 직접 수정하지 않는다

구조는 [mattpocock/skills](https://github.com/mattpocock/skills)의 관례를 참고했다: 스킬을 git 안에 두고 symlink로 설치, 스킬의 상태(초안/확정)는 디렉토리로 표현.
