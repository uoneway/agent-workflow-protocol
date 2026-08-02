<!-- agent-workflow-protocol-global {{PROTOCOL_STAMP}} start -->
<!-- agent-workflow-protocol-global-hash: {{MARKER_HASH}} -->
## Agent Workflow (전역 라우팅)

다음 상황에서만 Agent Workflow Protocol을 따른다. 그 외에는 평소대로 작업한다 — 이 워크플로우를 강제하지 않는다.

- 지금 작업 중인 레포의 AGENTS.md에 `<!-- agent-workflow-protocol` 마커가 있다 → **이 전역 라우팅보다 그 마커 블록의 지시를 항상 우선한다.** 레포 로컬 설정이 전역보다 이긴다.
- 마커는 없지만 사용자가 align·kickoff·promote 중 하나를 이름으로 부르거나 "셰이핑하자"/"grill해줘"/"이 작업 마무리하자" 같은 트리거를 쓴다 → 해당 스킬을 실행하되, 이 세 스킬은 이슈 트래커·결정 ID 같은 레포별 설정에 의존하므로 이 레포가 아직 이식되지 않았다면 `setup-workflow` 실행 여부를 먼저 물어라.
- 마커는 없지만 사용자가 workflow-research·cold-read·setup-workflow·upstream-scout를 부른다 → 레포별 설정과 무관하게 곧바로 실행한다. setup-workflow를 먼저 제안하지 않는다.

{{PROTOCOL_SOURCE_LINE}}
<!-- agent-workflow-protocol-global end -->
