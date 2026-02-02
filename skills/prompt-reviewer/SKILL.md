---
name: prompt-reviewer
description: Review and score prompts for LLM effectiveness. Triggered by "prompt-review:" (quick) or "robust-prompt-review:" (full framework). Scores 0-100 with dimension breakdown.
---

## CRITICAL: Review-Only Mode

**When `prompt-review:` or `robust-prompt-review:` is detected, this skill OVERRIDES normal behavior.**

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
| `robust-prompt-review:` | Full | 3-tier framework (CO-STAR + LUPES + 2026 Checklist) |

## Language Detection

Auto-detect: >50% Korean characters → Korean output. Same triggers work for both languages.

### Korean Labels (한국어 출력)

When Korean is detected, use these labels in output:

**Quick Mode (5 Dimensions)**:

| English | 한국어 |
|---------|--------|
| Clarity | 명확성 |
| Specificity | 구체성 |
| Measurability | 측정가능성 |
| Completeness | 완전성 |
| Testability | 검증가능성 |

**Robust Mode (CO-STAR)**:

| English | 한국어 |
|---------|--------|
| Context | 맥락 |
| Objective | 목표 |
| Style | 스타일 |
| Tone | 어조 |
| Audience | 대상 |
| Response | 응답형식 |

**Robust Mode (LUPES)**:

| English | 한국어 |
|---------|--------|
| Quality | 품질 |
| Structure | 구조 |
| Validity | 유효성 |
| Risk | 리스크 |

---

## Quick Mode: 5 Dimensions

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

---

## Robust Mode: 3-Tier Framework

### Hierarchy

| Tier | Framework | Weight | Role |
|------|-----------|--------|------|
| 1 | **CO-STAR** | 40% | Primary evaluation |
| 2 | **LUPES** | 35% | Meta-validation |
| 3 | **2026 Checklist** | 25% | Engineering completeness |

### Tier 1: CO-STAR (Primary)

GovTech Singapore's framework. Score each 0-10.

| Dimension | Measures |
|-----------|----------|
| **C**ontext | Background, system state |
| **O**bjective | Clear goal, specific task |
| **S**tyle | Output format, code style |
| **T**one | Formality, technical depth |
| **A**udience | Who is this for? Skill level? |
| **R**esponse | Expected output format, length |

### Tier 2: LUPES (Validation)

Pass/fail checks.

| Dimension | Pass If |
|-----------|---------|
| **Q**uality | Well-formed, clear structure |
| **S**tructure | Logical flow, no contradictions |
| **V**alidity | Achievable within constraints |
| **R**isk | Error handling, edge cases mentioned |

### Tier 3: 2026 Checklist (Supplementary)

Check presence of each:

- [ ] Success Criteria
- [ ] Output Contract
- [ ] Constraints
- [ ] Inputs
- [ ] Examples
- [ ] Verification
- [ ] Iteration plan
- [ ] Context

### Score Calculation

```
Final = (CO-STAR_avg × 0.40) + (LUPES_pass% × 0.35) + (Checklist% × 0.25)
```

---

## Output Format

Score visualization (10-char bars):

```
┌─────────────────────────────────────────┐
│ Dimension     ████████░░  80%           │
└─────────────────────────────────────────┘
```

Bar mapping: `█` = 10%, `░` = empty

### Quick Mode Output

```
## Prompt Review

**Original:** > [prompt]

### Score: X/100

[5 dimension bars with percentages]

### Gaps

| Dimension | Issue | Impact |
|-----------|-------|--------|
| [dimension] | [specific problem] | [consequence] |

### Suggested Refinement

**Improved Prompt:**

> [Original prompt with all gaps addressed]

**Changes Made:**
- **[Dimension]**: [what was added/clarified]
- **[Dimension]**: [what was added/clarified]

**Projected Score**: ~XX/100 (improvement from XX to XX)
```

### Robust Mode Output

```
## Robust Review

**Original:** > [prompt]

### Score: X/100

[3 tier summary bars: CO-STAR, LUPES, 2026]

### CO-STAR Breakdown

| Dimension | Score | Note |
|-----------|-------|------|
| Context | X/10 | [assessment] |
| Objective | X/10 | [assessment] |
| Style | X/10 | [assessment] |
| Tone | X/10 | [assessment] |
| Audience | X/10 | [assessment] |
| Response | X/10 | [assessment] |

### LUPES Validation

| Dimension | Status | Note |
|-----------|--------|------|
| Quality | ✓/✗ | [assessment] |
| Structure | ✓/✗ | [assessment] |
| Validity | ✓/✗ | [assessment] |
| Risk | ✓/✗ | [assessment] |

### 2026 Checklist

- [x/blank] Success Criteria
- [x/blank] Output Contract
- [x/blank] Constraints
- [x/blank] Inputs
- [x/blank] Examples
- [x/blank] Verification
- [x/blank] Iteration plan
- [x/blank] Context

### Critical Gaps

[Top 3 issues with highest impact]

### Suggested Refinement

**Improved Prompt:**

> [Full refined prompt addressing all framework gaps]

**Framework Improvements:**
- **CO-STAR**: [Added context, clarified objective, specified response format]
- **LUPES**: [Addressed risk, improved structure]
- **2026 Checklist**: [Added success criteria, verification steps]

**Projected Score**: ~XX/100 (target: ≥75)
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
8. **Show score first** - Score before details (users want the number).
9. **Limit gaps to top 3-5** - Don't overwhelm; focus on highest impact.

---

## Example (Quick Mode)

**Input**: `prompt-review: build a login page`

**Output**:

```
## Prompt Review

**Original:** > build a login page

### Score: 35/100

Clarity       ████░░░░░░  40%  (8/20)
Specificity   ██░░░░░░░░  20%  (5/25)
Measurability ███░░░░░░░  30%  (6/20)
Completeness  ████░░░░░░  40%  (8/20)
Testability   ████░░░░░░  40%  (6/15)

### Gaps

| Dimension | Issue | Impact |
|-----------|-------|--------|
| **Specificity** (20%) | No tech stack, file locations | Agent must guess framework |
| **Measurability** (30%) | No success criteria | Cannot verify completion |
| **Completeness** (40%) | No error handling, security | Missing critical flows |

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

**Changes Made:**
- **Specificity**: Added React 18, TypeScript, file path
- **Measurability**: Added success criteria with test command
- **Completeness**: Added error handling, validation, security (httpOnly cookie)

**Projected Score**: ~82/100 (improvement: +47 points)
```
