# Skill Drafts — 합의용 초안

실 스킬 파일로 재작성하기 전, **어떤 내용이 어떻게 들어가는지 합의하기 위한** 초안. 확정되면 이 레포의 `skills/<name>/SKILL.md`로 재작성하고 이 폴더의 해당 초안은 삭제한다. 설치는 `scripts/link-skills.sh`가 `~/.claude/skills/<name>` symlink로 처리한다 — 레포가 source of truth고 `git pull`이 곧 업데이트다 (mattpocock/skills 관례. git 밖 보관은 유실로 이어진다는 프로토콜 원칙의 적용이기도 하다).

## 주석 태그

- `[가져옴 · 출처]` — 원문을 거의 그대로 (번역 포함)
- `[변형 · 출처]` — 가져오되 수정함. 무엇을 왜 바꿨는지 병기
- `[신규 · 근거]` — 우리가 만든 것. 근거는 프로토콜 섹션 또는 세션 합의
- `[참조 · 출처]` — 아이디어만 빌리고 문장은 새로 씀
- `[검토점]` — 리뷰 때 결정할 열린 논점

## 적용한 저작 규율 (2026-07-07 비교 분석에서 채택)

1. **description은 트리거 전용** — "언제 쓰는가"만. 절차를 요약하면 에이전트가 본문 대신 설명만 따른다 (superpowers)
2. **no-op 테스트** — 기본 동작을 바꾸지 않는 문장은 삭제 (mattpocock writing-great-skills)
3. **조건부만 분리** — 무조건 이어지는 수(手)는 한 스킬에, 조건부 트리거는 위성 스킬로 (세션 합의)
4. **불변식은 프로토콜에, 절차는 스킬에** — 스킬은 AGENT_WORKFLOW_PROTOCOL.md를 재서술하지 않고 실행 절차만 담는다

## 스킬 관계도

```
setup (user-invoked, 이식 진입점 — 레포당 1회 + 갱신)
align (user-invoked, 척추)
 ├─ 조건부 위성: research (외부 사실)
 ├─ 조건부 위성: prototype (고충실도 — mattpocock 플러그인 기존 것 그대로, 초안 없음)
 └─ 조건부 위성: cold-read (초안 감사 — setup ⑤도 재사용)
kickoff (user-invoked)  ← align의 "지금 시작" 출구
promote (user-invoked)  ← 작업 완료 시
upstream-scout (user-invoked, 메타 루프 — 워크플로우 밖)
```

park·mark는 스킬이 아니라 AGENTS.md 규칙 (상시 행동 규칙은 스킬 형태 부적합 — 세션 합의). mark에는 결정 ID 규약(프로토콜 §4, 2026-07-10)이 포함된다 — 스킬 중에서는 kickoff(초안 착지 시 ID 부여)와 promote(놓친 mark 안전망)가 실행 지점.

## 동기화 이력

- 2026-07-10 | 프로토콜 개정(결정 ID 규약·이슈 트래커 경계·reference 문서 기준)을 align 출구·kickoff 1/4단계·promote 1/3단계에 반영. ai-tab 적용 세션(PR #33)의 저작 패턴(Current Decision↔히스토리 중복 금지)도 promote에 수록. align의 구 "트래커 불채택" 기각 기록은 뒤집힘 표시.
- 2026-07-10 | 전면 리뷰 반영: promote 1단계에서 `Completed (recent)` 기록 제거(완료 이력은 merge 커밋이 담당), promote 검토점 1(merge 순서) 해소 표시, 중복 금지·이슈 닫기의 프로토콜(§4·§6) 편입 표시, research 착지 관례에서 `Created`·`Last Updated` 폐지(Update History로 일원화). 확정 스킬 착지가 `~/.claude/skills` 직접 재작성 → 레포 `skills/` + symlink 설치로 변경.
- 2026-07-12 | setup 초안 신설 — 레포 이식 진입점(레포 각인: AGENTS.md 마커 블록·docs/ 최소 골격·레포별 설정 + 갱신 모드). 근거: 이식 메커니즘 서베이(`digests/2026-07-12-setup-transplant-survey.md`, spec-kit·Agent OS·BMAD·GSD·superpowers·mattpocock·gstack). link-workflow의 목적을 "스킬 배포"가 아니라 "워크플로우 이식"으로 리프레이밍(사용자 방향).
