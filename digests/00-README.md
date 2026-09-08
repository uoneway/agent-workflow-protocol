# digests — 진행 중 검토의 입력

외부 조사(업스트림 스킬 레포·블로그·공식 문서)를 사용자 검토용으로 압축한 **packet**. 기준 문서도 영구 아카이브도 아니다.

수명은 하나의 규칙으로 정해진다. **결론을 권위 문서에 반영하면 삭제한다.** 채택분은 `AGENT_WORKFLOW_PROTOCOL.md`의 변경 이력에, 스킬 설계 판단은 `skill-rationales/`에, 소스별 흡수·기각 기록은 `upstream-sources.md`에 남긴다. 기각한 것도 남긴다 — 다음 스카우트가 같은 아이디어를 다시 올리지 않도록. 다만 packet 안에 결정형 research synthesis나 재해석 가치가 큰 원본 evidence가 있으면 삭제 전에 `research/`로 재분류한다(P-0024).

`upstream-scout`가 만드는 다이제스트가 기본 경로이고, 그 스킬의 순서는 변화 감지 → 필요할 때만 다이제스트 → 사용자 리뷰 → 결론 반영 → 삭제다.

## 현재 남아 있는 것

남은 7월 문서는 재설계된 `setup-workflow`의 영어 실행본 저작과 forward test에서 다시 판정한다. **필요한 결론이 실행본·rationale·upstream 기록에 반영되는 시점이 삭제 시점이다.**

| 파일 | 남아 있는 이유 |
| --- | --- |
| `2026-07-18-setup-transplant-survey.md` | 이식 메커니즘 서베이. 채택 패턴 8종은 초안에 반영됐고 소스별 흡수 기록은 `upstream-sources.md`에 있으나, 실행본을 쓸 때 "왜 이 구조인가"의 근거로 필요하다 |
