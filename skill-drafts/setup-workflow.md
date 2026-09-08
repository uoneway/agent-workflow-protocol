# setup-workflow — 합의용 초안

> 상태: P-0020~P-0024에 맞춘 재설계 초안. 영어 실행본과 새 형태의 실제 적용 검증이 남아 있다.

## 목적

한 레포가 Agent Workflow Protocol을 따르도록 **최소한의 상시 규칙만 각인**한다. 프로토콜 전문이나 현재 상태를 복사하지 않는다. 코드·git·worktree·PR·issue에서 복원 가능한 정보는 setup 산출물로 만들지 않는다.

setup은 사람의 이해를 문서 묶음으로 미리 만들어 주는 절차가 아니다. `orient`가 live source와 보존된 의도를 조합해 현재 설명을 만들 수 있도록, 코드 밖에 있어야 하는 원천과 라우팅만 정리한다.

## 호출 조건

- 사용자가 레포에 워크플로우를 적용하거나 갱신해 달라고 요청한다.
- 다른 스킬이 자동 선행 조건으로 setup을 요구하지 않는다. 마커가 없어도 `orient`, `align`, `workflow-research`, `cold-read`, `upstream-scout`는 각자의 범위에서 실행할 수 있다.
- 기존 레포 이식은 문서 삭제까지 자동 승인하지 않는다. 중복 후보와 권위 이동안을 보여주고 사용자가 정한 범위만 바꾼다.

## 성공 조건

1. `AGENTS.md`에 최신 프로토콜 마커가 한 번만 존재한다.
2. 제품 방향이 코드 밖에 있을 때만 `VISION.md`가 하나의 권위 원천으로 존재한다.
3. 수기 현재 상태 문서나 코드 설명 사본을 새로 만들지 않는다.
4. 기존 문서의 권위·중복·수명이 명확하고, 승인하지 않은 내용을 덮어쓰지 않는다.
5. 마커 밖의 사용자 내용과 선택하지 않은 머신 전역 설정은 그대로다.

## Pre-flight

동봉한 `scripts/detect-repo-state.sh [repo-root]`로 git, 기존 마커, AGENTS/CLAUDE, 문서 후보, remote, 머신 라우팅 상태를 확인한다. 출력은 질문을 줄이는 관찰값이지, 문서를 일괄 분류하거나 삭제하는 명령이 아니다.

다음 사실은 필요할 때 추가로 직접 확인한다.

- 제품 목적·대상·경계가 코드나 기존 기준 문서 밖에 있는가
- 기존 `PROJECT_STATE`, roadmap, architecture, ADR, backlog가 어떤 고유 진실을 소유하는가
- 이슈 트래커가 실제로 사용되는가
- 반복 탐색 비용이나 비국소적 경계가 이미 관찰됐는가

## 사용자와 맞출 선택

서로 영향을 주는 질문은 한 묶음으로 제시하고 각 항목에 추천을 붙인다.

- 기존 문서별 처리: 유지 / 고유 진실을 VISION·decision·AGENTS로 이동 / 생성 뷰로 전환 / 삭제 후보. 삭제는 별도 승인을 받는다.
- `VISION.md`: 코드 밖의 제품 목적·대상·경계·kill condition이 있으면 생성 또는 기존 문서를 권위 원천으로 지정한다. 없으면 만들지 않는다.
- 후보 저장소: 실제로 보존할 미착수 후보가 있고 이슈 트래커가 없을 때만 `BACKLOG.md`를 만든다.
- 머신 전역 라우팅: 최초 한 번만 전역 적용 또는 레포 로컬 전용을 고르게 한다. 상태는 `${XDG_CONFIG_HOME:-~/.config}/link-workflow/setup-state.json`의 `{"placement":"global"}` 또는 `{"placement":"local-only"}`로 기록한다. 파일이 없거나 값이 다르면 미결정으로 취급하고, 사용자가 재설정을 요청하지 않으면 유효한 선택을 다시 묻지 않는다.

`ARCHITECTURE.md`, `GLOSSARY.md`, decision record, research note, workstream 문서는 setup 기본 생성물이 아니다. 프로토콜의 실제 생성 조건이 생긴 뒤 해당 작업에서 만든다.

## 신규 적용

1. 기존 `AGENTS.md`를 보존하며 `templates/agents-block.md`를 렌더링해 append한다. 최신 프로토콜 변경 ID와 마커 본문 해시를 기록한다.
2. 합의 결과 필요할 때만 `VISION.md` 또는 `BACKLOG.md`를 만든다. 빈 placeholder는 만들지 않는다.
3. Claude Code가 사용되고 `CLAUDE.md`가 없을 때만 얇은 `@AGENTS.md` 포인터를 제안한다. 기존 파일은 자동 교체하지 않는다.
4. 전역 적용을 선택한 경우에만 `templates/global-routing.md`를 감지된 도구의 전역 지침에 append한다: Claude Code는 `~/.claude/CLAUDE.md`, Codex는 `~/.codex/AGENTS.md`. 두 도구가 있으면 둘 다 같은 라우팅을 받는다. 기존 마커 밖 내용은 보존한다. 로컬 전용을 선택하면 전역 파일을 바꾸지 않는다.
5. `scripts/marker-hash.sh check`와 직접 읽기로 마커가 유일하고, 링크가 유효하며, 마커 밖 내용이 보존됐는지 확인한다.

## 갱신

먼저 정확한 start/end 마커가 각각 하나인지와 저장된 hash를 검사한다. 중복·고아·역순 마커나 hash 누락·불일치가 있으면 no-op으로 간주하지 말고 diff와 복구 선택을 제시한다. 구조와 무결성이 확인된 뒤 기존 마커의 `P-NNNN`과 프로토콜 마지막 ID를 비교한다.

1. 같으면 문서 구조 변경을 만들지 않고 종료한다.
2. 다르면 사이의 변경 이력을 요약하고, 현재 레포에 영향을 주는 변경만 설명한다.
3. 저장된 hash와 현재 마커 본문이 다르면 사용자 수정을 diff로 보여주고 처리 방향을 확인한다.
4. 승인 후 마커 안쪽만 최신 템플릿으로 교체한다. 마커 밖 내용과 기존 프로젝트 문서는 자동 수정하지 않는다.
5. 폐기된 `PROJECT_STATE`·kickoff/promote 규칙 같은 구형 산출물이 있으면 마이그레이션 후보로만 보고한다. 고유 진실의 이동과 삭제는 사용자가 이 레포 적용 범위로 승인한 경우에만 수행한다.

## 레포 마커

실제 본문은 `skills/setup-workflow/templates/agents-block.md`가 소유한다. 마커에는 다음만 둔다.

- 원문 링크와 적용 변경 ID
- Orient → Align → Act → Reorient 요약
- live source 우선, 영속 문서 판정, 작업 계약 조건
- `orient`, `align`, 조건부 위성 스킬 라우팅

프로토콜 전문, 문서 읽기 순서, 현재 프로젝트 상태, 이슈 트래커 종류, 결정 연번은 넣지 않는다.

## 머신 전역 라우팅

`templates/global-routing.md`는 프로토콜을 모든 레포에 강제하지 않는다. 로컬 마커가 있으면 그것을 우선하고, 사용자가 워크플로우나 관련 스킬을 명시적으로 요청했을 때만 이 레포를 setup할 수 있다고 알린다. 스킬 실행 자체를 setup 여부로 막지 않는다.

## 동봉물

```
skills/setup-workflow/
├── scripts/
│   ├── detect-repo-state.sh
│   └── marker-hash.sh
└── templates/
    ├── agents-block.md
    ├── global-routing.md
    └── BACKLOG.md
```

`BACKLOG.md`는 조건부 템플릿이다. `PROJECT_STATE.md`와 `lint-decision-logs.sh`는 P-0020~P-0022에서 기본 상태·전역 결정 연번 모델이 폐기되어 동봉물에서 제거했다.

## 금지

- 프로토콜 전문이나 수기 현재 상태를 대상 레포에 복사하기
- 코드·설정·git이 소유하는 목록을 reference 문서로 역생성하기
- 필요가 확인되지 않은 문서와 폴더를 미리 만들기
- 마커 밖 사용자 지침이나 기존 문서를 승인 없이 수정·삭제하기
- setup 부재를 다른 스킬 실행의 hard dependency로 만들기
- 이식된 레포 명단을 중앙에서 수기 추적하기

## 승격 전 검증

- 신규 레포와 문서가 많은 brownfield 레포에 각각 forward test
- 마커 신규/동일 버전/구버전/사용자 수정/중복 케이스 검증
- `VISION.md`와 `BACKLOG.md`가 조건을 만족할 때만 생성되는지 확인
- 구형 `PROJECT_STATE`가 있는 레포에서 고유 진실을 잃지 않고 마이그레이션을 제안하는지 확인
- 영어 `SKILL.md` 재저작과 skill validator 통과

이 초안 이전의 6단계·상태 문서 중심 설계와 실제 persquad 이식 결과는 `skill-drafts/00-README.md`, 프로토콜 P-0011·P-0014~P-0017·P-0020~P-0024, `upstream-sources.md`에 방향 변화 기록으로 남긴다.
