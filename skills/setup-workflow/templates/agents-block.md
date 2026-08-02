<!-- agent-workflow-protocol {{PROTOCOL_STAMP}} start -->
<!-- agent-workflow-protocol-hash: {{MARKER_HASH}} -->
## Agent Workflow

이 레포는 Agent Workflow Protocol을 따른다. 단계 어휘: Capture → Align → Kickoff → Develop → Resume → Promote.
{{PROTOCOL_SOURCE_LINE}}
**이 블록은 불변식·라우팅·레포 설정만 담는다. 절차의 상세는 아래 Skill routing이 가리키는 스킬에 있다** — 이 파일만으로 절차를 재구성하려 하지 마라. 스킬을 쓸 수 없는 환경이면 그 사실을 사용자에게 알리고 멈춘다.

### 재개 시 읽기 순서
이 파일 → docs/VISION.md → (docs/GLOSSARY.md) → docs/ARCHITECTURE.md → docs/PROJECT_STATE.md
→ 관련 docs/workstreams/<slug>.md → 관련 docs/decision-logs/의 Current Decision (필수)

### 상시 규칙 — park / mark / explain
- 작업 중 새 가지는 쫓지 말고 한 줄로 착지한다: 현재 scope 안 → workstream 문서의 Next Step, 밖 → docs/BACKLOG.md (main에서만).
- 결정이 굳으면 그 자리에서 기록한다: 현재 구조는 docs/ARCHITECTURE.md, 이유·이력은 docs/decision-logs/ (레포 전역 연번 ID).
- 사람의 다음 판단에 영향을 줄 변경은 코드 투어 대신 결과·선택·핵심 모델·경계·검증을 설명해 멘탈 모델을 정렬한다. 장기 가치가 확인된 내용만 기준 문서로 남긴다.

### Skill routing
셰이핑 → align · 작업 시작 → kickoff · 작업 완료 → promote · 외부 사실 조사 → workflow-research · 초안 감사 → cold-read

### 이 레포의 설정
- 이슈 트래커: {{TRACKER_SETTING}}
- 결정 ID: {{DECISION_ID_SETTING}}
<!-- agent-workflow-protocol end -->
