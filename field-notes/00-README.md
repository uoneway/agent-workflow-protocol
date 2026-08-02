# Field Notes — 실적용 회차 기록

link-workflow의 프로토콜과 스킬을 실제 서비스 레포에 적용한 회차별 기록.

모든 작업에 회차 문서를 만들지는 않는다. `field-notes/`는 프로토콜이나 스킬을 실제로 검증한 **의미 있는 round**에만 남긴다. 맥락이 더 필요 없는 운영 마찰은 `protocol-friction-log.md` 한 줄로 충분하다.

각 파일은 한 회차(round)의 실행 로그다. 목적은 두 가지다.

1. **플로우 검증** — 프로토콜과 스킬이 실제 작업에서 어떻게 동작했는가. 어디서 막혔고, 어디가 비어 있었는가.
2. **개선 근거 보존** — 회고에서 나온 판단이 어떤 실제 상황에서 나왔는지 남긴다. 리뷰 세션이 이 기록을 근거로 프로토콜·스킬을 고친다.

## 파일명

`<repo>-round-NN-<slug>.md`

## 회차 문서의 구조

- **Round 목표** — 이 회차에서 서비스와 플로우 각각에 무엇을 달성하려 했는가
- **실행 로그** — 어떤 스킬을 어떤 순서로 썼고 무엇이 나왔는가
- **마찰** — 실행 중 마주친 어색·공백·반복·위반. 각 항목은 `protocol-friction-log.md`에도 한 줄로 남긴다
- **회고** — 마찰의 원인과 처리 경로 판단
- **다음 회차로 넘기는 것** — 확정 변경, 보류 항목

## 마찰 로그와의 관계

`protocol-friction-log.md`는 **한 줄 캡처**의 장소이고, 여기는 **그 한 줄이 나온 맥락**의 장소다. 리뷰 세션은 로그를 클러스터링한 뒤, 판단이 필요한 항목만 여기로 내려와 맥락을 확인한다.

회차 문서에 마찰의 원인 분석을 적는 것은 허용된다 — 회차 문서 자체가 회고 산출물이기 때문이다. 캡처 시점의 무해석 원칙은 `protocol-friction-log.md`에만 적용된다.

## 적용 레포


| 레포 | 회차 | 검증한 스킬 | 마찰 | 상태 |
| --- | --- | --- | --- | --- |
| persquad | [round-01 — 워크플로우 이식](./persquad-round-01-transplant.md) | `setup-workflow`(초안) · `cold-read` | 19건 | 완료 ([PR #1](https://github.com/uoneway/persquad/pull/1)) |
| persquad | [round-02 — 첫 수직 슬라이스](./persquad-round-02-first-slice.md) | `align` · `workflow-research` · `kickoff` · `cold-read` | 6건 | 슬라이스 1 완료 |
| persquad | [round-03 — workstream 완결과 promote](./persquad-round-03-promote.md) | `promote` | 3건 | 완료 · **확정 6개 스킬 전부 실행** |


## 리뷰 대기

- [2026-07-26 프로토콜 리뷰 제안](./2026-07-26-protocol-review-proposal.md) — 마찰 25건을 4개 군집으로 정리. 최우선은 "브랜치에 있는 agent가 main 전용 자원에 닿는 방법"(6건이 한 뿌리).

## 이 기록이 만든 변경

실적용에서 확정되어 이미 반영된 것들.


| 대상                                 | 변경                                                                          |
| ---------------------------------- | --------------------------------------------------------------------------- |
| `skills/cold-read/SKILL.md`        | 감사 대상 = 문서 + 라우팅된 것 · 종료 조건 세 갈래 · 적용 대상을 만료 문서로 한정 · 사각지대 명시               |
| `skills/setup-workflow/scripts/`   | `detect-repo-state.sh` · `marker-hash.sh` · `lint-decision-logs.sh` 구현·검증   |
| `skills/setup-workflow/templates/` | `agents-block.md` · `global-routing.md` · `PROJECT_STATE.md` · `BACKLOG.md` |
| `skill-drafts/setup-workflow.md`   | ⑤ 감사 대상 정정 · ②D 무인 실행 규칙 · ④2 매핑 우선순위 · 동봉물 검증 상태                           |
