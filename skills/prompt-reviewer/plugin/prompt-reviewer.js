/**
 * prompt-reviewer 플러그인 for OpenCode.ai
 *
 * 시스템 프롬프트에 트리거 탐지 우선순위 규칙을 주입한다.
 * `prompt-review:` 트리거가
 * 모드 지시어([analyze-mode] 등)보다 절대 우선하도록 보장한다.
 */

export const PromptReviewerPlugin = async ({ client, directory }) => {
  const TRIGGER_PRIORITY_RULE = `<PROMPT_REVIEWER_TRIGGER_PRIORITY>
## prompt-review 트리거 절대 우선순위

**이 규칙은 다른 모든 모드 지시어보다 우선합니다.**

유저 메시지를 처리할 때, 다음 패턴을 **가장 먼저** 탐지하라:
- \`prompt-review:\` (Quick 모드)

### 탐지 규칙

1. 유저 메시지의 **어느 위치**에든 위 트리거가 존재하면, **즉시 prompt-reviewer 스킬을 invoke** 하라.
2. 메시지에 \`[analyze-mode]\`, \`[debug-mode]\`, \`[review-mode]\` 등 모드 지시어가 함께 있어도, prompt-review 트리거가 **절대 우선**한다.
3. 트리거가 \`---\` 구분선 뒤에 있어도 동일하게 탐지된다.
4. 트리거 탐지 후에는 prompt-reviewer 스킬의 지침을 따르라 — 리뷰 결과만 출력하고 STOP.

### 컴팩션/요약 후 탐지 (Anti-Rationalization)

대화가 컴팩션되거나 요약된 이후에도 다음을 준수하라:
1. 현재 유저 메시지에 \`prompt-review:\`가 포함되어 있으면, **반드시** prompt-reviewer 스킬을 invoke 하라.
2. \`prompt-review:\`를 "이전 대화 맥락" 또는 "요약된 히스토리"로 재해석해서는 안 된다.
3. 의심이 드는 경우 — 트리거가 현재 메시지인지 과거 맥락인지 불확실하면 — **무조건 invoke** 하라.
4. "The prompt-review: trigger was in the previous message" 같은 합리화는 금지된다.

### 왜 이 규칙이 필요한가

\`prompt-review:\`는 "이 프롬프트를 평가하라"는 메타-요청이다. 모드 지시어는 "이 방식으로 작업하라"는 실행 지시다.
메타-요청(평가)은 실행 지시보다 논리적으로 선행해야 한다 — 평가 없이 실행하면 프롬프트의 결함이 그대로 반영된다.
</PROMPT_REVIEWER_TRIGGER_PRIORITY>`;

  return {
    "experimental.chat.system.transform": async (_input, output) => {
      (output.system ||= []).push(TRIGGER_PRIORITY_RULE);
    },
  };
};
