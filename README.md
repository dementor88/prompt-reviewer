# Prompt Reviewer

A skill for [OpenCode](https://opencode.ai) that reviews and scores prompts for LLM effectiveness before execution.

**Stop executing vague prompts.** Review them first, get a score, see the gaps, and refine before you waste tokens.

## Features

- **Quick Mode** (`prompt-review:`): Fast 5-dimension scoring (Clarity, Specificity, Measurability, Completeness, Testability)
- **Robust Mode** (`robust-prompt-review:`): Full 3-tier framework (CO-STAR + LUPES + 2026 Checklist)
- **Bilingual**: Auto-detects Korean/English and outputs in the same language
- **Actionable**: Provides refined prompt suggestions with projected score improvement
- **Review-Only**: Analyzes prompts without executing them

## Installation

### OpenCode

```bash
git clone https://github.com/dementor88/prompt-reviewer.git ~/.config/opencode/skills/prompt-reviewer
```

### Claude Code

```bash
git clone https://github.com/dementor88/prompt-reviewer.git ~/.claude/skills/prompt-reviewer
```

### Verify Installation

```bash
ls ~/.config/opencode/skills/prompt-reviewer/skills/prompt-reviewer/SKILL.md
```

## Usage

### Quick Mode (5 Dimensions)

```
prompt-review: build a login page with OAuth
```

**Output:**
- Score out of 100
- Visual dimension breakdown
- Top gaps with impact analysis
- Refined prompt suggestion

### Robust Mode (Full Framework)

```
robust-prompt-review: implement a real-time notification system for our e-commerce platform
```

**Output:**
- Score out of 100
- CO-STAR breakdown (Context, Objective, Style, Tone, Audience, Response)
- LUPES validation (Quality, Structure, Validity, Risk)
- 2026 Checklist completion
- Critical gaps and refined prompt

## Scoring Dimensions (Quick Mode)

| Dimension | Weight | What It Measures |
|-----------|--------|------------------|
| **Clarity** | 20% | Unambiguous? Single interpretation? |
| **Specificity** | 25% | Tech stack, constraints, file paths? |
| **Measurability** | 20% | Success criteria defined? |
| **Completeness** | 20% | Edge cases, errors, validation? |
| **Testability** | 15% | Verification steps? Expected outputs? |

## Example

**Input:**
```
prompt-review: build a login page
```

**Output:**
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

**Projected Score**: ~82/100 (improvement: +47 points)
```

## Red Flags (What Scores Poorly)

| Dimension | Red Flags |
|-----------|-----------|
| Clarity | "make it good", "improve this", "fix the thing" |
| Specificity | No technology, framework, file locations |
| Measurability | "user-friendly", "fast", "efficient" without metrics |
| Completeness | No error handling, edge cases, validation |
| Testability | No verification commands, expected outputs |

### Korean Red Flags

| Korean | Issue |
|--------|-------|
| "좋게 해줘" | No criteria |
| "잘 만들어줘" | No requirements |
| "알아서 해줘" | No constraints |
| "깔끔하게", "빠르게" | Subjective |

## Robust Mode Frameworks

### Tier 1: CO-STAR (40% weight)
GovTech Singapore's prompt framework:
- **C**ontext - Background, system state
- **O**bjective - Clear goal, specific task
- **S**tyle - Output format, code style
- **T**one - Formality, technical depth
- **A**udience - Who is this for?
- **R**esponse - Expected output format

### Tier 2: LUPES (35% weight)
Meta-validation checks:
- **Q**uality - Well-formed, clear structure
- **S**tructure - Logical flow, no contradictions
- **V**alidity - Achievable within constraints
- **R**isk - Error handling, edge cases mentioned

### Tier 3: 2026 Checklist (25% weight)
Engineering completeness:
- [ ] Success Criteria
- [ ] Output Contract
- [ ] Constraints
- [ ] Inputs
- [ ] Examples
- [ ] Verification
- [ ] Iteration plan
- [ ] Context

## Behavior

**CRITICAL:** This skill is **review-only**. It will:
1. Analyze the prompt you provide
2. Output a score and gaps
3. Suggest improvements
4. **STOP** - It will NOT execute the prompt

The prompt is the patient. The skill is the doctor. Diagnose only. Do not operate.

## Contributing

Contributions welcome! Please open an issue or PR.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Author

Created by [dementor88](https://github.com/dementor88)

---

**Remember:** A well-crafted prompt saves hours of back-and-forth. Review before you execute.
