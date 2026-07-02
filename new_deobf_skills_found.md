# 新发现的 Deobfuscation 相关 Skills（按推荐优先级排序）

> ✅ = 已安装  |  🆕 = 新发现  |  ⭐ = 推荐安装

---

## 第一梯队：直接反混淆优化（最推荐 🏆）

| Skill | 来源 | 安装量 | 说明 | 分类 |
|-------|------|--------|------|------|
| 🆕 **deobf-string** | p4nda0s/bin-deobf-skills | 55 | 字符串反混淆专用 | 字符串去混淆 |
| 🆕 **deobf-indirect** | p4nda0s/bin-deobf-skills | 55 | 间接跳转/调用反混淆 | 控制流去混淆 |
| 🆕 **deobfuscating-javascript-malware** | mukul975/cybersecurity-skills | 96 | JS 恶意代码反混淆 | JS 反混淆 |
| 🆕 **deobfuscating-powershell-obfuscated-malware** | mukul975/cybersecurity-skills | 63 | PowerShell 混淆恶意代码反混淆 | PowerShell 反混淆 |

安装：`npx skills add p4nda0s/bin-deobf-skills -g -y`（2 个 deobf skill 一次装齐）
安装：`npx skills add mukul975/anthropic-cybersecurity-skills --skill deobfuscating-javascript-malware -g -y`
安装：`npx skills add mukul975/anthropic-cybersecurity-skills --skill deobfuscating-powershell-obfuscated-malware -g -y`

---

## 第二梯队：逆向工具链（补全工具能力）

| Skill | 来源 | 安装量 | 说明 |
|-------|------|--------|------|
| 🆕 **ghidra** | mitsuhiko/agent-stuff | 401 | Ghidra 逆向框架使用 |
| 🆕 **ghidra-headless** | trailofbits/skills-curated | 198 | Ghidra 无头模式自动化逆向 |
| 🆕 **radare2** | smithery.ai | 68 | radare2 逆向工具链 |
| 🆕 **ida-domain-scripting** | hexrayssa/ida-claude-plugins | 32 | IDA Pro 脚本化 |
| 🆕 **ida-mcp-headless-reverse-engineering** | aradotso/mcp-skills | 67 | IDA MCP 无头逆向 |

---

## 第三梯队：动态分析 & Hook

| Skill | 来源 | 安装量 | 说明 |
|-------|------|--------|------|
| 🆕 **frida-17** | yfe404/frida-17-skill | **1.2K** | Frida 动态插桩框架 |
| 🆕 **frida-stalker-android** | yfe404/frida-stalker-skills | 90 | Frida Stalker Android 追踪 |
| 🆕 **frida-mcp-workflow** | yfe404/frida-mcp-skills | 54 | Frida MCP 工作流 |
| 🆕 **jsreverser-mcp-javascript-reverse** | aradotso/mcp-skills | 150 | JS 逆向 MCP 工具 |
| ✅ **symbolic-execution-tools** | yaklang/hack-skills | 1.6K | angr/Z3（已安装） |

---

## 第四梯队：综合逆向 Skill 包

| 仓库 | Skill 数 | 总安装量 | 亮点 |
|------|---------|---------|------|
| 🆕 **zhaoxuya520/reverse-skill** | **57** 个 | 1.1K | ida-reverse、apk-reverse、dotnet-reverse、binary-diff、js-reverse、pwn-chain 等 |
| 🆕 **gmh5225/awesome-game-security** | 9 个 | 1.2K | anti-cheat、game-hacking、windows-kernel |
| 🆕 **gmh5225/awesome-llvm-security** | 10 个 | 449 | **llvm-obfuscation**、binary-lifting、static-analysis、dynamic-instrumentation |
| ✅ **ljagiello/ctf-skills** | 11 个 | 大量 | 已安装 ctf-reverse，还有 ctf-malware、ctf-pwn、ctf-forensics |
| ✅ **cyberkaida/reverse-engineering-assistant** | 6 个 | 少量 | 已安装 deep-analysis，还有 ctf-rev、ctf-pwn、binary-triage、pyghidra |

---

## 第五梯队：二进制分析 & 恶意代码分析

| Skill | 来源 | 安装量 |
|-------|------|--------|
| 🆕 **binary-analysis-patterns** | wshobson/agents | **7.7K** |
| 🆕 **elf-inspection** | mohitmishra786/low-level-dev-skills | 242 |
| 🆕 **yara-rule-authoring** | trailofbits/skills | **3.2K** |
| 🆕 **binary-triage** | cyberkaida/reverse-engineering-assistant | 155 |
| 🆕 **binary-analysis** | laurigates/claude-plugins | 95 |
| 🆕 **reverse-engineering-ransomware-encryption** | mukul975/cybersecurity-skills | 58 |
| 🆕 **reverse-engineering-rust-malware** | mukul975/cybersecurity-skills | 58 |
| ✅ **memory-forensics-volatility** | yaklang/hack-skills | 1.6K（未单独装，在 yaklang 全家桶里） |
| ✅ **steganography-techniques** | yaklang/hack-skills | 1.6K（同上） |
| 🆕 **ctf-malware** | ljagiello/ctf-skills | **4.9K** |
| 🆕 **ctf-pwn** | ljagiello/ctf-skills | **5.4K** |
| 🆕 **ctf-forensics** | ljagiello/ctf-skills | **5.1K** |
| 🆕 **reverse-engineering-tools** | gmh5225/awesome-game-security | 213 |
| 🆕 **llvm-obfuscation** | gmh5225/awesome-llvm-security | 65 |
| 🆕 **binary-lifting** | gmh5225/awesome-llvm-security | 42 |
| 🆕 **reverse-engineering-android-malware-with-jadx** | mukul975/cybersecurity-skills | 127 |
| 🆕 **reverse-engineering-ios-app-with-frida** | mukul975/cybersecurity-skills | 84 |
| 🆕 **hermes-dec-bytecode-reverse-engineering** | aradotso/hermes-skills | 30 |

---

## 推荐安装方案

### 方案 A：零散补全（只装最需要的 3-5 个）

```bash
# 1. 二进制反混淆补充
npx skills add p4nda0s/bin-deobf-skills -g -y

# 2. 新增反混淆场景
npx skills add mukul975/anthropic-cybersecurity-skills --skill deobfuscating-javascript-malware -g -y
npx skills add mukul975/anthropic-cybersecurity-skills --skill deobfuscating-powershell-obfuscated-malware -g -y

# 3. LLVM 混淆分析
npx skills add gmh5225/awesome-llvm-security --skill llvm-obfuscation -g -y
npx skills add gmh5225/awesome-llvm-security --skill binary-lifting -g -y
```

### 方案 B：补全逆向工具链（方案 A + 工具链）

```bash
# 先执行方案 A

# 逆向工具
npx skills add mitsuhiko/agent-stuff --skill ghidra -g -y
npx skills add trailofbits/skills-curated --skill ghidra-headless -g -y
npx skills add smithery.ai/radare2 -g -y

# 动态分析
npx skills add yfe404/frida-17-skill --skill frida-17 -g -y

# 二进制分析
npx skills add wshobson/agents --skill binary-analysis-patterns -g -y
npx skills add trailofbits/skills --skill yara-rule-authoring -g -y
```

### 方案 C：全面覆盖（所有推荐 🚀）

```bash
# 先执行方案 A + 方案 B

# 综合逆向包
npx skills add zhaoxuya520/reverse-skill -g -y            # 57 个 skill
npx skills add gmh5225/awesome-game-security -g -y        # 9 个 skill
npx skills add gmh5225/awesome-llvm-security -g -y        # 10 个 skill

# CTF 全家桶补充
npx skills add ljagiello/ctf-skills --skill ctf-malware -g -y
npx skills add ljagiello/ctf-skills --skill ctf-pwn -g -y
npx skills add ljagiello/ctf-skills --skill ctf-forensics -g -y

# 恶意代码分析补充
npx skills add mukul975/anthropic-cybersecurity-skills --skill reverse-engineering-android-malware-with-jadx -g -y
npx skills add mukul975/anthropic-cybersecurity-skills --skill reverse-engineering-ios-app-with-frida -g -y
npx skills add mukul975/anthropic-cybersecurity-skills --skill reverse-engineering-ransomware-encryption-routine -g -y
```

---

## 与新发现 Skill 的关键差异点

| 领域 | 之前覆盖 | 新发现补充 |
|------|---------|-----------|
| 字符串去混淆 | code-obfuscation-deobfuscation（通用） | **deobf-string**（专用脚本） |
| 间接跳转 | code-obfuscation-deobfuscation（通用） | **deobf-indirect**（专用脚本） |
| PowerShell 反混淆 | 无 | **deobfuscating-powershell-obfuscated-malware** |
| LLVM 混淆 | 无 | **llvm-obfuscation + binary-lifting** |
| Ghidra | 无 | **ghidra + ghidra-headless** |
| radare2 | 无 | **radare2** |
| IDA Pro | 无 | **ida-domain-scripting、ida-mcp** |
| Frida | 无 | **frida-17、frida-stalker** |
| JS 逆向 | ast-deobfuscation（AST 级别） | **jsreverser-mcp（运行时级别）** |
| YARA 规则 | 无 | **yara-rule-authoring** |
| 游戏保护 | 无 | **gmh5225/awesome-game-security** |
| 综合逆向 | 9 个 skill | **zhaoxuya520/reverse-skill（57 个）** |
