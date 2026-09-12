<!-- agent-workflow-protocol-global {{PROTOCOL_STAMP}} start -->
<!-- agent-workflow-protocol-global-hash: {{BLOCK_HASH}} -->
## Agent Workflow routing

- 레포의 `AGENTS.md`에 `<!-- agent-workflow-protocol` 마커가 있으면 그 로컬 지시를 우선한다.
- 사용자가 Agent Workflow Protocol 적용·갱신을 요청하면 `setup-workflow`를 사용한다.
- 사용자가 `orient`, `align`, `workflow-research`, `cold-read`, `upstream-scout`를 요청하면 setup 여부와 무관하게 해당 스킬을 실행한다.
- 그 외 레포와 요청에 이 워크플로우를 자동으로 강제하지 않는다.

원문: https://github.com/uoneway/agent-workflow-protocol/blob/main/AGENT_WORKFLOW_PROTOCOL.md
<!-- agent-workflow-protocol-global end -->
