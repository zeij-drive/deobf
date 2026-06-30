# 🛡️ deobf-all — Unified Deobfuscation Skill Suite for AI Agents

> **One command to load the entire deobfuscation arsenal.** A master dispatcher skill that pulls in 9 specialized reverse-engineering & deobfuscation sub-skills, then routes to the right combination based on your target.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Skills Standard](https://img.shields.io/badge/Agent%20Skills-Standard-blue)](https://agentskills.io)
[![Platform](https://img.shields.io/badge/platform-Claude%20Code%20%7C%20Cursor%20%7C%20Codex%20%7C%20Windsurf-green)](https://skills.sh)

---

## 📖 What is this?

**deobf-all** is an Agent Skill that acts as a unified entry point for deobfuscation workflows. Instead of manually loading individual skills for different obfuscation types, you invoke `deobf-all` once and it:

1. **Loads all 9 sub-skills** into the agent's context simultaneously
2. **Triages your target** (native binary, JavaScript, bytecode, CTF, unknown)
3. **Routes to the optimal skill combination** for the specific obfuscation type
4. **Guides the full deobfuscation workflow** from triage → analysis → deobfuscation → validation

## 🧰 Skill Inventory

| # | Skill | Source | Installs | What It Does |
|---|-------|--------|----------|-------------|
| 1 | **code-obfuscation-deobfuscation** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.8K | Core: CFF, opaque predicates, string encrypt, import hiding, anti-disasm |
| 2 | **ast-deobfuscation** | [lwjjike/xbsreverseskill](https://github.com/lwjjike/xbsreverseskill) | 35 | JavaScript AST: pattern detection, pipeline, site adapters |
| 3 | **vm-and-bytecode-reverse** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.6K | VM protectors: VMProtect/Themida, custom VM dispatcher |
| 4 | **anti-debugging-techniques** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.6K | Anti-debug: ptrace, PEB, timing, TLS, VEH + bypass |
| 5 | **symbolic-execution-tools** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.6K | angr/Z3/Triton: automated constraint solving, emulation |
| 6 | **binary-protection-bypass** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.6K | ASLR/NX/PIE/Canary/RELRO bypass |
| 7 | **ctf-reverse** | [ljagiello/ctf-skills](https://github.com/ljagiello/ctf-skills) | 5.8K | CTF reverse engineering methodology |
| 8 | **anti-reversing-techniques** | [wshobson/agents](https://github.com/wshobson/agents) | 7.6K | Anti-reversing identification & circumvention |
| 9 | **deep-analysis** | [cyberkaida/reverse-engineering-assistant](https://github.com/cyberkaida/reverse-engineering-assistant) | 345 | Deep reverse engineering triage |

## 🚀 Quick Start

### Option 1: Auto-Install Script (Recommended)

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/deobf-all.git
cd deobf-all

# Run the installer (macOS / Linux)
chmod +x install.sh
./install.sh

# Or on Windows
install.bat
```

The script will:
- Install all 9 sub-skills globally via `npx skills add`
- Copy the `deobf-all` dispatcher skill to `~/.agents/skills/`

### Option 2: Manual Install

```bash
# Install all sub-skills
npx skills add yaklang/hack-skills --skill code-obfuscation-deobfuscation -g -y
npx skills add lwjjike/xbsreverseskill --skill ast-deobfuscation -g -y
npx skills add yaklang/hack-skills --skill vm-and-bytecode-reverse -g -y
npx skills add yaklang/hack-skills --skill anti-debugging-techniques -g -y
npx skills add yaklang/hack-skills --skill symbolic-execution-tools -g -y
npx skills add yaklang/hack-skills --skill binary-protection-bypass -g -y
npx skills add ljagiello/ctf-skills --skill ctf-reverse -g -y
npx skills add wshobson/agents --skill anti-reversing-techniques -g -y
npx skills add cyberkaida/reverse-engineering-assistant --skill deep-analysis -g -y

# Install the deobf-all dispatcher
mkdir -p ~/.agents/skills/deobf-all
cp deobf-all/SKILL.md ~/.agents/skills/deobf-all/SKILL.md
```

### Option 3: One-Command Yaklang Full Install

If you want the **entire** yaklang hack-skills collection (103 security skills including all 5 yaklang sub-skills above):

```bash
npx skills add yaklang/hack-skills -g -y
```

Then only install the 4 non-yaklang skills separately:

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

1. **All 9 sub-skills are loaded** into the agent's context via `read_skill`
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
| Unknown — need triage first | `deep-analysis` | `→ then route based on findings` |

### Example Workflows

#### Deobfuscate a VMProtect-protected binary

```
You: I have a Windows PE file that's protected with VMProtect. Help me deobfuscate it.
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
├── README.md              # This file — usage & documentation
├── LICENSE                 # MIT license
├── install.sh              # Auto-installer for macOS / Linux
├── install.bat             # Auto-installer for Windows
└── deobf-all/
    └── SKILL.md            # The dispatcher skill itself
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

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

The sub-skills referenced by this dispatcher are maintained by their respective authors under their own licenses:
- `yaklang/hack-skills` — MIT
- `lwjjike/xbsreverseskill` — see repo
- `ljagiello/ctf-skills` — see repo
- `wshobson/agents` — see repo
- `cyberkaida/reverse-engineering-assistant` — see repo

## ⚠️ Disclaimer

This skill suite is intended for **authorized security research, CTF competitions, and educational purposes** only. Always ensure you have proper authorization before analyzing or deobfuscating any software. The authors and contributors are not responsible for misuse.
