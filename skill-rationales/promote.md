# promote — 한국어 의사결정 기록

> **상태:** 확정됨. 실행 기준은 [`skills/promote/SKILL.md`](../skills/promote/SKILL.md)다. 아래는 승격 전 한국어 검토 기록이며, 번역본이 아니다.

베이스: 프로토콜 §6 체크리스트 + superpowers verification-before-completion(게이트) + gstack ship(백로그 대조). 호출 방식: user-invoked.

```yaml
name: promote
description: 작업이 끝나서 문서를 정리하고 workstream을 닫을 때. 사용자가 "완료 처리하자", "promote", "이 작업 마무리하자"라고 하면 사용. merge 직전·직후 모두 가능.
```

---

## 본문

**게이트: 증거 확인.** `docs/workstreams/<slug>.md`의 `Verification`이 실제 증거(테스트 결과, 실행 확인)로 채워져 있는지 확인하라. 비어 있거나 "될 것이다" 수준이면 완료 처리를 중단하고 검증부터 하라. 주장보다 증거다.

테스트 증거 게이트와 별개로, 사람의 다음 판단에 영향을 줄 규모 있는 변경이면 최종 Change Brief로 이해 확인을 하라. Change Brief의 결과 → 고려와 선택 → 이제의 모델 → 경계 → 검증을 빠짐없이 다루되, 각 항목에서는 배경과 직관을 구현 세부보다 먼저 설명한다. 사용자가 승인·수정·추가 질문 중 하나로 응답할 기회를 준다. 대표 시나리오나 질문은 설명의 빈틈을 찾기 위한 선택 도구이지 사용자를 시험하는 절차가 아니다. 이 과정에서 드러난 장기 모델만 기준 문서로 승격한다.

게이트를 통과하면 순서대로:

1. 위의 Change Brief로 이해 확인을 마치고, 그 과정에서 드러난 장기 모델만 이후 기준 문서에 승격
2. `docs/PROJECT_STATE.md`: active 제거 — 완료 이력은 merge 커밋이 기록하므로 별도 목록은 없다. 이슈 트래커에서 온 작업이면 이슈에 근거 커밋 해시를 코멘트로 남기고 닫아라
3. 구조가 바뀌었으면 `docs/ARCHITECTURE.md` 갱신
4. 장기 가치 있는 결정이면 `docs/decision-logs/*.md` 갱신 — 개발 중 mark를 빠뜨린 결정이 없는지 workstream 문서와 대화를 되짚어라. 새 항목은 레포 전역 연번 ID를 부여하고(제목 규약: `### <id 앵커>ID — 제목 (YYYY-MM-DD)`), 같은 파일의 `Current Decision`을 함께 갱신하라. 결정 실질은 Current Decision에만 두고 히스토리 항목은 supersede 사실·배경만 — 같은 내용을 두 번 쓰지 마라
5. 설명서 가치가 있는 기능이면 `docs/features/<feature>.md` 생성/갱신 — 앞으로 기능을 사용·운영·확장·제한할 사람이 목적·관측 가능한 동작·핵심 모델·한계를 다시 알아야 하는지가 기준
6. repo 전체 규칙이 드러났으면 `AGENTS.md` 갱신
7. workstream의 `Learnings`를 `docs/LEARNINGS.md`로 이동. 이동하면서 LEARNINGS.md에 같은 교훈이 이미 있는지 확인 — 반복 확인이면 `AGENTS.md`로 승격하고 두 항목 모두 제거
8. `docs/workstreams/<slug>.md` 삭제

> `[가져옴 · 프로토콜 §6]` 1~8 그대로. 4의 "mark 빠뜨린 결정 되짚기"만 `[신규]` — promote가 mark의 최종 안전망 역할. Change Brief와 이해 확인은 P-0012의 explain 실행 지점이다.
> `[신규 · 프로토콜 §6]` 7의 "이동 시점에 반복 판정" — 승격 판단을 별도 리뷰로 미루지 않고 이동하는 손이 그 자리에서 (승격은 어차피 diff를 보는 순간이 가장 싸다).
> `[신규 · 프로토콜 §4 결정 ID 규약 + 2026-07-10 ai-tab 전환 세션]` 4의 ID·중복 금지 — ADR 9건을 주제 로그로 통합하며 확인된 저작 패턴: Current Decision과 히스토리에 같은 실질을 두 번 쓰면 다음 갱신 때 한쪽이 낡는다. 히스토리는 "현행 유지(본문 참고)"로 위임. 2의 이슈 닫기 — 이슈 트래커 경계 규칙의 promote 쪽 실행 (ai-tab AGENTS.md task lifecycle에서 가져옴). → 2026-07-10 전면 리뷰로 중복 금지·이슈 닫기 모두 프로토콜(§4·§6)에 편입 — 이 단계는 이제 신규 규칙이 아니라 실행 지점이다.
> `[신규 · mattpocock ADR-0001 hard-dependency 패턴]` 4의 시작 연번은 kickoff와 마찬가지로 AGENTS.md 마커 블록의 "이 레포의 설정"에 있어야 한다 — 없으면 임의로 매기지 말고 setup-workflow 실행 여부부터 물어라(kickoff.md 참고, 같은 근거). 2의 이슈 트래커 사용 여부도 마커 블록에 없으면 그 자리에서 물어라 — 틀린 값(트래커 있는데 없다고 가정)으로 진행해 이슈를 안 닫고 넘어가는 게 더 나쁘다.

마무리 대조 두 가지:

- `docs/BACKLOG.md`에 이 작업으로 이미 해결된 항목이 남아 있으면 제거를 제안하라.
- `PROJECT_STATE.md`의 다른 active workstream 중 오래 진전 없는 것(좀비)이 보이면 지적만 하라 — 닫을지는 사용자가 정한다.

> `[가져옴 · 프로토콜 Parallel Workstreams]` 좀비 감지를 promote 시점에 얹음 — "PROJECT_STATE를 갱신할 때마다"의 실행 시점이 바로 여기. 완료 대조 방식(자동 이동 대신 제안)이 gstack ship에서 무엇을 참조했는지는 `upstream-sources.md`의 garrytan/gstack 항목 참고.

승격이 끝나면 한 줄로 보고하라: 승격된 것(어디로), 삭제된 것, 남긴 제안.

> `[검토점 1]` merge와의 순서 — 프로토콜은 "merge 후 승격되면 삭제"를 시사하지만 code-review(merge 전)와의 순서를 스킬이 강제할지. 현재 초안은 무관하게 동작. → 해소: 프로토콜 §6이 "merge 후 main에서 수행"으로 명시 (2026-07-10 전면 리뷰).
> `[검토점 2]` features/ 판정(4번)이 가장 주관적 — "설명서 가치" 판정 기준 예시를 넣을지, 사용자에게 항상 물을지.
> `[검토점 3]` git 커밋까지 스킬이 할지 (promote 커밋 하나로 묶기 vs 사용자 커밋).
