# 모델별 프롬프팅 가이드 — Claude 5 세대 · GPT-5.6 세대

작성: 2026-07-24. 공식 문서 조사 기반 종합. 원문 스냅샷은 [`references/prompting/`](evidence/model-prompting-guide/)에 verbatim 보존 — 세부 지침이 필요하면 스냅샷을 읽는 것이 우선이고, 이 문서는 "어떤 모델에 어떤 태도로 프롬프팅할지"의 지도다.

## TL;DR — 두 진영이 수렴한 방향

| 원칙 | Claude 5 (Anthropic) | GPT-5.6 (OpenAI) |
| --- | --- | --- |
| 스캐폴딩 제거 | 옛 모델용 과잉-prescriptive 지시·스킬은 품질을 **떨어뜨림** — 제거 권장 | 얇은(leaner) 프롬프트가 평가점수 +10~15%, 토큰 -41~66% |
| 절차 대신 목표 | 의도·이유를 주면 성능↑ ("Give the reason, not only the request") | "모든 단계를 지정할 필요 없음" — 의도 추론 강화 |
| reasoning 조절 | 프롬프트가 아니라 `output_config.effort` | 프롬프트가 아니라 `reasoning_effort` |
| 마이그레이션 시 effort | Opus의 `xhigh` → Fable 5는 `high`로 **한 단계 하향**해 비교 | 기존 설정에서 **한 단계 하향**해 비교 |
| 여전히 명시할 것 | 경계(boundaries)·승인 지점·성공 기준·의도 | domain context·hard constraints·approval boundaries·success criteria |

공통 결론: **"무엇을 어떻게 할지"를 열거하는 프롬프트에서, "목표·제약·경계"만 짧게 주고 모델을 신뢰하는 프롬프트로.** 이 레포 AGENTS.md의 "매 요청마다 상시 필요한 내용만" 원칙과 같은 방향이다.

---

## Claude Fable 5 (`claude-fable-5`) / Mythos 5

> 원문: [`anthropic-prompting-claude-fable-5.md`](evidence/model-prompting-guide/anthropic-prompting-claude-fable-5.md)

**포지셔닝·용도**: Opus 위 신규 티어. 최고난도 추론, 수 시간짜리 장기 자율(agentic) 실행, 엔터프라이즈 딜리버러블(재무분석·법률검토·대규모 리팩터). Fable↔Mythos 차이는 안전 분류기뿐(Mythos는 승인 조직 한정). 입력 $10/출력 $50 per MTok — Opus보다 비싸므로 "기본 업그레이드 경로"가 아니라 명시적 선택.

**API 구조 변화 (프롬프팅 전제)**
- thinking 상시 ON — `thinking` 파라미터 자체를 제거 (`disabled`도 400 에러). raw chain-of-thought는 절대 반환 안 됨(`display:"summarized"`로 요약만).
- `max_tokens`가 thinking을 포함 — 기존 값 상향 필요.
- assistant prefill, `temperature`/`top_p`/`top_k` 미지원(400).
- 거부 시 HTTP 200 + `stop_reason:"refusal"` — `fallbacks` 파라미터(beta)로 Opus 4.8 자동 재시도 권장.

**프롬프팅이 달라지는 점**
1. **De-prescribe**: "Skills developed for prior models are often too prescriptive for Claude Fable 5 and can degrade output quality." 행동 열거 대신 짧은 지시 하나. 마이그레이션 후 옛 스캐폴딩 제거 A/B 필수.
2. **목표·의도 템플릿**: `"I'm working on [큰 과제] for [대상]. They need [결과의 용도]. With that in mind: [요청]."`
3. **긴 턴이 기본**: 단일 요청 수 분, 자율 실행 수 시간. timeout·스트리밍·비동기 체크인 구조로 harness 재설계.
4. **subagent 적극 위임**: 억제 프롬프트 제거, 대신 "언제 위임할지" 명시. self-critique보다 fresh-context 검증 subagent가 우수.
5. **신규 함정 — reasoning 재현 금지**: "show your thinking / reflect" 류 지시는 `reasoning_extraction` 거부 유발. 기존 프롬프트·스킬 감사 필요.
6. **제거할 옛 스캐폴딩**: 진행상황 업데이트 강제("N번 툴콜마다 요약") — 내장됨 / effort를 프롬프트로 지시 — 파라미터로 / prefill 출력 유도 — structured outputs로.

**공식 권장 스니펫 (상황별, verbatim은 스냅샷 참고)**
- 과잉 계획 억제: "When you have enough information to act, act. …"
- 불필요한 리팩터 억제(고effort): "Don't add features, refactor, or introduce abstractions beyond what the task requires. …"
- 간결성: "Lead with the outcome. … readability matters more."
- 자율 파이프라인 조기종료 방지: "You are operating autonomously. … End your turn only when the task is complete or you are blocked on input only the user can provide."
- 진행상황 날조 방지: "Before reporting progress, audit each claim against a tool result from this session. …"
- 컨텍스트 불안 방지: "You have ample context remaining. …" (harness가 남은 토큰 카운트다운을 노출하지 않는 게 우선)

**Effort**: 기본 `high`로 시작. **"Fable 5의 낮은 effort가 이전 모델 xhigh를 능가하는 경우가 많다"** — Opus에서 xhigh 쓰던 워크로드는 high로 하향이 표준. `xhigh`는 가장 capability-sensitive한 것만, 일상 작업은 `medium`/`low`. effort를 대화 중간에 바꾸면 prompt cache 무효화 — 워크로드 단위로 고정.

---

## Claude Opus 4.8 (`claude-opus-4-8`)

> 원문: migration-guide의 "Migrating to Opus 4.8" 섹션 (스냅샷 미보관 — [migration-guide.md](https://platform.claude.com/docs/en/about-claude/models/migration-guide.md))

**포지셔닝·용도**: "최신 모델로 업그레이드" 요청의 기본 타겟. 코딩·agentic의 주력. Fable 5로 가는 관문이기도 함(같은 토크나이저, 같은 API 표면).

**프롬프팅 요점**
- 4.7 대비 breaking change 없음 — 모델 ID 교체 + 프롬프트 재튜닝만.
- **narration이 많아짐**: 진행상황 강제 스캐폴딩은 제거하고, 과하면 silence-default 지시("Default to silence between tool calls. …").
- **더 신중해져 질문이 늘어남**: 사소한 결정은 알아서 하도록 자율성 부여 지시("For minor choices, pick a reasonable option and note it rather than asking").
- **툴 트리거가 보수적**: search-first 지시 + 각 툴 description에 "언제 호출할지"(trigger condition)를 명시하면 확실한 lift.
- 장기 작업은 **첫 턴에 완전한 스펙**을 주고 high effort로.
- 코드리뷰 harness: "high-severity만 보고" 지시를 문자 그대로 따라 recall이 떨어져 보임 — coverage-first로 찾고 필터링은 다운스트림 분리.

**Effort**: 코딩·agentic은 `xhigh`(Claude Code 기본), intelligence-sensitive는 최소 `high`, `max`는 정확성이 비용보다 중요할 때만. `xhigh`/`max`에선 `max_tokens` ≥ 64K.

---

## Claude Sonnet 5 (`claude-sonnet-5`)

> 원문: [`anthropic-prompting-claude-sonnet-5.md`](evidence/model-prompting-guide/anthropic-prompting-claude-sonnet-5.md) — Fable 5와 동일 구조의 전용 페이지 존재

**포지셔닝·용도**: 비용 대비 코딩·agentic 주력 — 이전 Opus급 품질을 Sonnet 가격($3/$15, 한시 $2/$10)에. 기존 Sonnet 4.6 프롬프트가 **out-of-the-box로 잘 동작** — 큰 재작성 불필요.

**Fable 5와의 결정적 차이**
- adaptive thinking이 기본 ON이지만 **`thinking:{type:"disabled"}`로 끌 수 있음** (Fable 5는 불가). 단, thinking off 시 툴 사용이 소극적이 되므로 low effort + adaptive를 먼저 시도.
- **신규 토크나이저: 같은 텍스트가 ~30% 더 많은 토큰** — Sonnet 4.6용 `max_tokens`·컨텍스트 예산·비용 대시보드 전부 재베이스라인. (Fable 5는 Opus와 동일 토크나이저라 이 이슈 없음.)
- sampling 파라미터 비기본값 400 — Sonnet 계열엔 이번이 신규 제약. tone·다양성은 프롬프트로.

**프롬프팅 요점**
- **리터럴한 지시 이행**: 지시를 다른 항목에 조용히 일반화하지 않음 — 넓게 적용하려면 범위 명시("Apply this formatting to every section, not just the first one"). 구조화 추출·파이프라인에 유리.
- **verbosity는 복잡도에 비례** — 길이를 고정하고 싶으면 명시. 부정 지시보다 **긍정 예시**(원하는 간결함을 보여주는)가 효과적.
- 진행상황 업데이트 내장 — 강제 스캐폴딩 제거.
- 디자인/프론트엔드가 한 스타일로 수렴 — 구체 스펙을 주거나 "빌드 전 4개 방향 제안 후 선택" 패턴(temperature 부재의 다양성 대체 수단).
- 코드리뷰 harness: Opus 4.8과 동일한 coverage-first 권장.

**Effort**: 기본 `high` 유지. 최난도 코딩·agentic만 `xhigh`. 비용절감은 `medium`. 크로스매핑: **Sonnet 5 medium ≈ Sonnet 4.6 high, Sonnet 5 high ≈ Sonnet 4.6 max**. 저effort에서 얕은 추론이 보이면 프롬프트 우회가 아니라 effort 상향이 정답.

---

## Claude Haiku 4.5 (`claude-haiku-4-5`)

전용 프롬프팅 가이드 없음. 저지연·고볼륨 단순 작업(분류·짧은 추출) 전용. effort 파라미터 대상 아님. 200K 컨텍스트 / 64K 출력. 구세대 파라미터(`budget_tokens` 등)가 아직 유효한 라인이므로 5세대 프롬프팅 원칙을 역적용하지 말 것.

---

## GPT-5.6 세대 — Sol / Terra / Luna (Codex 포함)

> 원문: [`openai-latest-model-gpt-5.6.md`](evidence/model-prompting-guide/openai-latest-model-gpt-5.6.md) (Model guidance — 프롬프팅 best practices 포함; `prompt-guidance-gpt-5p6` URL과 동일 문서) · [`openai-reasoning-effort.md`](evidence/model-prompting-guide/openai-reasoning-effort.md) · [`openai-codex-models.md`](evidence/model-prompting-guide/openai-codex-models.md)

**명명 체계 주의**: "GPT-5.6-Codex"는 없다. 2026-07 GPT-5.6 세대부터 코딩 전용 라인(`gpt-5.1-codex`~`gpt-5.3-codex`)이 폐지되고, 숫자=세대 / **Sol·Terra·Luna**=역량 티어가 ChatGPT와 Codex를 공통 구동한다.

**티어별 용도**
| 모델 | 용도 |
| --- | --- |
| `gpt-5.6-sol` (별칭 `gpt-5.6`, 플래그십) | 복잡한 코딩·computer use·심층 리서치. 모호하고 어렵고 고가치인 작업, 복잡한 코드 변경, 다듬어진 문서 |
| `gpt-5.6-terra` | 일상 workhorse — Sol만큼의 깊이가 불필요할 때 |
| `gpt-5.6-luna` | 정답 형태가 명확한 고볼륨 반복 — 추출·분류·변환·구조화 요약 |

**프롬프팅이 달라지는 점**
1. **Leaner prompts**: 반복 지시·예시 제거, tool description 단순화. 공식 내부 테스트: 얇은 시스템 프롬프트가 평가점수 +10~15%, 총 토큰 -41~66%, 비용 -33~67%.
2. **의도 추론 강화**: "you often do not need to prescribe every step."
3. **기본이 더 간결**(GPT-5.5 대비): 광범위한 "Be concise" 지시는 불필요하거나 역효과 가능.
4. **여전히 명시할 것**: domain context / hard constraints / **approval boundaries**(각 요청이 승인하는 행동 수준 — 정의해두면 불필요하게 멈추지 않음) / success criteria.
5. 코딩(구 Codex 가이드의 유효 원칙): "autonomous senior engineer"로 취급 — 방향만 주면 스스로 컨텍스트 수집·계획·구현·테스트. **preamble/업프론트 플랜 강제 지시 제거**(도중 멈춤의 원인). 병렬 툴콜 활용, 잔 패치 thrashing 금지.
6. **`phase` 보존**: assistant 출력의 `phase` 필드(commentary/final_answer)를 대화 이력에 그대로 유지해야 성능 저하를 막는다 (reasoning 문서).
7. **Safeguards**: 출력 생성 중 cyber/bio 오용 분류기가 동기 검토 — 정당한 보안 작업(코드리뷰·취약점 연구)에도 간헐적 지연·차단 가능. 개별 사용자 대상 앱은 `safety_identifier` 전송 권장.

**Reasoning effort** (`reasoning_effort`: none/low/medium/high/xhigh/max, API 기본 `medium`)
- 원칙: **"필요한 결과를 내는 가장 낮은 단계를 쓰라."** effort는 품질 복구의 주 수단이 아니라 **튜닝 노브** — 목표·제약·출력 계약을 먼저 주고, 중간 단계를 지정하지 말 것.
- `none`: latency-critical, reasoning 무용(음성·단순 분류) — 코딩 부적합
- `low`: 속도·비용 우선, 가벼운 tool-use
- `medium`: 기본. 대화형·agentic 코딩 올라운드
- `high`: 어려운 추론·복잡 디버깅·깊은 planning
- `xhigh`: 심층 리서치·장시간 비동기 agentic — eval로 정당화될 때만
- `max`: quality-first 최상급 — 도입 전 xhigh와 비교
- 마이그레이션: 기존 effort를 baseline으로 **한 단계 낮춰** 비교 (더 적은 토큰으로 품질 유지되는 경우 많음).
- Codex CLI 노출: Low/Medium(기본)/High/Extra High/Max — 앱의 "Extra High" = API `xhigh`.

---

## Effort 권장 요약표

| 워크로드 | Fable 5 | Opus 4.8 | Sonnet 5 | GPT-5.6 |
| --- | --- | --- | --- | --- |
| 일상 코딩·agentic | high (기본) | xhigh | high (기본) | medium (기본) |
| 최난도·장기 자율 | high→xhigh | xhigh~max | xhigh | high~xhigh |
| 비용 절감 | medium/low | high→medium (eval 후) | medium | 한 단계 하향 후 비교 |
| 저지연·단순 | low | low | low | low/none |

공통: 신모델 전환 시 **기존 effort에서 한 단계 낮춰 시작**하고 eval로 올린다. Claude는 effort 변경이 prompt cache를 무효화하므로 워크로드 단위 고정.

## 출처 (2026-07-24 확인)

**Anthropic** — 스냅샷 보유: [Prompting Claude Fable 5](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5) · [Prompting Claude Sonnet 5](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-sonnet-5) · [Effort](https://platform.claude.com/docs/en/build-with-claude/effort.md) / 스냅샷 없음: [Migration guide](https://platform.claude.com/docs/en/about-claude/models/migration-guide.md) · [Introducing Fable 5](https://platform.claude.com/docs/en/about-claude/models/introducing-claude-fable-5.md) · [Steering thinking](https://platform.claude.com/docs/en/build-with-claude/thinking-steering-and-cost) · [발표 블로그](https://www.anthropic.com/news/claude-fable-5-mythos-5)

**OpenAI** — 스냅샷 보유: [Model guidance / GPT-5.6 Prompting Guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-5.6) (두 URL — `latest-model?model=gpt-5.6` · `prompt-guidance-gpt-5p6` — 이 byte-identical 동일 문서) · [Reasoning models](https://developers.openai.com/api/docs/guides/reasoning) · [Codex Models](https://developers.openai.com/codex/models) / 참고(구버전): [Codex Prompting Guide](https://developers.openai.com/cookbook/examples/gpt-5/codex_prompting_guide) (gpt-5.3-codex 대상, 코딩 원칙은 유효) / 미확인: [발표 페이지](https://openai.com/index/gpt-5-6/) (fetch 403 — 공식 docs로 교차검증)

주의: OpenAI 가격 수치는 3자 매체 출처라 이 문서에서 제외했다. 인용 필요 시 공식 pricing 페이지 확인.

