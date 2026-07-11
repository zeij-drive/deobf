[![EN](https://img.shields.io/badge/lang-EN-blue)](README_EN.md) [![中文](https://img.shields.io/badge/lang-中文-red)](README.md)

# 🛡️ deobf-all — AI Agent 统一反混淆技能套件

> **一条命令加载整个反混淆武器库。** 一个主调度 skill，一次性拉起 26 个专业逆向工程 & 反混淆子 skill，并根据你的目标自动路由到最佳技能组合。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Skills Standard](https://img.shields.io/badge/Agent%20Skills-Standard-blue)](https://agentskills.io)
[![Platform](https://img.shields.io/badge/platform-Claude%20Code%20%7C%20Cursor%20%7C%20Codex%20%7C%20Windsurf-green)](https://skills.sh)

### ⚡ 一键安装

**安装调度器（轻量）：**
```bash
npx skills add zeij-drive/deobf --skill deobf-all -g -y
```

**安装全部 26 个子 skill + 调度器（一条命令）：**
```bash
curl -fsSL https://raw.githubusercontent.com/zeij-drive/deobf/main/install.sh | bash
```

**Windows 一键安装：**

PowerShell（推荐 — 自动处理 MOTW 安全标记）：
```powershell
powershell -c "iwr -useb https://raw.githubusercontent.com/zeij-drive/deobf/main/install.bat -outf $env:TEMP\deobf.bat; Unblock-File $env:TEMP\deobf.bat; cmd /c $env:TEMP\deobf.bat"
```

curl（Windows 10+ 自带，无需 PowerShell）：
```bash
curl -fsSLo %temp%\deobf.bat https://raw.githubusercontent.com/zeij-drive/deobf/main/install.bat && "%temp%\deobf.bat"
```

> 安装后首次调用 `/deobf-all` 时会自动按需加载子 skill。如需**完整预装全部 26 个子 skill**，上面的一键命令（PowerShell）即可全量安装，无需克隆仓库。

---

## 📖 这是什么？

**deobf-all** 是一个 Agent Skill，充当反混淆工作流的统一入口。你不需要为不同的混淆类型手动加载各自的 skill，只需调用一次 `deobf-all`，它就会：

1. **同时加载全部 26 个子 skill** 到 agent 上下文中
2. **对你的目标进行分类**（原生二进制、JavaScript、Java 字节码、CTF、未知类型）
3. **路由到最优 skill 组合**，针对具体的混淆类型
4. **引导完整的反混淆工作流**：分类 → 分析 → 反混淆 → 验证

## 🧰 Skill 清单

| # | Skill | 来源 | 安装量 | 功能 |
|---|-------|------|--------|------|
| 1 | **code-obfuscation-deobfuscation** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.8K | 核心：控制流扁平化、opaque predicates、字符串加密、import 隐藏、反反汇编 |
| 2 | **ast-deobfuscation** | [lwjjike/xbsreverseskill](https://github.com/lwjjike/xbsreverseskill) | 38 | JavaScript AST：模式检测、流水线、站点适配 |
| 3 | **vm-and-bytecode-reverse** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.6K | VM 保护器：VMProtect/Themida、自定义 VM 调度器 |
| 4 | **anti-debugging-techniques** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.6K | 反调试：ptrace、PEB、时序攻击、TLS、VEH + 绕过 |
| 5 | **symbolic-execution-tools** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.6K | angr/Z3/Triton：自动约束求解、仿真 |
| 6 | **binary-protection-bypass** | [yaklang/hack-skills](https://github.com/yaklang/hack-skills) | 1.6K | ASLR/NX/PIE/Canary/RELRO 绕过 |
| 7 | **ctf-reverse** | [ljagiello/ctf-skills](https://github.com/ljagiello/ctf-skills) | 5.9K | CTF 逆向工程方法论 |
| 8 | **anti-reversing-techniques** | [wshobson/agents](https://github.com/wshobson/agents) | 7.7K | 反逆向技术识别与规避 |
| 9 | **deep-analysis** | [cyberkaida/reverse-engineering-assistant](https://github.com/cyberkaida/reverse-engineering-assistant) | 356 | 深度逆向工程分类 |
| 10 | **deobf-string** 🆕 | [p4nda0s/bin-deobf-skills](https://github.com/p4nda0s/bin-deobf-skills) | 55 | 字符串反混淆专用 |
| 11 | **deobf-indirect** 🆕 | [p4nda0s/bin-deobf-skills](https://github.com/p4nda0s/bin-deobf-skills) | 55 | 间接跳转反混淆 |
| 12 | **llvm-obfuscation** 🆕 | [gmh5225/awesome-llvm-security](https://github.com/gmh5225/awesome-llvm-security) | 65 | LLVM 混淆分析（OLLVM 等） |
| 13 | **binary-lifting** 🆕 | [gmh5225/awesome-llvm-security](https://github.com/gmh5225/awesome-llvm-security) | 42 | 二进制提升与 IR 分析 |
| 14 | **deobfuscating-javascript-malware** 🆕 | [mukul975/anthropic-cybersecurity-skills](https://github.com/mukul975/anthropic-cybersecurity-skills) | 96 | JS 恶意代码反混淆 |
| 15 | **deobfuscating-powershell-obfuscated-malware** 🆕 | [mukul975/anthropic-cybersecurity-skills](https://github.com/mukul975/anthropic-cybersecurity-skills) | 63 | PowerShell 混淆恶意代码反混淆 |
| 16 | **binary-analysis-patterns** 🆕 | [wshobson/agents](https://github.com/wshobson/agents) | 7.7K | 二进制分析模式识别 |
| 17 | **yara-rule-authoring** 🆕 | [trailofbits/skills](https://github.com/trailofbits/skills) | 3.2K | YARA 规则编写 |
| 18 | **ghidra-headless** 🆕 | [trailofbits/skills-curated](https://github.com/trailofbits/skills-curated) | 198 | Ghidra 无头模式自动化逆向 |
| 19 | **reverse-engineering-malware-with-ghidra** 🆕 | [mukul975/anthropic-cybersecurity-skills](https://github.com/mukul975/anthropic-cybersecurity-skills) | 224 | Ghidra 恶意代码逆向 |
| 20 | **frida-17** 🆕 | [yfe404/frida-17-skill](https://github.com/yfe404/frida-17-skill) | 1.2K | Frida 动态插桩框架 |
| 21 | **radare2** 🆕 | [zhaoxuya520/reverse-skill](https://github.com/zhaoxuya520/reverse-skill) | 81 | radare2 逆向工具链 |
| 22 | **java-decompile** 🆕 | [quarkusio/quarkusdev-skills](https://github.com/quarkusio/quarkusdev-skills) | 37 | Java 字节码反编译：CFR/Procyon/Fernflower |
| 23 | **jadx** 🆕 | [brownfinesecurity/iothackbot](https://github.com/brownfinesecurity/iothackbot) | 316 | Android APK 反编译：DEX → Java 源码 |
| 24 | **apktool** 🆕 | [brownfinesecurity/iothackbot](https://github.com/brownfinesecurity/iothackbot) | — | APK 解包、smali 反汇编、资源提取 |
| 25 | **reverse-engineering-android-malware-with-jadx** 🆕 | [mukul975/anthropic-cybersecurity-skills](https://github.com/mukul975/anthropic-cybersecurity-skills) | 128 | 用 JADX 逆向 Android 恶意软件 |
| 26 | **firebase-apk-scanner** 🆕 | [trailofbits/skills](https://github.com/trailofbits/skills) | 3.5K | APK 的 Firebase 配置安全扫描 |

## 🚀 快速开始

### 方式 0：curl | bash / Windows 一键全量安装（最推荐 🌟）

一条命令安装**全部 26 个子 skill + deobf-all 调度器**，无需克隆仓库：

**macOS / Linux：**
```bash
curl -fsSL https://raw.githubusercontent.com/zeij-drive/deobf/main/install.sh | bash
```

**Windows：**

PowerShell（推荐 — 自动处理 MOTW 安全标记）：
```powershell
powershell -c "iwr -useb https://raw.githubusercontent.com/zeij-drive/deobf/main/install.bat -outf $env:TEMP\deobf.bat; Unblock-File $env:TEMP\deobf.bat; cmd /c $env:TEMP\deobf.bat"
```

curl（Windows 10+ 自带）：
```bash
curl -fsSLo %temp%\deobf.bat https://raw.githubusercontent.com/zeij-drive/deobf/main/install.bat && "%temp%\deobf.bat"
```

这一条命令即可完成：
- 自动安装全部 **26 个** 反混淆相关的子 skill（来自 10 个 GitHub 仓库）
- 自动安装 `deobf-all` 调度 skill
- 自动注册到所有已安装的 agent 平台

### 方式 1：Skills.sh 一键安装（安装调度器）

```bash
npx skills add zeij-drive/deobf --skill deobf-all -g -y
```

> 通过 [skills.sh](https://skills.sh/zeij-drive/deobf) 安装 `deobf-all` 调度 skill。首次调用时会自动 `read_skill` 拉起子 skill。

### 方式 2：自动安装脚本（推荐）

```bash
# 克隆仓库
git clone https://github.com/zeij-drive/deobf.git
cd deobf

# 运行安装程序（macOS / Linux）
chmod +x install.sh
./install.sh

# 或 Windows 下
install.bat
```

脚本将完成：
- 通过 `npx skills add` 全局安装全部 26 个子 skill
- 通过 `npx skills add zeij-drive/deobf --skill deobf-all -g -y` 全局安装 `deobf-all` 调度 skill
- 使用 `--local` 时安装到当前 workspace 的 `.agents/skills/` 路径
- 提供 `--local` 和 `--dry-run` 参数，方便更安全的安装

### 方式 3：手动安装

```bash
# 安装所有子 skill（P0-P2）
npx skills add yaklang/hack-skills --skill code-obfuscation-deobfuscation -g -y
npx skills add lwjjike/xbsreverseskill --skill ast-deobfuscation -g -y
npx skills add yaklang/hack-skills --skill vm-and-bytecode-reverse -g -y
npx skills add yaklang/hack-skills --skill anti-debugging-techniques -g -y
npx skills add yaklang/hack-skills --skill symbolic-execution-tools -g -y
npx skills add yaklang/hack-skills --skill binary-protection-bypass -g -y
npx skills add ljagiello/ctf-skills --skill ctf-reverse -g -y
npx skills add wshobson/agents --skill anti-reversing-techniques -g -y
npx skills add cyberkaida/reverse-engineering-assistant --skill deep-analysis -g -y

# 二进制反混淆补充
npx skills add p4nda0s/bin-deobf-skills -g -y
npx skills add gmh5225/awesome-llvm-security --skill llvm-obfuscation -g -y
npx skills add gmh5225/awesome-llvm-security --skill binary-lifting -g -y

# JS / PowerShell 反混淆
npx skills add mukul975/anthropic-cybersecurity-skills --skill deobfuscating-javascript-malware -g -y
npx skills add mukul975/anthropic-cybersecurity-skills --skill deobfuscating-powershell-obfuscated-malware -g -y

# 工具链 & 二进制分析
npx skills add wshobson/agents --skill binary-analysis-patterns -g -y
npx skills add trailofbits/skills --skill yara-rule-authoring -g -y
npx skills add trailofbits/skills-curated --skill ghidra-headless -g -y
npx skills add yfe404/frida-17-skill --skill frida-17 -g -y
npx skills add mukul975/anthropic-cybersecurity-skills --skill reverse-engineering-malware-with-ghidra -g -y
npx skills add zhaoxuya520/reverse-skill --skill radare2 -g -y

# Java / Android 反编译
npx skills add quarkusio/quarkusdev-skills --skill java-decompile -g -y
npx skills add brownfinesecurity/iothackbot --skill jadx -g -y
npx skills add brownfinesecurity/iothackbot --skill apktool -g -y
npx skills add mukul975/anthropic-cybersecurity-skills --skill reverse-engineering-android-malware-with-jadx -g -y
npx skills add trailofbits/skills --skill firebase-apk-scanner -g -y

# 全局安装 deobf-all 调度 skill
npx skills add zeij-drive/deobf --skill deobf-all -g -y
```

### 方式 4：一键安装完整 Yaklang

如果你想要 **完整** 的 yaklang hack-skills 集合（103 个安全 skill，包含上面全部 5 个 yaklang 子 skill）：

```bash
npx skills add yaklang/hack-skills -g -y
```

然后单独安装另外 4 个非 yaklang skill：

```bash
npx skills add lwjjike/xbsreverseskill --skill ast-deobfuscation -g -y
npx skills add ljagiello/ctf-skills --skill ctf-reverse -g -y
npx skills add wshobson/agents --skill anti-reversing-techniques -g -y
npx skills add cyberkaida/reverse-engineering-assistant --skill deep-analysis -g -y
```

## 🎯 使用方式

### 在 Reasonix / Claude Code / Cursor 中

```
/deobf-all
```

或通过编程方式：

```python
run_skill(name="deobf-all")
```

### 调用后会发生什么

1. **全部 26 个子 skill** 通过 `read_skill` 加载到 agent 上下文中
2. Agent **对你的目标进行分类**，依据文件类型和混淆特征
3. Agent **路由到最优 skill 组合**：

| 目标类型 | 主要 skill | 辅助 skill |
|---------|-----------|-----------|
| VMProtect 保护的原生二进制 | `code-obfuscation-deobfuscation` + `vm-and-bytecode-reverse` | `+ anti-debugging-techniques` |
| OLLVM 控制流扁平化 | `code-obfuscation-deobfuscation` | `+ symbolic-execution-tools` |
| 压缩/加壳 + 反逆向的二进制 | `code-obfuscation-deobfuscation` | `+ anti-reversing-techniques + binary-protection-bypass` |
| 重度混淆的 JavaScript | `ast-deobfuscation` | `+ code-obfuscation-deobfuscation` |
| DotNet/Java/Python 字节码 | `vm-and-bytecode-reverse` | `+ symbolic-execution-tools` |
| CTF 逆向挑战 | `ctf-reverse` + `deep-analysis` | `+ 相关子 skill` |
| 未知类型 — 需要先分类 | `deep-analysis` | `→ 根据发现结果再路由` |

### 示例工作流

#### 反混淆 VMProtect 保护的二进制文件

```
你：我有一个 Windows PE 文件，被 VMProtect 保护了。帮我反混淆。
Agent：[加载 deobf-all → 识别 VMProtect → 加载 vm-and-bytecode-reverse + anti-debugging-techniques + code-obfuscation-deobfuscation]
```

#### 反混淆 obfuscator.io 处理的 JavaScript

```
你：这个 JS 文件被 obfuscator.io 混淆了，能清理一下吗？
Agent：[加载 deobf-all → 识别 JS 混淆器 → 加载 ast-deobfuscation → 运行 detect-patterns.js → 应用流水线]
```

#### 解决 CTF 逆向工程挑战

```
你：帮我解这个 CTF rev 挑战题——看起来是一个自定义 VM。
Agent：[加载 deobf-all → 识别 CTF + VM → 加载 ctf-reverse + deep-analysis + vm-and-bytecode-reverse]
```

## 🗂️ 项目结构

```
deobf-all/
├── README.md              # 本文件 — 使用说明与文档
├── LICENSE                 # MIT 许可证
├── install.sh              # macOS / Linux 自动安装脚本
├── install.bat             # Windows 自动安装脚本
└── deobf-all/
    └── SKILL.md            # 调度 skill 本体
```

## 📋 系统要求

| 要求 | 版本 | 用途 |
|------|------|------|
| Node.js | >= 18 | `npx skills` CLI 运行时 |
| npm / npx | latest | Skill 包管理器 |
| Agent 平台 | 任意支持 | Claude Code、Cursor、Codex、Windsurf、Gemini CLI 等 |

支持的 agent 平台（`npx skills` 自动检测）：
Antigravity、Claude Code、Codex、Cursor、Gemini CLI、GitHub Copilot、Lingma、OpenCode、Rovo Dev、Trae、Trae CN

## 🏗️ 架构

```
deobf-all (调度器)
  │
  ├─── P0 Skills（遇到相关目标时始终加载）
  │    ├── code-obfuscation-deobfuscation  （原生二进制反混淆）
  │    └── ast-deobfuscation               （JavaScript 反混淆）
  │
  ├─── P1 Skills（按需加载）
  │    ├── vm-and-bytecode-reverse         （VM 保护）
  │    ├── anti-debugging-techniques       （反调试绕过）
  │    └── symbolic-execution-tools        （angr/Z3 自动化）
  │
  └─── P2 Skills（辅助）
       ├── binary-protection-bypass         （保护绕过）
       ├── ctf-reverse                      （CTF 方法论）
       ├── anti-reversing-techniques        （反逆向规避）
       └── deep-analysis                    （全面分类）
```

## 🤝 贡献

欢迎贡献！关注领域：

- 新增混淆类型覆盖（例如 .NET 混淆器、Android dex 保护器）
- 改进路由启发式算法
- 额外子 skill 集成
- Bug 修复和边界情况
- 文档改进

请提交 issue 或 PR。

## 开源说明

本仓库特意设计为调度 skill 可作为普通的 Skill 包复用。可复用的入口点是 `deobf-all/SKILL.md`，安装脚本会优先通过 `npx skills add zeij-drive/deobf --skill deobf-all -g -y` 全局注册调度器；克隆仓库安装且本地注册失败时，才回退复制 `SKILL.md` 到 agent skill 目录。

如果你想将其发布为公开的 skill 仓库，保持当前的 `deobf-all/` 文件夹结构，并将 `install.sh` / `install.bat` 指向该路径即可。调度器本身与仓库的 MIT 许可证兼容；引用的子 skill 保留各自上游的许可证。

## 使用方案

1. 运行 `install.sh` 或 `install.bat`，自动安装所有依赖 skills 和 `deobf-all` 调度 skill。
2. 在支持的 agent 里直接调用 `/deobf-all`，或用 `run_skill(name="deobf-all")`。
3. 先让调度 skill 做目标归类，再由它加载对应的子 skill 组合。
4. 对 JS 混淆优先走 `ast-deobfuscation`，对 VM / 保护壳优先走 `vm-and-bytecode-reverse` + `anti-debugging-techniques`，对未知样本先走 `deep-analysis`。
5. 如果是本地 workspace 内的项目，建议用 `--local` 模式做一次试装，确认不会污染全局 skill 目录。

## 选项说明

- `--global`：全局安装技能（默认）。
- `--local`：把技能安装到当前 workspace，不影响全局目录。
- `--dry-run`：只预览将要安装的 skills，不真正执行安装。
- `--force`：强制重新安装已存在的 skill。
- `--no-deps`：仅安装 `deobf-all` 调度器，跳过子 skill。
- `/deobf-all`：在支持的 agent 中直接调用统一调度 skill。

## 📄 许可证

MIT 许可证 — 详见 [LICENSE](LICENSE)。

本调度器引用的子 skill 由各自作者维护，适用各自的许可证：
- `yaklang/hack-skills` — MIT
- `lwjjike/xbsreverseskill` — 见对应仓库
- `ljagiello/ctf-skills` — 见对应仓库
- `wshobson/agents` — 见对应仓库
- `cyberkaida/reverse-engineering-assistant` — 见对应仓库
- `p4nda0s/bin-deobf-skills` — 见对应仓库
- `gmh5225/awesome-llvm-security` — 见对应仓库
- `mukul975/anthropic-cybersecurity-skills` — 见对应仓库
- `trailofbits/skills` — Apache 2.0
- `trailofbits/skills-curated` — Apache 2.0
- `yfe404/frida-17-skill` — 见对应仓库
- `zhaoxuya520/reverse-skill` — 见对应仓库
- `quarkusio/quarkusdev-skills` — 见对应仓库
- `brownfinesecurity/iothackbot` — 见对应仓库

## ⚠️ 免责声明

本 skill 套件仅限 **授权的安全研究、CTF 竞赛和教育目的** 使用。请始终确保在分析或反混淆任何软件前获得了适当授权。作者和贡献者不对 misuse 负责。
