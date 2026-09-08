# orient — 한국어 의사결정 기록

> **상태:** 확정됨. 실행 기준은 [`skills/orient/SKILL.md`](../skills/orient/SKILL.md)다.

## 현재 결정

Orient는 신규 작업 선택과 중단 작업 재개 모두에서 현재 방향과 실제 상태를 복원한다. `AGENTS.md`와 조건부 `VISION.md`로 목적과 규칙을 확인한 뒤, git·branch·worktree·PR·issue·session·검증 결과를 직접 조사한다. 관련 작업 계약과 decision record, 코드만 필요에 따라 읽는다.

결과는 목표, 확인된 상태, 마지막 합의 뒤 변화, 남은 판단, 추천 다음 행동을 담은 소비성 reorientation이다. 파일로 저장하지 않는다. 접근하지 못한 원천과 추론을 사실과 구분한다.

## resume에서 바뀐 이유

P-0016의 `resume`은 고정 문서 읽기 순서와 workstream 중심 handoff를 사용했다. persquad-next에서는 main의 `PROJECT_STATE.md`가 S1.0을 가리키는 동안 활성 worktree에서 S1.1~S1.3 구현이 완료돼 있었다. 문서 소유 규칙을 지켜도 main의 수기 상태가 현재 작업을 보여주지 못했다.

P-0020과 P-0021은 현재 상태의 권위를 live source로 옮겼다. 이에 따라 Resume은 과거 문서를 재주입하는 절차에서 신규·재개의 공통 진입인 Orient로 확장됐다. 사람에게 현재를 설명한다는 P-0012의 목적은 유지한다.
