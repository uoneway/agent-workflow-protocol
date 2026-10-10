# Agent Workflow Protocol — 2026-10 개정 제안 (리뷰용 초안)

대상 레포: /Users/hangil/Project/agent-workflow-protocol (권위 문서 AGENT_WORKFLOW_PROTOCOL.md, skills/, skill-rationales/, upstream-sources.md).
현재 기준: git 97bfa84, 프로토콜 P-0031.

## 사용자 의도

AI가 계속 발전하므로 "AI가 어떻게 더 잘할지"보다 "사람이 어떻게 쉽고 정확하게 정보를 습득·이해·판단하고 방향을 제시할지"가 더 중요해진다. 모든 프로젝트에 적용될 워크플로우이므로 더 덜어낼 것과 사람의 역할 변화를 반영하고 싶다. 설명이 필요하면 md 외에 HTML 등도 쓰되 언제 적절한지 가이드가 필요하다.

## 근거 요약 (2026-10-11 확인)

업스트림:
- superpowers v6.3 → v7.0: 중간 check-in·plan reviewer 제거, plan은 코드 대신 결정만. v7 brainstorming: 이해한 의도를 되말하며 추측은 추측으로 표시, 조사 후 작업 크기 결정, fresh subagent "builder check"가 만들 것을 바꾸는 질문만 한 라운드로, 사용자가 소유하고 싶은 "어떻게 만들지" 선택을 물음.
- mattpocock/skills v1.3: `pr`(가장 작은 시각화로 요약, before/after 증거, merge danger = one-way/two-way door + blast radius), `retro`(기계적 규칙은 lint/hook/CI로), merge-conflict 스킬 삭제("harness concern"). "Writing code got cheap. Reading it did not."
- BMAD v6.11–6.12: 핵심 스킬 14→8, 효과 없던 cynical reviewer 페르소나 제거, 조사 후 ceremony 결정, `bmad-walkthrough`("Human attention is scarce", 블록 단위 사람 리뷰).
- gstack 1.58→1.91: Opus 5.5 감사로 step-by-step scaffolding과 CRITICAL/MUST 제거, 모델 출시마다 프롬프트 재감사, checkpoint 항목을 run/read/assumed로 태그.
- gsd-core: 오히려 게이트 증가, 자동 선택을 opt-in으로(사람이 실제로 결정하게).
- spec-kit: ceremony를 선택형 preset으로. agent-os: 변화 없음.

연구:
- Litt(2026-07) "understanding is for participating", explain-diff·quiz·micro-world. Willison: linear walkthrough(코드는 명령으로 원본에서 추출), interactive HTML explanations. Osmani comprehension debt. Storey triple debt(technical/cognitive/intent).
- Anthropic RCT(2026-01, n=52): AI 위임 그룹 숙련도 17% 낮음, 질문·설명 요청한 사람은 손실 적음.
- 반증: Kaufman 2026(n=86) 잘못된 LLM 출력 판별 49%, 설명은 전체적으로 효과 없고 질 낮은 설명은 정확도↓ 확신↑. Bansal CHI 2021 설명이 정오 무관하게 수용 증가.
- 스킬 경로: Claude Code 프로젝트 `.claude/skills/`, Codex 프로젝트 `.agents/skills/`(`.codex/skills` 아님), 둘 다 symlink 지원. 같은 이름이면 Claude는 user-level 우선, Codex는 둘 다 노출.

최신 모델 프롬프팅 가이드 (§P, 2026-10-11 확인; 현재 모델 Claude Fable 5.1/Opus 5.5/Sonnet 5.5/Haiku 5.5, OpenAI gpt-6-astra/gpt-6.1-sol/gpt-6-luna):
- 결과 보고: 양사 모두 결과 먼저, 마지막 메시지는 단독으로 읽혀야 함(무엇을 찾고·했고·다음은). 불필요한 결론 요약·장황한 서술 회피. Fable 5.1은 서식을 덜 쓰므로 옛 anti-markdown 지시 제거 권장.
- Rich format: Claude Code 문서는 "terminal text is the wrong medium"일 때 artifact(주석 diff, 대시보드, 대안 나란히, 타임라인) 권장, 기본값은 아님(토큰 비용).
- 제거할 scaffolding: "think carefully" 류, 응답에 추론을 써내라는 지시(`reasoning_extraction` 거부 유발; "답의 짧은 설명이나 수행한 행동 요약"은 허용), "tool call 최소화" 류.
- 저작: Astra는 AGENTS.md·스킬 지시에 더 민감 → 감사하고 "사용자 지시가 스킬보다 우선" 명시. 스킬 description은 핵심 용도·트리거를 앞에, 언제 트리거하지 말지도. 짧고 정확한 AGENTS.md가 낫고 규칙은 반복 실수 관찰 후 추가.
- 함정: 과잉 질문·조기 종료("Shall I apply this?"), Astra는 질문 성향↑ → 승인된 일을 먼저 끝내고 구체적 검토 가능한 결과를 만든 뒤에만 승인 요청. 가역적·저영향 변경에 구현을 거울처럼 따라 하는 테스트 쓰지 않기. Sonnet 5.5 범위 확장·검증 생략 보고 경향.

## 제안

### A. 사람의 역할 (설명은 늘리지 않고 검증 가능하게)
- A1 설명 근거 기준: 주장마다 실행 확인 / 읽어서 확인 / 추정 구분, 코드 인용은 원본에서 추출, 산문보다 실행 결과·스크린샷·데모 우선, 확인 못한 것 명시.
- A2 Reorient를 판단 우선으로: 사람이 내릴 판단 → 되돌리기 어려운 변경과 영향 범위 → 증거 → 나머지 설명.
- A3 Align 종료를 의도 되말하기로: 다섯 항목 체크 대신 짧은 이해 playback(추측 표시) + 사람이 소유하고 싶은 "어떻게 만들지" 선택 확인.
- A4 이해 유지 영역 선언: 사람이 깊이 이해하고 싶은 영역(예: 도메인 모델, 과금, 보안 경계)을 한 번 정해 VISION/AGENTS에 둔다. 그 영역 변경에만 walkthrough·예측/퀴즈 같은 이해 확인을 붙이고, 나머지는 증거 요약으로 충분.
- A5 사람이 그만둘 것: 진행 관찰, 매 단계 승인, 알파벳순 diff 읽기, agent 작성 PR 설명을 사실로 수용.
- A6 설명 매체 선택 가이드 (신규):
  - 사다리: 대화 텍스트 → Markdown 표·Mermaid → 정적 HTML(다이어그램·차트) → 인터랙티브 HTML(조작·단계 재생·예측).
  - HTML이 적절할 때: 공간·관계 구조(아키텍처, 데이터 흐름, 상태 전이), 시간·단계를 조작하며 봐야 할 때(알고리즘, 마이그레이션 순서), 다차원 비교(대안 trade-off, before/after UI), 측정 데이터·차트, 사람이 예측·퀴즈로 이해를 확인할 때, 대화 밖의 다른 사람과 공유할 때.
  - 텍스트로 충분할 때: 결과와 검증이 몇 문단에 끝남, 판단이 하나, 코드 자체를 보면 되는 변경, 터미널에서 즉시 소비.
  - 규칙: 소비성 산출물이며 기본적으로 레포에 커밋하지 않는다(임시 위치 또는 도구의 artifact). 판단에 필요한 핵심 요약은 항상 대화에 텍스트로 남겨 HTML 없이도 결정 가능하게 한다. 사실·코드는 원본에서 추출하고 A1 등급을 표시. 외부 공개(호스팅·공유 링크)는 권한 경계. 생성 수단은 도구에 맡긴다.

### B. 덜어낼 것
- B1 AGENTS 마커 블록 12줄 → 5~6줄: 현재 모델의 기본 행동(검증 비례, 멈출 때 근거, 리서치 보존 상세 등)을 반복하는 문장 제거. 남길 것: live source 우선/수기 상태 금지, 복원 불가능한 것만 기록, 맥락 이동 시 작업 계약, 사람 판단 지점과 설명 기준, 스킬 라우팅.
- B2 cold-read 스킬 폐기 → align 안 한 줄(fresh subagent가 만들 것을 바꾸는 질문만 한 라운드).
- B3 변경 이력 표 셀을 1~2문장으로, 긴 맥락은 rationale로.
- 유지: setup-workflow의 hash·감지 스크립트(실제 소유권 보호).

### C. 스킬 배치
- upstream-scout → 레포 로컬: `.agents/skills/upstream-scout/` 원본 + `.claude/skills/upstream-scout` symlink. 전역 라우팅·link-skills 대상·전역 사본에서 제거.
- workflow-research → 전역 유지(모든 레포 AGENTS 블록이 참조).
- explain 신설(A1·A2·A4·A6 실행본): Litt explain-diff, mattpocock pr, BMAD walkthrough 수렴. B2와 합쳐 스킬 수 유지.

### D. 운영 수정 (프로토콜 무관)
- link-skills.sh가 P-0027 이후 옛 매니페스트 `.link-workflow-managed`를 읽지 못해 배포 정지: kickoff/promote/resume 잔존, orient·setup-workflow 미배포, 나머지 4개 내용 불일치, Codex는 8월 복사본.
- upstream-sources.md의 gstack 저장 지점 날짜 오류(v1.58.5는 2026-06-21).

### E. 프롬프팅 가이드에서 온 추가 정리
- 스킬·마커 블록에서 "추론을 보여라" 식 표현 점검(explain 스킬은 "결과의 짧은 설명·행동 요약·증거"로 표현).
- 모든 실행 스킬에 사용자 지시 우선 한 줄, description에 트리거와 비트리거 앞세우기.
- Reorient 마지막 메시지 단독 가독성 + 승인 요청은 검토 가능한 결과 뒤에.

## 리뷰어에게 묻는 것
1. 이 방향에서 틀렸거나 과한 것, 빠진 것은? 특히 A4(이해 유지 영역)와 explain 스킬 신설이 새 ceremony가 되지 않을지.
2. B1·B2 제거가 여러 모델(Claude/GPT)에서 위험한 보호 장치를 없애는지.
3. A6 HTML 가이드의 기준이 적절한지, 더 나은 판단 기준은?
4. GPT-6 세대 관점에서 스킬 배치(C)와 Codex 경로(`.agents/skills`)가 맞는지.
5. 우선순위 추천.
