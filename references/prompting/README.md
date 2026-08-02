# references/prompting — 공식 프롬프팅 문서 원문 스냅샷

Anthropic·OpenAI **공식 문서의 verbatim 스냅샷**을 진행 중 검토의 입력으로 둔다. AGENTS.md의 "업스트림 텍스트를 복붙하지 않는다" 규칙은 스킬·프로토콜로의 흡수에 대한 것이고, 이 디렉토리는 원문 확인용이다. 검토가 끝나면 필요한 결론은 권위 문서에 직접 남기고 스냅샷은 삭제한다.

규칙:

- 각 파일 상단 frontmatter(`source` / `fetched` / `note`)를 유지한다.
- 본문을 편집·요약·번역하지 않는다. 갱신은 전체 재-fetch로만.
- OpenAI 스냅샷은 raw HTML→Markdown 변환본이다. UI 크롬은 제거했고, 다국어 코드탭은 기본 표시 탭 하나만 남는다(동일 예시의 언어판 차이일 뿐 내용 손실 없음).
- 이 원문 스냅샷은 진행 중 검토의 입력일 뿐이다. 스킬에 반영할 때는 사상만 흡수하고, 검토가 끝나면 필요한 결론을 권위 문서에 직접 남긴다.

| 파일 | 대상 |
| --- | --- |
| `anthropic-prompting-claude-fable-5.md` | Claude Fable 5 프롬프팅 가이드 |
| `anthropic-prompting-claude-sonnet-5.md` | Claude Sonnet 5 프롬프팅 가이드 |
| `anthropic-effort.md` | effort 파라미터 가이드 |
| `openai-latest-model-gpt-5.6.md` | GPT-5.6 Model guidance — 프롬프팅 best practices 포함. `…/latest-model?model=gpt-5.6`과 `…/prompt-guidance-gpt-5p6` 두 URL이 **동일 문서**(byte-identical 확인)라 하나만 보관 |
| `openai-reasoning-effort.md` | reasoning effort 가이드 |
| `openai-codex-models.md` | Codex 모델 선택 가이드 |
