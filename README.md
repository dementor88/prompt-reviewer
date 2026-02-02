<div align="center">

# 🎯 Prompt Reviewer

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![OpenCode](https://img.shields.io/badge/OpenCode-Skill-purple.svg)](https://opencode.ai)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-orange.svg)](https://claude.ai)

**Stop executing vague prompts. Review them first.**

Get a score • See the gaps • Refine before you waste tokens

[Quick Start](#-quick-start) •
[Features](#-features) •
[Usage](#-usage) •
[Scoring](#-scoring-dimensions) •
[Contributing](#-contributing)

</div>

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🚀 **Quick Mode** | Fast 5-dimension scoring in seconds |
| 🔬 **Robust Mode** | Full 3-tier framework (CO-STAR + LUPES + 2026 Checklist) |
| 🌐 **Bilingual** | Auto-detects Korean/English |
| 🎯 **Actionable** | Provides refined prompts with projected improvements |
| 🛡️ **Review-Only** | Analyzes without executing—safe by design |

---

## 📦 Quick Start

### One-Line Install

<table>
<tr>
<td><b>OpenCode</b></td>
<td>

```bash
curl -fsSL https://raw.githubusercontent.com/dementor88/prompt-reviewer/main/install.sh | bash -s -- opencode
```

</td>
</tr>
<tr>
<td><b>Claude Code</b></td>
<td>

```bash
curl -fsSL https://raw.githubusercontent.com/dementor88/prompt-reviewer/main/install.sh | bash -s -- claude
```

</td>
</tr>
</table>

### Manual Installation

<details>
<summary><b>📂 OpenCode</b></summary>

```bash
# Clone to skills directory
git clone https://github.com/dementor88/prompt-reviewer.git \
  ~/.config/opencode/skills/prompt-reviewer

# Verify installation
ls ~/.config/opencode/skills/prompt-reviewer/skills/prompt-reviewer/SKILL.md
```

</details>

<details>
<summary><b>📂 Claude Code</b></summary>

```bash
# Clone to skills directory
git clone https://github.com/dementor88/prompt-reviewer.git \
  ~/.claude/skills/prompt-reviewer

# Verify installation
ls ~/.claude/skills/prompt-reviewer/skills/prompt-reviewer/SKILL.md
```

</details>

<details>
<summary><b>🍺 Homebrew (coming soon)</b></summary>

```bash
# Tap the repository
brew tap dementor88/tools

# Install prompt-reviewer
brew install prompt-reviewer

# Link to your preferred tool
prompt-reviewer link --opencode
# or
prompt-reviewer link --claude
```

> 📌 **Note:** Homebrew support is on the roadmap. Star the repo to get notified!

</details>

---

## 🚀 Usage

### Quick Mode — Fast 5-Dimension Review

```
prompt-review: build a login page with OAuth
```

### Robust Mode — Full Framework Analysis

```
robust-prompt-review: implement a real-time notification system for our e-commerce platform
```

---

## 📊 Scoring Dimensions

<table>
<thead>
<tr>
<th>Dimension</th>
<th>Weight</th>
<th>What It Measures</th>
</tr>
</thead>
<tbody>
<tr>
<td>🔍 <b>Clarity</b></td>
<td><code>20%</code></td>
<td>Unambiguous? Single interpretation?</td>
</tr>
<tr>
<td>🎯 <b>Specificity</b></td>
<td><code>25%</code></td>
<td>Tech stack, constraints, file paths defined?</td>
</tr>
<tr>
<td>📏 <b>Measurability</b></td>
<td><code>20%</code></td>
<td>Success criteria clear?</td>
</tr>
<tr>
<td>📋 <b>Completeness</b></td>
<td><code>20%</code></td>
<td>Edge cases, errors, validation covered?</td>
</tr>
<tr>
<td>✅ <b>Testability</b></td>
<td><code>15%</code></td>
<td>Verification steps and expected outputs?</td>
</tr>
</tbody>
</table>

---

## 💡 Example

<table>
<tr>
<td width="50%">

**Input**
```
prompt-review: build a login page
```

</td>
<td width="50%">

**Score: 35/100** ⚠️

</td>
</tr>
</table>

```
Clarity       ████░░░░░░  40%  (8/20)
Specificity   ██░░░░░░░░  20%  (5/25)
Measurability ███░░░░░░░  30%  (6/20)
Completeness  ████░░░░░░  40%  (8/20)
Testability   ████░░░░░░  40%  (6/15)
```

### 🔴 Gaps Identified

| Dimension | Issue | Impact |
|-----------|-------|--------|
| **Specificity** | No tech stack or file locations | Agent must guess framework |
| **Measurability** | No success criteria | Cannot verify completion |
| **Completeness** | No error handling or security | Missing critical flows |

### ✅ Suggested Refinement → **Projected: 82/100** (+47 pts)

> Build a login page using **React 18** with **TypeScript** in `src/components/auth/LoginPage.tsx`.
>
> **Requirements:**
> - Email/password form with validation (email format, password min 8 chars)
> - Submit button disabled until valid input
> - Show loading spinner during API call
> - Display error messages for 401 (invalid credentials) and 500 (server errors)
> - On success, redirect to `/dashboard` and store JWT in httpOnly cookie
>
> **Success Criteria:**
> - `npm test src/components/auth/LoginPage.test.tsx` passes
> - Invalid login shows "Invalid credentials" error
> - Valid login redirects to dashboard within 2 seconds

---

## 🚩 Red Flags — What Scores Poorly

<details>
<summary><b>English Red Flags</b></summary>

| Dimension | Avoid These Phrases |
|-----------|---------------------|
| Clarity | *"make it good"*, *"improve this"*, *"fix the thing"* |
| Specificity | No technology, framework, or file locations |
| Measurability | *"user-friendly"*, *"fast"*, *"efficient"* (no metrics) |
| Completeness | No error handling, edge cases, or validation |
| Testability | No verification commands or expected outputs |

</details>

<details>
<summary><b>Korean Red Flags (한국어)</b></summary>

| 표현 | 문제점 |
|------|--------|
| *"좋게 해줘"* | 기준 없음 |
| *"잘 만들어줘"* | 요구사항 없음 |
| *"알아서 해줘"* | 제약조건 없음 |
| *"깔끔하게"*, *"빠르게"* | 주관적 표현 |

</details>

---

## 🔬 Robust Mode Frameworks

<details open>
<summary><b>Tier 1: CO-STAR (40%)</b> — GovTech Singapore Framework</summary>

| Letter | Component | Description |
|--------|-----------|-------------|
| **C** | Context | Background, system state |
| **O** | Objective | Clear goal, specific task |
| **S** | Style | Output format, code style |
| **T** | Tone | Formality, technical depth |
| **A** | Audience | Who is this for? |
| **R** | Response | Expected output format |

</details>

<details>
<summary><b>Tier 2: LUPES (35%)</b> — Meta-Validation Checks</summary>

| Check | Description |
|-------|-------------|
| **Quality** | Well-formed, clear structure |
| **Structure** | Logical flow, no contradictions |
| **Validity** | Achievable within constraints |
| **Risk** | Error handling, edge cases mentioned |

</details>

<details>
<summary><b>Tier 3: 2026 Checklist (25%)</b> — Engineering Completeness</summary>

- [ ] Success Criteria
- [ ] Output Contract
- [ ] Constraints
- [ ] Inputs
- [ ] Examples
- [ ] Verification
- [ ] Iteration Plan
- [ ] Context

</details>

---

## ⚠️ Important: Review-Only Behavior

> **This skill does NOT execute prompts.**

```
┌─────────────────────────────────────────────────────┐
│  1. Analyze the prompt you provide                  │
│  2. Output a score and gaps                         │
│  3. Suggest improvements                            │
│  4. STOP ← Does NOT execute the prompt              │
└─────────────────────────────────────────────────────┘
```

**The prompt is the patient. The skill is the doctor.**  
*Diagnose only. Do not operate.*

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a [Pull Request](https://github.com/dementor88/prompt-reviewer/pulls) or open an [Issue](https://github.com/dementor88/prompt-reviewer/issues).

## 📄 License

This project is licensed under the [MIT License](LICENSE).
