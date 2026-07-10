# AGENTS.md

이 레포는 `AGENT_WORKFLOW_PROTOCOL.md`(권위 문서)와 그것을 실행하는 스킬들을 관리한다. 구성과 루프는 [README.md](./README.md) 참고.

## 규칙

- 프로토콜 본문은 리뷰 세션에서 확정된 변경만 수정한다. 운영 중 마찰은 `protocol-friction-log.md`에 한 줄 append만 하고, 그 자리에서 원인 분석이나 수정을 시도하지 않는다 (park, don't chase).
- 확정된 변경은 프로토콜의 변경 이력 테이블에 사유와 함께 남긴다. 기각된 제안도 남긴다 — 조용한 재론 방지.
- `skill-drafts/`는 합의용 초안이다. 확정되면 `skills/<name>/SKILL.md`로 재작성하고 초안은 삭제한다. 설치는 `scripts/link-skills.sh`.
- 업스트림(타 스킬 레포·블로그) 텍스트를 복붙하지 않는다. 흡수 대상은 사상이지 텍스트가 아니다.
