# 사람의 이해를 중심에 둔 워크플로우 재검토

조사일: 2026-10-11. 기준: git `97bfa84`, 프로토콜 P-0031.

## 질문과 영향을 받는 결정

모델이 계속 발전할 때 워크플로우의 병목은 agent의 실행 품질보다 사람이 정보를 쉽고 정확하게 습득해 판단하고 방향을 제시하는 능력으로 옮겨 가는가? 그렇다면 프로토콜·스킬에서 무엇을 더하고 무엇을 덜어야 하는가? 이 조사는 P-0032~P-0033에 쓰였다.

방향을 바꿀 발견: 설명을 늘리는 것이 사람의 판단 정확도를 높인다는 근거가 있다면 설명 절차를 강화한다. 반대로 설명이 과신을 키운다는 근거가 있다면 설명의 양이 아니라 검증 가능성을 다룬다. 후자가 확인됐다.

## 관찰한 사실

업스트림(저장 지점 이후 변화):

- obra/superpowers v6.3.0 → v7.0.0(2026-10-10): 중간 check-in과 plan 문서 reviewer를 제거하고 plan에 코드 대신 결정만 남긴다. brainstorming은 이해한 의도를 되말하며 추측을 표시하고, 조사 뒤 작업 크기를 정하며, fresh subagent가 만들 것을 바꾸는 질문만 한 라운드로 가져온다.
- mattpocock/skills `3cca18b` → v1.3.1(2026-10-04): `pr`(작은 시각화 요약, before/after 증거, 되돌릴 수 있는지와 영향 범위), `retro`(기계적 규칙은 lint·hook·CI로) 추가, merge conflict 스킬은 harness의 일로 보고 삭제. 레포 유지보수 자료는 배포 스킬과 분리된 `.agents/`에 둔다.
- BMAD-METHOD v6.11~6.12: 핵심 스킬 14→8, 효과 없던 reviewer 페르소나 제거, 조사 뒤 ceremony 결정, 사람이 블록 단위로 변경을 이해하는 walkthrough 신설.
- garrytan/gstack 1.58.5 → 1.91.68: 최신 모델 감사로 step-by-step scaffolding과 강조 표현 제거, 모델 출시마다 프롬프트 재감사, checkpoint 항목을 실행·읽기·추정으로 구분.
- open-gsd/gsd-core: 게이트와 계약이 늘었고 자동 선택은 opt-in으로 바뀌었다. github/spec-kit은 ceremony를 선택형 preset으로 옮겼다. agent-os는 실질 변화가 없다.

연구와 실무 보고:

- Litt와 Willison은 이해의 목적을 검증이 아니라 다음 방향을 내는 참여로 본다. Storey는 technical·cognitive·intent debt를 구분한다.
- Anthropic 무작위 실험(n=52)에서 AI 보조 집단의 숙련도 점수가 17% 낮았고, 질문하거나 설명을 요청한 참가자는 손실이 적었다.
- 반증: Kaufman 외(2026, n=86)에서 잘못된 LLM 출력의 판별 정확도는 49%였고 확신은 정답 출력과 같았다. 설명은 전체적으로 효과가 없었고 질 낮은 설명은 정확도를 낮추며 확신을 높였다. Bansal 외(CHI 2021)도 설명이 정오와 무관하게 수용을 늘렸다고 보고했다.

공식 가이드(현재 모델: Claude Fable 5.1·Opus 5.5·Sonnet 5.5·Haiku 5.5, OpenAI gpt-6-astra·gpt-6.1-sol·gpt-6-luna):

- 양사 모두 결과를 먼저 쓰고 마지막 메시지가 단독으로 읽히게 하라고 권한다.
- 과잉 질문과 조기 종료가 함정으로 명시됐다. OpenAI는 승인된 일을 먼저 끝내고 검토 가능한 결과를 만든 뒤 승인을 요청하라고 권한다.
- 응답에 내부 추론을 재현하라는 지시는 최신 Claude 모델에서 거부될 수 있다. 짧은 설명이나 수행한 행동 요약은 허용된다.
- Claude Code는 터미널 텍스트가 맞지 않는 매체일 때 artifact를 권하며, 이를 기본값으로 두지 않는다.
- Astra는 AGENTS.md와 스킬 지시에 더 민감하다. 스킬 설명은 핵심 용도와 트리거를 앞에 둔다.
- 프로젝트 스킬 경로: Claude Code `.claude/skills/`, Codex `.agents/skills/`. 둘 다 symlink를 따른다. 같은 이름이면 Claude Code는 user-level을 우선하고 Codex는 둘 다 노출한다.

## 해석

전제는 지지된다. 다만 설명이 과신을 키우므로 프로토콜은 설명의 양을 늘리지 않고 판단을 바꾸는 주장을 근거에 연결하는 방향으로 바꾼다. 업스트림이 덜어낸 것은 대부분 중간 승인과 절차 서술이며, 사람의 통제는 의도 확인·실제 산출물 승인·변경 이해라는 소수 지점으로 모인다.

## 교차 리뷰

Claude Opus 5.5의 초안을 GPT-6 Astra가 레포를 직접 읽고 검토했다([evidence](evidence/2026-10-11-human-understanding/)). 다음 지적을 받아들였다.

- `cold-read`를 align 한 줄로 흡수하는 안은 기각한다. 인계 감사는 만들 것을 바꾸는 질문이 아니라 대화 없이 안전하게 시작할 수 있는지를 본다.
- AGENTS 마커 블록 축소는 같은 사례로 Claude·GPT를 비교한 뒤에 한다. P-0029의 기각 사유가 그대로 적용된다.
- 근거 연결은 모든 주장이 아니라 판단을 바꾸는 주장에만 한다. 실행 확인은 신뢰도 등급이 아니라 증거의 종류다.
- 의도 되말하기는 Align 다섯 항목을 대체하지 않는 전달 방식이다.
- 이해 유지 영역과 퀴즈는 선택 사항이며 완료 조건이 아니다. explain은 스킬보다 Reorient 지침으로 먼저 운영한다.
- 매체는 형식 순서가 아니라 판단 과제로 고른다. 인터랙티브 HTML은 입력이나 시간을 바꿔 봐야 판단이 달라질 때 쓴다.
- 초안의 gstack 추적 날짜 수정안은 철회했다. 그 열은 발행일이 아니라 마지막 리뷰일이다.

## 한계

- 업스트림·공식 문서는 조사 agent가 WebFetch 요약을 거쳐 읽었다. openai.com 일부 페이지는 403으로 검색 요약만 확인했다.
- 2026-04-23 이후 Anthropic 엔지니어링 글, 2026-07-02 이후 Litt 글은 찾지 못했다. Karpathy는 2차 요약만 확인했다.
- 이 레포에서 개정 전후를 같은 모델·사례로 비교한 측정은 없다. AGENTS 블록 축소를 보류한 이유다.

## 결정 영향

- P-0032: 레포 유지보수 스킬 분리, 배포 매니페스트 이관.
- P-0033: 판단을 바꾸는 주장의 근거 연결, 판단 우선 Reorient와 단독 가독성, 검토 가능한 결과 뒤 승인 요청, 설명 매체 선택 기준, 선택적 이해 유지 영역, 변경 이력 서술 간결화. cold-read 흡수·필수 퀴즈·모든 주장 태그·스킬 수 맞추기는 기각, AGENTS 블록 축소는 비교 측정까지 보류.

## 참조 원문

모두 2026-10-11 확인.

| 출처 | 위치 | 버전·게시일 | 사용한 주장 |
| --- | --- | --- | --- |
| obra/superpowers | https://github.com/obra/superpowers/releases/tag/v7.0.0, v6.4.2, v6.4.1 | v7.0.0 `bb92a77`, 2026-10-10 | check-in·reviewer 제거, 의도 되말하기, builder check |
| mattpocock/skills | https://github.com/mattpocock/skills/compare/3cca18b...main | v1.3.1 `49dd158` | `pr`·`retro`, 스킬 삭제, `.agents/` 분리 |
| aihero.dev | https://www.aihero.dev/skills-changelog-v13-implement-spec-pr-retro-and-glossary-md | 2026-10-05 갱신 | v1.3 의도 |
| BMAD-METHOD | https://github.com/bmad-code-org/BMAD-METHOD/releases/tag/v6.12.0 | v6.12.1 `bda3c59` | 스킬 축소, walkthrough |
| garrytan/gstack | https://raw.githubusercontent.com/garrytan/gstack/main/CHANGELOG.md | 1.91.68.0 `20eb620` | 모델별 프롬프트 감사, 실행·읽기·추정 구분 |
| open-gsd/gsd-core | https://github.com/open-gsd/gsd-core/releases | v1.16.0, `651bd2f` | 자동 선택 opt-in |
| github/spec-kit | https://github.com/github/spec-kit/releases | v1.1.3 `0443760` | 선택형 preset, `.github/skills` 유지보수 스킬 |
| buildermethods/agent-os | https://github.com/buildermethods/agent-os/commit/e892e61 | v3.0.0 | 실질 변화 없음 |
| Geoffrey Litt | https://geoffreylitt.com/2026/07/02/understanding-is-the-new-bottleneck | 2026-07-02 | 참여를 위한 이해, explain-diff·quiz |
| Simon Willison | https://simonwillison.net/guides/agentic-engineering-patterns/ | 2026-02-23 시작 | 원본에서 추출한 walkthrough, interactive explanation |
| Addy Osmani | https://addyosmani.com/blog/comprehension-debt/ | 2026-03-14 | comprehension debt |
| Margaret-Anne Storey | https://arxiv.org/abs/2603.22106 | v4 2026-04-06 | triple debt |
| Anthropic | https://www.anthropic.com/research/AI-assistance-coding-skills | 2026-01-29 | 숙련도 17% 차이 |
| Kaufman 외 | https://arxiv.org/pdf/2607.08885 | 2026-07 | 설명과 과신 |
| Bansal 외 | https://arxiv.org/abs/2006.14779 | CHI 2021 | 설명과 수용 증가 |
| Anthropic docs | https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5, …/prompting-claude-fable-5-1, …/prompting-claude-sonnet-5-5 | 날짜 표기 없음 | 결과 우선, 조기 종료, 추론 재현 거부 |
| Claude Code docs | https://code.claude.com/docs/en/skills, …/artifacts, …/output-styles | 날짜 표기 없음 | 프로젝트 스킬 경로, artifact 사용 조건 |
| OpenAI docs | https://developers.openai.com/api/docs/guides/prompt-guidance, https://learn.chatgpt.com/docs/build-skills | 날짜 표기 없음 | 승인 전 검토 가능한 결과, 지시 민감도, `.agents/skills` |
| 교차 리뷰 | [evidence/2026-10-11-human-understanding/](evidence/2026-10-11-human-understanding/) | codex-cli 0.162.1, gpt-6-astra | 채택·기각 조정 |
