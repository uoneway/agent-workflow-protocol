# promote — 초안

베이스: 프로토콜 §6 체크리스트 + superpowers verification-before-completion(게이트) + gstack ship(백로그 대조). 호출 방식: user-invoked.

```yaml
name: promote
description: 작업이 끝나서 문서를 정리하고 workstream을 닫을 때. 사용자가 "완료 처리하자", "promote", "이 작업 마무리하자"라고 하면 사용. merge 직전·직후 모두 가능.
```

---

## 본문

**게이트: 증거 확인.** `docs/workstreams/<slug>.md`의 `Verification`이 실제 증거(테스트 결과, 실행 확인)로 채워져 있는지 확인하라. 비어 있거나 "될 것이다" 수준이면 완료 처리를 중단하고 검증부터 하라. 주장보다 증거다.

> `[가져옴 · superpowers verification-before-completion]` "주장보다 증거" 원칙. superpowers는 이를 상시 규칙으로 두지만 우리는 promote의 입구 게이트로 배치 — 상시 규칙은 AGENTS.md 몫이고, 여기는 마지막 방어선.

게이트를 통과하면 순서대로:

1. `docs/PROJECT_STATE.md`: active 제거 — 완료 이력은 merge 커밋이 기록하므로 별도 목록은 없다. 이슈 트래커에서 온 작업이면 이슈에 근거 커밋 해시를 코멘트로 남기고 닫아라
2. 구조가 바뀌었으면 `docs/ARCHITECTURE.md` 갱신
3. 장기 가치 있는 결정이면 `docs/decision-logs/*.md` 갱신 — 개발 중 mark를 빠뜨린 결정이 없는지 workstream 문서와 대화를 되짚어라. 새 항목은 레포 전역 연번 ID를 부여하고(제목 규약: `### <id 앵커>ID — 제목 (YYYY-MM-DD)`), 같은 파일의 `Current Decision`을 함께 갱신하라. 결정 실질은 Current Decision에만 두고 히스토리 항목은 supersede 사실·배경만 — 같은 내용을 두 번 쓰지 마라
4. 설명서 가치가 있는 기능이면 `docs/features/<feature>.md` 생성/갱신
5. repo 전체 규칙이 드러났으면 `AGENTS.md` 갱신
6. workstream의 `Learnings`를 `docs/LEARNINGS.md`로 이동. 이동하면서 LEARNINGS.md에 같은 교훈이 이미 있는지 확인 — 반복 확인이면 `AGENTS.md`로 승격하고 두 항목 모두 제거
7. `docs/workstreams/<slug>.md` 삭제

> `[가져옴 · 프로토콜 §6]` 1~7 그대로. 3의 "mark 빠뜨린 결정 되짚기"만 `[신규]` — promote가 mark의 최종 안전망 역할.
> `[신규 · 프로토콜 §6]` 6의 "이동 시점에 반복 판정" — 승격 판단을 별도 리뷰로 미루지 않고 이동하는 손이 그 자리에서 (승격은 어차피 diff를 보는 순간이 가장 싸다).
> `[신규 · 프로토콜 §4 결정 ID 규약 + 2026-07-10 ai-tab 전환 세션]` 3의 ID·중복 금지 — ADR 9건을 주제 로그로 통합하며 확인된 저작 패턴: Current Decision과 히스토리에 같은 실질을 두 번 쓰면 다음 갱신 때 한쪽이 낡는다. 히스토리는 "현행 유지(본문 참고)"로 위임. 1의 이슈 닫기 — 이슈 트래커 경계 규칙의 promote 쪽 실행 (ai-tab AGENTS.md task lifecycle에서 가져옴). → 2026-07-10 전면 리뷰로 중복 금지·이슈 닫기 모두 프로토콜(§4·§6)에 편입 — 이 단계는 이제 신규 규칙이 아니라 실행 지점이다.

마무리 대조 두 가지:

- `docs/BACKLOG.md`에 이 작업으로 이미 해결된 항목이 남아 있으면 제거를 제안하라.
- `PROJECT_STATE.md`의 다른 active workstream 중 오래 진전 없는 것(좀비)이 보이면 지적만 하라 — 닫을지는 사용자가 정한다.

> `[참조 · gstack ship]` "ship이 TODOS를 diff와 대조해 완료 항목 자동 이동" — 우리는 자동 이동 대신 제안으로 (User Sovereignty와 우리의 강제 대신 가이드 선호, 양쪽 모두와 일관).
> `[가져옴 · 프로토콜 Parallel Workstreams]` 좀비 감지를 promote 시점에 얹음 — "PROJECT_STATE를 갱신할 때마다"의 실행 시점이 바로 여기.

승격이 끝나면 한 줄로 보고하라: 승격된 것(어디로), 삭제된 것, 남긴 제안.

> `[검토점 1]` merge와의 순서 — 프로토콜은 "merge 후 승격되면 삭제"를 시사하지만 code-review(merge 전)와의 순서를 스킬이 강제할지. 현재 초안은 무관하게 동작. → 해소: 프로토콜 §6이 "merge 후 main에서 수행"으로 명시 (2026-07-10 전면 리뷰).
> `[검토점 2]` features/ 판정(4번)이 가장 주관적 — "설명서 가치" 판정 기준 예시를 넣을지, 사용자에게 항상 물을지.
> `[검토점 3]` git 커밋까지 스킬이 할지 (promote 커밋 하나로 묶기 vs 사용자 커밋).
