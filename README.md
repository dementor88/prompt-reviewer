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
| 🚀 **Quick Review** | Fast 5-dimension scoring in seconds with traffic-light verdict |
| 🌐 **Bilingual** | Auto-detects Korean/English, outputs in matching language |
| 🎯 **Actionable** | Provides refined prompts with projected improvements and specific gaps |
| 🛡️ **Review-Only** | Analyzes without executing—safe by design |
| ⚠️ **Anti-Pattern Detection** | Detects structural issues (over-delegation, implicit context, scope creep, role confusion) |
| 📊 **Scoring Anchors** | Calibrated examples for each dimension to ensure consistency |
| 📈 **Task-Scale Classifier** | Adjusts interpretation for Simple/Medium/Complex tasks |

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

### 🔌 Plugin (Optional — OpenCode Only)

The plugin injects trigger-priority rules into the system prompt, ensuring `prompt-review:` is detected **before** any mode directives (`[analyze-mode]`, `[debug-mode]`, etc.). It includes anti-rationalization hardening to protect against prompt compaction confusion.

```bash
# From the installed skill directory:
bash ~/.config/opencode/skills/prompt-reviewer/skills/prompt-reviewer/plugin/install.sh
```

This creates a symlink in `~/.config/opencode/plugin/` — restart OpenCode to activate. To remove:

```bash
rm ~/.config/opencode/plugin/prompt-reviewer.js
```

---

## 🚀 Usage

### Prompt Review — Fast 5-Dimension Review

```
prompt-review: build a login page with OAuth
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
