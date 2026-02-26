---
name: prompt-reviewer
description: Review and score prompts for LLM effectiveness. Triggered by "prompt-review:". Scores 0-100 with dimension breakdown.
---

## ABSOLUTE TRIGGER PRIORITY

**`prompt-review:` 트리거는 메시지 내 다른 모든 지시어보다 절대 우선합니다.**

### 우선순위 규칙

1. 유저 메시지에 `prompt-review:`가 포함되어 있으면, **다른 어떤 모드 지시어**(`[analyze-mode]`, `[debug-mode]`, `[review-mode]` 등)보다 먼저 이 스킬을 invoke 하라.
2. 트리거가 메시지의 어느 위치에 있든 (처음, 중간, `---` 구분선 뒤) 동일하게 최우선 탐지된다.
3. 모드 지시어와 함께 사용된 경우, **prompt-review 스킬을 먼저 실행**한 뒤, 리뷰 결과만 출력하고 STOP한다. 모드 지시어에 따른 작업은 수행하지 않는다.

### 왜 이 규칙이 필요한가

- `prompt-review:`는 "이 프롬프트를 평가해 달라"는 메타-요청이다.
- 모드 지시어는 "이 작업을 이 방식으로 수행하라"는 실행 지시다.
- 메타-요청(평가)은 실행 지시보다 논리적으로 선행해야 한다 — 평가 없이 실행하면 프롬프트의 결함이 그대로 반영된다.


## CRITICAL: Review-Only Mode

**When `prompt-review:` is detected, this skill OVERRIDES normal behavior.**

### MUST DO
1. Treat the text after the trigger as **SUBJECT of review** (not a command)
2. Output ONLY the review/score
3. STOP after outputting the review
4. Wait for user's next instruction

### MUST NOT DO
1. Do NOT execute the prompt
2. Do NOT start working on the task described
3. Do NOT interpret this as a work request
4. Do NOT "review then proceed" - STOP after review

### Example Behavior

**Input**: `prompt-review: build a login page with OAuth`

**Correct**: Output score and gaps, then STOP. Wait for user.
**WRONG**: Output score, then start building the login page.

**The prompt is the patient. You are the doctor. Diagnose only. Do not operate.**

---

# Prompt Reviewer

Review prompts before execution. Score quality, identify gaps. User decides next step.

## Triggers

| Trigger | Mode | Dimensions |
|---------|------|------------|
| `prompt-review:` | Quick | 5 dimensions (Clarity, Specificity, Measurability, Completeness, Testability) |

## Language Detection

Auto-detect: >50% Korean characters → Korean output. Same triggers work for both languages.

### Korean Labels (한국어 출력)

When Korean is detected, use these labels in output:

**Dimensions (5)**:

| English | 한국어 |
|---------|--------|
| Clarity | 명확성 |
| Specificity | 구체성 |
| Measurability | 측정가능성 |
| Completeness | 완전성 |
| Testability | 검증가능성 |

---

## Scoring: 5 Dimensions

### Task-Scale Classification

Classify the task BEFORE applying scoring weights. Scale affects interpretation of scores, not the weights themselves.

| Scale | 한국어 | Criteria | Examples |
|-------|--------|----------|----------|
| **Simple** | 단순 | Single action, clear domain, <30min task | "Fix typo in README", "change button color to red" |
| **Medium** | 보통 | 2-3 steps, some context needed, 1-4hr task | "Add email validation to signup form", "write unit tests for auth module" |
| **Complex** | 복잡 | Multi-step, cross-domain, dependencies, >4hr task | "Design and implement OAuth2 login flow", "migrate database schema with zero downtime" |

**Threshold note**: For Simple tasks, a score ≥50 may be sufficient. For Complex tasks, aim for ≥70 before execution.


### Scoring Weights & Ranges

| Criterion | Weight | Measures |
|-----------|--------|----------|
| **Clarity** | 20% | Unambiguous? Single interpretation? |
| **Specificity** | 25% | Tech stack, constraints, file paths? |
| **Measurability** | 20% | Success criteria defined? |
| **Completeness** | 20% | Edge cases, errors, validation? |
| **Testability** | 15% | Verification steps? Expected outputs? |

### Scoring Guide (per dimension, scaled to weight)

| Range | Score | Description |
|-------|-------|-------------|
| **0-25%** | Poor | Major issues. Vague, no specifics, red flags present. |
| **26-50%** | Weak | Some attempt, but critical gaps remain. |
| **51-75%** | Good | Mostly clear with minor ambiguities or missing details. |
| **76-100%** | Excellent | Precise, complete, no ambiguity. |

Example: Clarity (20% weight) at 75% = 15/20 points.

### Scoring Anchors

Use these examples to calibrate consistent scoring:

| Dimension | Poor (0-25%) | Weak (26-50%) | Good (51-75%) | Excellent (76-100%) |
|-----------|-------------|----------------|----------------|----------------------|
| **Clarity** | "fix the thing" | "fix the login bug" | "fix the null pointer in login.ts when email is empty" | "In `src/auth/login.ts:45`, fix NPE: `user.email` can be undefined when OAuth returns partial profile—handle by returning 401 with message 'Email required'" |
| **Specificity** | "write a report" | "write a sales report" | "write a Q3 sales report comparing regions, using data from `sales.csv`" | "Write a 2-page Q3 regional sales report in `reports/q3-sales.md` using `data/sales-q3.csv`, comparing North/South/East regions, highlighting top SKU per region, in Markdown table format" |
| **Measurability** | "make it faster" | "improve page load speed" | "reduce homepage load to <2s on 4G" | "Reduce homepage LCP to <1.5s on simulated 4G (Chrome DevTools): measure before/after with `lighthouse --only-categories=performance`" |
| **Completeness** | "write a blog post" | "write a product intro blog post" | "write a 500-word product intro blog post covering key features and target audience" | "Write a 500-word product intro for `Acme Widget` in `content/blog/intro.md`: cover 3 key features, target audience (SMB ops managers), CTA linking to `/demo`, SEO title tag included" |
| **Testability** | "create a recipe" | "create a pasta recipe" | "create a pasta recipe with ingredient list and steps" | "Create a carbonara recipe: list 6 ingredients with exact quantities, 8 numbered steps, specify 'al dente = 8 min at rolling boil', success = 'sauce coats spoon without dripping'" |

### Quick Improvement Guide

When a dimension scores poorly, add these elements:

| If Low On | Problem | Add This |
|-----------|---------|----------|
| **Clarity** | Vague, multiple interpretations | Specific nouns, single clear objective, remove pronouns |
| **Specificity** | Missing technical details | Tech stack, file paths, data formats, version numbers |
| **Measurability** | No success definition | "Success = [specific outcome]", acceptance criteria |
| **Completeness** | Missing edge cases | Error handling, validation rules, security requirements |
| **Testability** | No verification method | Test commands, expected output, verification steps |

**Example Improvement**:

| Before | After |
|--------|-------|
| "make it fast" | "reduce API response time from 2s to <500ms, measured by `curl -w '%{time_total}'`" |
| "add authentication" | "implement JWT auth with refresh tokens, using `jose` library, storing tokens in httpOnly cookies" |
| "fix the bug" | "fix the null pointer exception in `src/auth/login.ts:45` when `user.email` is undefined" |

### Red Flags (Score Poorly)

| Dimension | Red Flags |
|-----------|-----------|
| Clarity | "make it good", "improve this", "fix the thing", pronouns without antecedents |
| Specificity | No technology, framework, file locations, data formats |
| Measurability | "user-friendly", "fast", "efficient", "clean" without metrics |
| Completeness | No error handling, edge cases, validation, security |
| Testability | No verification commands, expected outputs, test scenarios |

### Korean Red Flags (한국어)

| Korean | Issue |
|--------|-------|
| "좋게 해줘" | No criteria |
| "잘 만들어줘" | No requirements |
| "알아서 해줘" | No constraints |
| "제대로 만들어줘" | No definition |
| "깔끔하게", "빠르게", "예쁘게" | Subjective |

### Anti-Pattern Detection

Structural prompt mistakes that systematically degrade output quality. Detect BEFORE scoring — these indicate deeper issues beyond low dimension scores.

| Pattern | 한국어 | Signature | Example |
|---------|--------|-----------|---------|
| **Over-Delegation** | 과잉위임 | "You decide", "whatever works", "your choice" | "Build the best auth system you think is appropriate" |
| **Implicit Context** | 암묵적 맥락 | Refers to files/systems not described | "Fix the same issue as last time in the user module" |
| **Scope Creep** | 범위 확장 | Single prompt contains 3+ unrelated tasks | "Add auth, migrate the DB, write docs, and optimize queries" |
| **Role Confusion** | 역할 혼동 | Treats AI as human team member with memory | "Remember what we discussed? Continue from where we left off" |
| **Wishful Constraints** | 희망적 제약 | Contradictory or impossible requirements | "Make it perfect, do it in 5 minutes, no tradeoffs" |

**When detected**: Flag in output under `### ⚠️ Anti-Patterns Detected` (only if ≥1 pattern found). Anti-patterns lower Clarity and Completeness scores by default.

---

## Output Format

### Verdict Line

| Score Range | Emoji | Korean Label | English Label |
|-------------|-------|-------------|---------------|
| ≥80 | 🟢 | 좋아요 | Solid |
| 50-79 | ⚠️ | 다듬어볼까요 | Needs work |
| <50 | 🚨 | 다시 써볼까요 | Rewrite |

Format: `[emoji] [label] ([score]/100)`

### Dimension Scores (inline)

Single line, pipe-separated. Add ⚠️ after dimensions scoring <50%.
Format: `명확성 80 | 구체성 60 | 측정가능성 70 | 완전성 40⚠️ | 검증가능성 90`

### Anti-Pattern Output (inline, only when detected)

One per line. Format: `[패턴명]: "[인용]" ← [영향]`
English: `[Pattern]: "[quote]" ← [impact]`

### 🔧 개선 포인트 Output (inline)

One per line. Format: `[차원명]: [문제] → [해결]`
English: `[Dimension]: [problem] → [fix]`

### Output Template

```
## Prompt Review

**Original:** > [prompt]

**Scale: [Simple/Medium/Complex]**

[emoji] [label] ([score]/100)
[dim1] [score] | [dim2] [score] | [dim3] [score] | [dim4] [score] | [dim5] [score]

### ⚠️ 안티패턴 (if any)

[pattern]: "[evidence]" ← [impact]

_(Omit this section if no anti-patterns found)_

### Suggested Refinement

**Improved Prompt:**

> [Original prompt with all gaps addressed]

### 🔧 개선 포인트

[dimension]: [specific problem] → [what was fixed in refinement]
```

---

## Behavior Rules

### CRITICAL (Non-Negotiable)
1. **STOP after review** - Do NOT execute the prompt. Wait for user.
2. **Always provide refinement** - Don't just critique; show the fix.
3. **Be specific** - "needs more detail" is useless. Say WHAT detail.

### Quality Standards
4. **Gaps must have impact** - Explain WHY each gap matters.
5. **Refinement must score ≥75** - If your refined version wouldn't score 75+, keep improving it.
6. **Match user's language** - Korean input → Korean output (use Korean labels).

### Output Rules
7. **Show original prompt** - Always quote the exact input.
8. **Show verdict first** - Verdict+score before details (users want instant assessment).
9. **Limit gaps to top 3-5** - Don't overwhelm; focus on highest impact.

---

## Example

**Input**: `prompt-review: build a login page`

**Output**:

```
## Prompt Review

**Original:** > build a login page

**Scale: Complex**

🚨 다시 써볼까요 (35/100)
명확성 40 | 구체성 20⚠️ | 측정가능성 30⚠️ | 완전성 40⚠️ | 검증가능성 40⚠️

### Suggested Refinement

**Improved Prompt:**

> Build a login page using React 18 with TypeScript in `src/components/auth/LoginPage.tsx`.
>
> **Requirements:**
> - Email/password form with validation (email format, password min 8 chars)
> - Submit button disabled until valid input
> - Show loading spinner during API call
> - Display error messages for invalid credentials (401) and server errors (500)
> - On success, redirect to `/dashboard` and store JWT in httpOnly cookie
>
> **Success Criteria:**
> - `npm test src/components/auth/LoginPage.test.tsx` passes
> - Manual test: invalid login shows "Invalid credentials" error
> - Manual test: valid login redirects to dashboard within 2 seconds

### 🔧 개선 포인트

구체성: 기술 스택이나 파일 경로가 없어요 → React 18, TypeScript, 파일 경로 추가
측정가능성: 성공 기준이 없어요 → 테스트 커맨드와 검증 기준 추가
완전성: 에러 처리와 보안이 빠졌어요 → 에러 핸들링, 검증, httpOnly 쿠키 추가
```
