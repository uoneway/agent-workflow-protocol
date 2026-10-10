# GPT-6 Astra 스킬·프롬프트 재검토: 원문 메모

조사일: 2026-09-15. 질문: OpenAI의 새 지침이 워크플로우와 스킬 설계에 주는 재검토 기준은 무엇인가? 범위는 아래 블로그의 주장 확인이며, 개별 스킬의 효과 검증은 포함하지 않는다.

## 원문에서 확인한 주장

- 스킬 설명은 짧고 구체적인 적용 조건을 제시해야 한다. 과도한 설명과 중복 트리거는 선택을 방해한다.
- 여러 경로를 가진 스킬은 진입 문서를 작게 두고 필요한 참고 자료로 안내한다.
- 세세한 절차가 발전한 모델의 판단을 제한할 수 있으며, 여러 모델이 쓰는 저장소에서는 차이를 고려한다.
- 상시 지침의 일괄 문서 읽기와 반복 검증 요구를 재검토한다. 문서는 작업 관련성에 따라 연결한다.
- 경계는 허용된 작업의 지속을 막지 않도록 구체화한다. 완료 조건과 탐색 종료점을 명시한다.

위 내용은 공급자의 권고이며 이 저장소에서 측정한 결과가 아니다. [원문](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra)

## 해석과 결정 영향

이 저장소에서는 각 지침을 남길 때 보호하는 의도·경계와 관측 가능한 실패를 설명할 수 있는지 확인하는 리뷰 기준으로 쓸 수 있다. 단순한 글자 수 절감이나 특정 모델에 대한 신뢰만으로 규칙을 제거할 근거는 부족하다. 구체적인 수정은 저장소 조사와 리뷰 합의 뒤에 판단한다.

## 한계와 출처

원문은 실무 권고를 제시하지만 이 저장소에 대한 비교 실험이나 개선 폭을 제공하지 않는다. 다른 모델에서도 같은 효과가 난다고 단정할 수 없다. 원문 전체를 복제하거나 보존하지 않았다.

- Eric Provencher, OpenAI Developers, [Rethinking skills and prompts for GPT-6 Astra](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra), 게시 2026-09-11, 확인 2026-09-15. 참조 범위: Better skills, Up-to-date AGENTS.md, Decision boundaries, Persistence.

## 저장소 대조와 제안 — 미확정

기준: 2026-09-15, git `e48923f`. 아래는 프로토콜, 여섯 실행 스킬, 배포용 템플릿과 `agents/openai.yaml`을 읽고 도출한 해석이다. 실제 모델 행동 실험은 하지 않았다. 실행 지침 변경이나 채택 결정이 아니다.

현재 P-0020~P-0022의 live source 우선, 필요할 때만 문서 생성, 맥락 이동 시 작업 계약, 조건부 감사는 유지할 가치가 있다. 개선의 중심은 단계 추가보다 기존 지시의 적용 조건과 종료 조건을 정확히 하는 것이다.

| 대상·근거 | 발생 가능한 문제 | 제안 |
| --- | --- | --- |
| [align](../skills/align/SKILL.md), 마지막 문단 | 이미 구현까지 위임받아도 시작 선택을 다시 요구한다 | 설계 상담만 요청했으면 합의안으로 종료하고, 실행까지 요청했으면 중요한 미결정이 없는 한 이어서 실행한다. 기존 승인의 범위가 바뀌었을 때만 다시 묻는다. |
| align, 질문 rounds와 외부 작용 직전 승인 | 질문 절차가 의무화되거나 같은 승인을 반복할 수 있다 | 목표·증거·경계·위임·재논의 조건을 현재 대화에서 먼저 복원하고 빠진 중요한 판단만 질문한다. 새 권한과 이미 받은 권한을 구분한다. |
| [orient](../skills/orient/SKILL.md), 읽기 목록 | 좁은 작업 재개에도 전체 프로젝트 탐색으로 커질 수 있다 | 다음 판단에 영향을 주는 원천부터 읽고, 그 판단이 가능하면 끝낸다. 대화의 합의는 의도 원천으로 유지하되 현재 상태 주장은 live source로 확인한다. |
| [workflow-research](../skills/workflow-research/SKILL.md), evidence 보존 상세·마지막 문단 | 작은 조사에도 보존 절차가 전부 로드되고 Align의 전제 도전이 중복될 수 있다 | 질문·1차 출처·사실/해석·결정형 synthesis는 본문에 유지한다. 원본 보존 조건이 충족될 때만 세부 참고 문서를 읽게 하고, 전제 도전은 같은 결정에서 이미 했으면 반복하지 않는다. |
| [cold-read](../skills/cold-read/SKILL.md), fresh agent와 pass 조건 | 독립 실행 환경이 없거나 사소한 미지가 남으면 감사가 작업 전체를 붙잡을 수 있다 | 시작 차단은 안전한 첫 행동을 고를 수 없는 누락으로 한정한다. 독립 agent가 없으면 그 한계를 밝히고 자기 점검을 독립 감사로 표시하지 않는다. 필수 감사일 때만 해당 handoff를 보류한다. |
| [setup-workflow](../skills/setup-workflow/SKILL.md), 신규·갱신·전역 경로 | 모든 실행에서 서로 다른 경로의 지시가 함께 읽힌다 | 감지 결과로 신규·동일 버전·갱신·손상 복구 경로를 선택하는 얇은 진입부를 둔다. 마커 무결성, 관리 영역 밖 보존, 문서 삭제와 전역 설정의 권한 경계는 유지한다. 명시적 갱신 요청과 추가 범위 승인은 구분한다. |
| [upstream-scout](../.agents/skills/upstream-scout/SKILL.md), 버전 문턱·아이디어 세 개 | 특정 patch 검토 요청도 버전 문턱에 막히거나 가치 없는 제안을 채울 수 있다 | 버전 문턱은 정기 탐지에만 적용한다. 명시적 검토 요청은 지정 범위를 검토한다. 아이디어는 가치 있는 것만 최대 세 개, 없으면 없음으로 보고한다. |

### 공통 실행 규칙의 후보

아래 문구는 이 저장소에 맞춘 새 제안이며 업스트림 인용이 아니다.

> 기존 대화에서 확정된 결과·경계·위임을 다음 행동의 출발점으로 삼는다. 실행까지 요청받았고 중요한 미결정이 없다면 합의 범위의 작업을 계속한다. 새 승인이나 사용자 판단이 필요한 부분만 분리하고 독립적인 작업은 진행한다. 상담·리뷰 요청의 완료는 근거 있는 답변이며, 구현 요청의 완료는 합의된 동작과 그에 필요한 검증까지다.

> 검증은 바뀐 동작, 실패 영향, 레포 필수 검사에 맞춘다. 필요한 검증이 통과하면 새로운 변경·실패·미해결 위험이 없는 한 확대하거나 반복하지 않는다. 지침 때문에 멈출 때는 근거 문구와 아직 필요한 판단을 밝히고, 명시적 요구와 자신의 해석을 구분한다.

Reorient의 여섯 항목은 매번 출력할 양식보다 설명 재료로 해석하는 편이 좋다. 작은 결과는 결과와 검증만, 중요한 방향 변화는 선택 이유·경계·다음 판단까지 설명한다.

### 스킬 선택 문구의 후보

길이 자체보다 적용 조건을 좁히는 것이 목적이다. 아래는 방향 예시이며 확정 실행본이 아니다.

- orient: `Recover current direction and relevant live state when resuming work or choosing what to do next.`
- align: `Resolve material questions about outcomes, boundaries, and delegation when the user asks to align or choose an approach.`
- workflow-research: `Investigate external evidence for a decision and preserve decision-relevant findings.`
- cold-read: `Audit whether a handoff supports a fresh start when an independent context check is needed.`
- setup-workflow: `Install or update this workflow in a repository when the user requests setup or migration.`
- upstream-scout: `Check tracked upstream changes during scheduled detection or an explicit upstream review.`

setup와 research 외 짧은 단일 목적 스킬은 억지로 reference 파일로 분해할 필요가 없다. front matter를 바꾸면 `agents/openai.yaml`의 설명과 기본 요청도 같이 대조한다. 특히 scout의 `prepare a digest`는 전용 digest 체계를 제거한 P-0025 이후의 용어와 맞추는 편이 명확하다.

### 적용 순서와 반증 조건

1. Align의 실행 재확인과 반복 승인을 먼저 조정한다. P-0022와 align rationale에 남은 시작 선택 경계 중 무엇을 대체하는지 명시해야 한다. 달라진 전제는 현재 요청 자체에 실행 위임이 이미 포함될 수 있다는 점이다.
2. 읽기·검증의 충분 조건을 보강하고 scout의 정기 탐지와 명시적 검토를 구분한다.
3. setup와 research의 조건부 참고 경로를 분리한다. P-0026의 소유권 보호와 P-0024의 증거 보존 책임은 유지한다.

변경 전후 같은 요청·모델·권한·레포 상태로 비교한다. 실행까지 요청한 작은 수정, 상담만 요청한 설계, 좁은 작업 재개, 승인된 배포 준비, 손상된 setup 마커, patch 지정 검토를 사례로 삼는다. 불필요한 승인 횟수·읽은 범위·반복 검증·완료 여부와 함께 무단 실행·중요 경계 누락도 확인한다. 후자가 늘면 조건을 다시 좁힌다. 여러 모델에 배포하는 스킬이므로 Astra에서의 결과를 다른 실행 모델의 결과로 일반화하지 않는다.

프로토콜·스킬·변경 이력은 수정하지 않았다. 이 메모는 리뷰를 위한 근거이며 채택·기각은 후속 합의에서 확정한다.

## 2026-09-15 후속 결정

사용자가 위 개선안의 적용을 요청했다. P-0028~P-0030에서 기존 실행 위임 인정, 읽기·검증의 충분 조건, 조건부 참고 경로, scout 명시적 검토 범위를 채택했다. P-0024의 증거 보존과 P-0026의 소유권 보호는 유지한다. 특정 모델에 대한 신뢰만으로 보호 장치를 제거하는 안과 짧은 단일 목적 스킬의 일괄 분할은 기각했다. 위 미확정 제안과 당시 한계는 조사 시점의 기록으로 보존하며, 최신 실행 기준은 프로토콜과 스킬이다.
