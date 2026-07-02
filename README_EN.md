[![EN](https://img.shields.io/badge/lang-EN-blue)](README_EN.md) [![中文](https://img.shields.io/badge/lang-中文-red)](README.md)

# 🛡️ deobf-all — Unified Deobfuscation Skill Suite for AI Agents

> **One command to load the entire deobfuscation arsenal.** A master dispatcher skill that pulls in 21 specialized reverse-engineering & deobfuscation sub-skills, then routes to the right combination based on your target type — native binary, JavaScript, VM-protected, packed, or CTF.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Skills Standard](https://img.shields.io/badge/Agent%20Skills-Standard-blue)](https://agentskills.io)
[![Platform](https://img.shields.io/badge/platform-Claude%20Code%20%7C%20Cursor%20%7C%20Codex%20%7C%20Windsurf-green)](https://skills.sh)

### ⚡ One-Click Install

**Install dispatcher (lightweight):**
```bash
npx skills add zeij-drive/deobf -g -y
```

**Install all 21 sub-skills + dispatcher (single command):**
```bash
curl -fsSL https://raw.githubusercontent.com/zeij-drive/deobf/main/install.sh | bash
```

**Windows one-click (PowerShell):**
```powershell
powershell -c "iwr -useb https://raw.githubusercontent.com/zeij-drive/deobf/main/install.bat -outf $env:TEMP\deobf.bat; Unblock-File $env:TEMP\deobf.bat; cmd /c $env:TEMP\deobf.bat"
```

> No clone needed. Automatically installs all sub-skills and dispatcher.

---

## 📖 What is this?

**deobf-all** is an Agent Skill that acts as a unified entry point for deobfuscation workflows. Instead of manually loading individual skills for different obfuscation types, you invoke `deobf-all` once and it:

1. **Loads all 21 sub-skills** into the agent's context simultaneously
2. **Triages your target** (native binary, JavaScript, bytecode, CTF, unknown)
3. **Routes to the optimal skill combination** for the specific obfuscation type
4. **Guides the full deobfuscation workflow** from triage → analysis → deobfuscation → validation

## 🧰 Skill Inventory

| # | Skill | Source | Installs | Description |
|---|-------|--------|----------|-------------|
| 1 | **code-obfuscation-deobfuscation** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.8K | Core: CFF, opaque predicates, string encrypt, import hiding, anti-disasm |
| 2 | **ast-deobfuscation** | [lwjjike/xbsreverseskill](https://github.com/lwjjike/xbsreverseskill) | 38 | JavaScript AST: pattern detection, pipeline, site adapters |
| 3 | **vm-and-bytecode-reverse** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.6K | VM protectors: VMProtect/Themida, custom VM dispatcher |
| 4 | **anti-debugging-techniques** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.6K | Anti-debug: ptrace, PEB, timing, TLS, VEH + bypass |
| 5 | **symbolic-execution-tools** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.6K | angr/Z3/Triton: automated constraint solving, emulation |
| 6 | **binary-protection-bypass** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.6K | ASLR/NX/PIE/Canary/RELRO bypass |
| 7 | **ctf-reverse** | [ljagiello/ctf-skills](https://github.com/ljagiello/ctf-skills) | 5.9K | CTF reverse engineering methodology |
| 8 | **anti-reversing-techniques** | [wshobson/agents](https://github.com/wshobson/agents) | 7.7K | Anti-reversing identification & circumvention |
| 9 | **deep-analysis** | [cyberkaida/reverse-engineering-assistant](https://github.com/cyberkaida/reverse-engineering-assistant) | 356 | Deep reverse engineering triage |
| 10 | **deobf-string** 🆕 | [p4nda0s/bin-deobf-skills](https://github.com/p4nda0s/bin-deobf-skills) | 55 | Dedicated string deobfuscation |
| 11 | **deobf-indirect** 🆕 | [p4nda0s/bin-deobf-skills](https://github.com/p4nda0s/bin-deobf-skills) | 55 | Indirect branch deobfuscation |
| 12 | **llvm-obfuscation** 🆕 | [gmh5225/awesome-llvm-security](https://github.com/gmh5225/awesome-llvm-security) | 65 | LLVM obfuscation analysis (OLLVM etc.) |
| 13 | **binary-lifting** 🆕 | [gmh5225/awesome-llvm-security](https://github.com/gmh5225/awesome-llvm-security) | 42 | Binary lifting & IR analysis |
| 14 | **deobfuscating-javascript-malware** 🆕 | [mukul975/cybersecurity-skills](https://github.com/mukul975/anthropic-cybersecurity-skills) | 96 | JavaScript malware deobfuscation |
| 15 | **deobfuscating-powershell-obfuscated-malware** 🆕 | [mukul975/cybersecurity-skills](https://github.com/mukul975/anthropic-cybersecurity-skills) | 63 | PowerShell obfuscated malware deobf |
| 16 | **binary-analysis-patterns** 🆕 | [wshobson/agents](https://github.com/wshobson/agents) | 7.7K | Binary analysis pattern recognition |
| 17 | **yara-rule-authoring** 🆕 | [trailofbits/skills](https://github.com/trailofbits/skills) | 3.2K | YARA rule authoring |
| 18 | **ghidra-headless** 🆕 | [trailofbits/skills-curated](https://github.com/trailofbits/skills-curated) | 198 | Ghidra headless automated reversing |
| 19 | **reverse-engineering-malware-with-ghidra** 🆕 | [mukul975/cybersecurity-skills](https://github.com/mukul975/anthropic-cybersecurity-skills) | 224 | Ghidra malware reverse engineering |
| 20 | **frida-17** 🆕 | [yfe404/frida-17-skill](https://github.com/yfe404/frida-17-skill) | 1.2K | Frida dynamic instrumentation |
| 21 | **radare2** 🆕 | [zhaoxuya520/reverse-skill](https://github.com/zhaoxuya520/reverse-skill) | 81 | radare2 reverse engineering toolchain |

## 🚀 Quick Start

### Method 0: curl | bash / Windows One-Click Install (Recommended 🌟)

Install **all 21 sub-skills + deobf-all dispatcher** without cloning:

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/zeij-drive/deobf/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
powershell -c "iwr -useb https://raw.githubusercontent.com/zeij-drive/deobf/main/install.bat -outf $env:TEMP\deobf.bat; Unblock-File $env:TEMP\deobf.bat; cmd /c $env:TEMP\deobf.bat"
```

This single command:
- Installs all **21** deobfuscation sub-skills from 10 GitHub repos
- Installs the `deobf-all` dispatcher skill
- Registers with all detected agent platforms

### Method 1: Skills.sh One-Click (Install Dispatcher Only)

```bash
npx skills add zeij-drive/deobf -g -y
```

> Installs the `deobf-all` dispatcher via [skills.sh](https://skills.sh/zeij-drive/deobf). On first invocation, it loads sub-skills automatically.

### Method 2: Auto-Install Script

```bash
git clone https://github.com/zeij-drive/deobf.git
cd deobf

# macOS / Linux
chmod +x install.sh
./install.sh

# Windows
install.bat
```

The script will:
- Install all 21 sub-skills globally via `npx skills add`
- Copy the `deobf-all` dispatcher skill to `~/.agents/skills/`
- Support `--local` and `--dry-run` flags for safer installs

### Method 3: Manual Install

```bash
# Install all sub-skills (P0-P2)
npx skills add yaklang/hack-skills --skill code-obfuscation-deobfuscation -g -y
npx skills add lwjjike/xbsreverseskill --skill ast-deobfuscation -g -y
npx skills add yaklang/hack-skills --skill vm-and-bytecode-reverse -g -y
npx skills add yaklang/hack-skills --skill anti-debugging-techniques -g -y
npx skills add yaklang/hack-skills --skill symbolic-execution-tools -g -y
npx skills add yaklang/hack-skills --skill binary-protection-bypass -g -y
npx skills add ljagiello/ctf-skills --skill ctf-reverse -g -y
npx skills add wshobson/agents --skill anti-reversing-techniques -g -y
npx skills add cyberkaida/reverse-engineering-assistant --skill deep-analysis -g -y

# Binary deobfuscation add-ons
npx skills add p4nda0s/bin-deobf-skills -g -y
npx skills add gmh5225/awesome-llvm-security --skill llvm-obfuscation -g -y
npx skills add gmh5225/awesome-llvm-security --skill binary-lifting -g -y

# JS / PowerShell deobfuscation
npx skills add mukul975/anthropic-cybersecurity-skills --skill deobfuscating-javascript-malware -g -y
npx skills add mukul975/anthropic-cybersecurity-skills --skill deobfuscating-powershell-obfuscated-malware -g -y

# Toolchain & binary analysis
npx skills add wshobson/agents --skill binary-analysis-patterns -g -y
npx skills add trailofbits/skills --skill yara-rule-authoring -g -y
npx skills add trailofbits/skills-curated --skill ghidra-headless -g -y
npx skills add yfe404/frida-17-skill --skill frida-17 -g -y
npx skills add mukul975/anthropic-cybersecurity-skills --skill reverse-engineering-malware-with-ghidra -g -y
npx skills add zhaoxuya520/reverse-skill --skill radare2 -g -y

# Install deobf-all dispatcher
mkdir -p ~/.agents/skills/deobf-all
cp deobf-all/SKILL.md ~/.agents/skills/deobf-all/SKILL.md
```

### Method 4: Yaklang Full Install

If you want the **complete** yaklang hack-skills collection (103 security skills including all 5 yaklang sub-skills above):

```bash
npx skills add yaklang/hack-skills -g -y
```

Then install the non-yaklang skills separately:
```bash
npx skills add lwjjike/xbsreverseskill --skill ast-deobfuscation -g -y
npx skills add ljagiello/ctf-skills --skill ctf-reverse -g -y
npx skills add wshobson/agents --skill anti-reversing-techniques -g -y
npx skills add cyberkaida/reverse-engineering-assistant --skill deep-analysis -g -y
```

## 🎯 Usage

### In Reasonix / Claude Code / Cursor

```
/deobf-all
```

Or programmatically:
```python
run_skill(name="deobf-all")
```

### What Happens When You Invoke It

1. **All 21 sub-skills are loaded** into the agent's context via `read_skill`
2. The agent **triages your target** based on file type and obfuscation symptoms
3. The agent **routes to the optimal skill combination**:

| Target Type | Primary | Supporting |
|------------|---------|-----------|
| Native binary with VMProtect | `code-obfuscation-deobfuscation` + `vm-and-bytecode-reverse` | `+ anti-debugging-techniques` |
| OLLVM control-flow flattened | `code-obfuscation-deobfuscation` | `+ symbolic-execution-tools` |
| Packed binary with anti-reverse | `code-obfuscation-deobfuscation` | `+ anti-reversing-techniques + binary-protection-bypass` |
| Heavily obfuscated JavaScript | `ast-deobfuscation` | `+ code-obfuscation-deobfuscation` |
| DotNet/Java/Python bytecode | `vm-and-bytecode-reverse` | `+ symbolic-execution-tools` |
| CTF reverse challenge | `ctf-reverse` + `deep-analysis` | `+ relevant sub-skills` |
| Unknown — need triage | `deep-analysis` | `→ route based on findings` |

### Example Workflows

#### Deobfuscate a VMProtect-protected binary

```
You: I have a Windows PE file protected with VMProtect. Help me deobfuscate it.
Agent: [loads deobf-all → identifies VMProtect → loads vm-and-bytecode-reverse + anti-debugging-techniques + code-obfuscation-deobfuscation]
```

#### Deobfuscate JavaScript from obfuscator.io

```
You: This JS file is obfuscated with obfuscator.io. Can you clean it up?
Agent: [loads deobf-all → identifies JS obfuscator → loads ast-deobfuscation → runs detect-patterns.js → applies pipeline]
```

#### Solve a CTF reverse engineering challenge

```
You: Help me solve this CTF rev challenge — it looks like a custom VM.
Agent: [loads deobf-all → identifies CTF + VM → loads ctf-reverse + deep-analysis + vm-and-bytecode-reverse]
```

## 🗂️ Project Structure

```
deobf-all/
├── README.md              # Documentation (Chinese)
├── README_EN.md           # Documentation (English)
├── LICENSE                 # MIT license
├── install.sh              # Auto-installer for macOS / Linux
├── install.bat             # Auto-installer for Windows
├── deobf-all/
│   └── SKILL.md            # The dispatcher skill itself
└── docs/                   # Mintlify documentation site
```

## 📋 Requirements

| Requirement | Version | Purpose |
|------------|---------|---------|
| Node.js | >= 18 | Runtime for `npx skills` CLI |
| npm / npx | latest | Skills package manager |
| Agent platform | Any supported | Claude Code, Cursor, Codex, Windsurf, Gemini CLI, etc. |

Supported agent platforms (auto-detected by `npx skills`):
Antigravity, Claude Code, Codex, Cursor, Gemini CLI, GitHub Copilot, Lingma, OpenCode, Rovo Dev, Trae, Trae CN

## 🏗️ Architecture

```
deobf-all (Dispatcher)
  │
  ├─── P0 Skills (always loaded for relevant target)
  │    ├── code-obfuscation-deobfuscation  (native binary deobf)
  │    └── ast-deobfuscation               (JavaScript deobf)
  │
  ├─── P1 Skills (loaded when needed)
  │    ├── vm-and-bytecode-reverse         (VM protection)
  │    ├── anti-debugging-techniques       (anti-debug bypass)
  │    └── symbolic-execution-tools        (angr/Z3 automation)
  │
  └─── P2 Skills (supplementary)
       ├── binary-protection-bypass         (protection bypass)
       ├── ctf-reverse                      (CTF methodology)
       ├── anti-reversing-techniques        (anti-reverse circumvent)
       └── deep-analysis                    (comprehensive triage)
```

## 🤝 Contributing

Contributions are welcome! Areas of interest:

- New obfuscation type coverage (e.g., .NET obfuscators, Android dex protectors)
- Improved routing heuristics
- Additional sub-skill integrations
- Bug fixes and edge cases
- Documentation improvements

Please open an issue or submit a PR.

## Open Source Notes

This repository is intentionally structured so the dispatcher skill can be reused as a normal Skill package. The reusable entry point is `deobf-all/SKILL.md`, and the install scripts copy it into the local agent skill directory before installing the referenced sub-skills.

If you want to publish it as a public skill repository, keep the current `deobf-all/` folder layout and point `install.sh` / `install.bat` at that path. The dispatcher itself is license-compatible with the MIT repository license; the referenced sub-skills keep their upstream licenses.

## Usage Guide

1. Run `install.sh` or `install.bat` to automatically install all dependency skills and the `deobf-all` dispatcher.
2. In your agent, call `/deobf-all` or `run_skill(name="deobf-all")`.
3. The dispatcher will triage your target and route to the optimal sub-skill combination.
4. For JS obfuscation, use `ast-deobfuscation` first. For VM/protected binaries, use `vm-and-bytecode-reverse` + `anti-debugging-techniques`. For unknown samples, start with `deep-analysis`.
5. Use `--local` mode for workspace-only installations to avoid polluting the global skill directory.

## Flags

- `--local`    Install skills to current project instead of globally
- `--dry-run`  Preview what would be installed without actually installing
- `/deobf-all` Invoke the unified dispatcher skill in your agent

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

The sub-skills referenced by this dispatcher are maintained by their respective authors under their own licenses:
- `yaklang/hack-skills` — MIT
- `lwjjike/xbsreverseskill` — see repo
- `ljagiello/ctf-skills` — see repo
- `wshobson/agents` — see repo
- `cyberkaida/reverse-engineering-assistant` — see repo
- `p4nda0s/bin-deobf-skills` — see repo
- `gmh5225/awesome-llvm-security` — see repo
- `mukul975/anthropic-cybersecurity-skills` — see repo
- `trailofbits/skills` — Apache 2.0
- `trailofbits/skills-curated` — Apache 2.0
- `yfe404/frida-17-skill` — see repo
- `zhaoxuya520/reverse-skill` — see repo

## ⚠️ Disclaimer

This skill suite is intended for **authorized security research, CTF competitions, and educational purposes** only. Always ensure you have proper authorization before analyzing or deobfuscating any software. The authors and contributors are not responsible for misuse.
