---
name: deobf-all
description: >-
  Master dispatcher for deobfuscation workflows. Loads the right combination of
  deobf and reverse-engineering skills based on target type — native binary,
  JavaScript, VM-protected, packed, or CTF. Use when you need comprehensive
  deobfuscation capabilities for any target.
---

# Deobf-All — Unified Deobfuscation Dispatcher

> When you encounter **any** obfuscated or protected code, this skill triages
> the target first, then loads **only the relevant sub-skills** — not all 26 at
> once. This minimises tool calls and context usage.

## 0. EXECUTION CONTRACT (read first)

```
DO NOT read_skill all 26 sub-skills blindly.
Instead: triage → load P0 → route → load P1/P2 only if needed.
```

| Phase | Action | Tool calls |
|-------|--------|------------|
| Triage | Inspect target file, identify type | 0–1 (read_file / file command) |
| Load P0 | `read_skill` for 1–2 core skills | 1–2 |
| Route | Decide if P1/P2 are needed | 0 |
| Load P1/P2 | `read_skill` only for skills the route demands | 0–3 |

**Goal**: never exceed 5 `read_skill` calls per invocation unless the target is truly unknown.

## 1. SUB-SKILL INVENTORY

| # | Skill | Purpose | Layer |
|---|-------|---------|-------|
| 1 | `code-obfuscation-deobfuscation` | Native binary deobf: CFF, opaque predicates, string encrypt, import hiding, anti-disasm | **P0** |
| 2 | `ast-deobfuscation` | JavaScript AST deobf: pattern detection, pipeline, site-specific adapters | **P0** (JS only) |
| 3 | `vm-and-bytecode-reverse` | VM protectors (VMProtect/Themida), custom VM dispatcher, opcode mapping | **P1** |
| 4 | `anti-debugging-techniques` | Anti-debug detection & bypass (ptrace, PEB, timing, TLS, VEH) | **P1** |
| 5 | `symbolic-execution-tools` | angr/Z3/Triton: automated constraint solving, emulation unpacking | **P1** |
| 6 | `binary-protection-bypass` | ASLR/NX/PIE/Canary/RELRO bypass | **P2** |
| 7 | `ctf-reverse` | CTF reverse engineering methodology | **P2** |
| 8 | `anti-reversing-techniques` | Anti-reversing identification & circumvention | **P2** |
| 9 | `deep-analysis` | Deep reverse engineering triage (comprehensive analysis) | **P2** |
| 10 | `java-decompile` | Java bytecode decompile: CFR/Procyon/Fernflower | **P2** |
| 11 | `jadx` | Android APK decompile: DEX → Java source | **P2** |
| 12 | `apktool` | APK unpacking, smali disassembly, resource extraction | **P3** |
| 13 | `reverse-engineering-android-malware-with-jadx` | Android malware RE workflow using JADX | **P3** |
| 14 | `firebase-apk-scanner` | Firebase APK configuration security scan | **P3** |
| 15 | `deobf-string` | Decrypt/recover obfuscated strings via pattern analysis & auto-decrypt | **P3** |
| 16 | `deobf-indirect` | Deobfuscate indirect branches (CSEL+BR) via symbolic execution + BFS | **P3** |
| 17 | `llvm-obfuscation` | LLVM-based obfuscation: OLLVM, CFF, string encryption, bogus control flow | **P3** |
| 18 | `binary-lifting` | Machine code → LLVM IR lifting for analysis, decompilation, recompilation | **P3** |
| 19 | `deobfuscating-javascript-malware` | JS malware deobf: web attacks, phishing pages, dropper scripts | **P3** |
| 20 | `deobfuscating-powershell-obfuscated-malware` | Multi-layer PowerShell deobf via AST + dynamic analysis | **P3** |
| 21 | `binary-analysis-patterns` | Binary analysis: disassembly, decompilation, CFG analysis, code patching | **P3** |
| 22 | `yara-rule-authoring` | YARA rule creation for malware classification & threat hunting | **P3** |
| 23 | `ghidra-headless` | Ghidra headless analyzer: automated decompilation, script analysis | **P3** |
| 24 | `frida-17` | Frida 17 JS API compatibility: hooking, tracing, dynamic instrumentation | **P3** |
| 25 | `reverse-engineering-malware-with-ghidra` | Ghidra malware RE workflow: imports, strings, decrypt, unpack | **P3** |
| 26 | `radare2` | radare2 reverse engineering: disassembly, debugging, scripting | **P3** |

## 2. TRIAGE — Do This First (before any read_skill)

Inspect the target and determine:

1. **Target type**: native binary (ELF/PE/Mach-O) / JavaScript / bytecode (DotNet/Java/Python) / Android APK / other
2. **Obfuscation family** (if identifiable): CFF, VM protection, string encryption, packing, JS obfuscator (obfuscator.io, JSFuck, etc.)
3. **Presence of anti-debug / anti-reversing** layers
4. **Context**: CTF challenge? Production analysis? Quick cleanup?

**Output**: A triage line, e.g. `TRIAGE: native PE, VMProtect, has anti-debug → P0:code-obfuscation-deobfuscation P1:vm-and-bytecode-reverse,anti-debugging-techniques`

## 3. ROUTING MATRIX — Load Only What's Needed

Based on triage, `read_skill` **only** for the skills marked ✓:

### 3a. Core Routing — P0 / P1 / P2

| Target | P0 core-deobf | P0 ast-deobf | P1 vm-reverse | P1 anti-debug | P1 symbolic | P2 bin-bypass | P2 ctf-rev | P2 anti-rev | P2 deep | P2 java-decompile | P2 jadx |
|--------|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| Native binary, general | ✓ | | | | | | | | | | |
| Native + VM protection | ✓ | | ✓ | | | | | | | | |
| Native + VM + anti-debug | ✓ | | ✓ | ✓ | | | | | | | |
| Native + CFF (OLLVM) | ✓ | | | | ✓ | | | | | | |
| Native + packed + anti-rev | ✓ | | | | | ✓ | | ✓ | | | |
| JavaScript (any) | | ✓ | | | | | | | | | |
| JS + heavy obfuscation | ✓ | ✓ | | | | | | | | | |
| JS malware / phishing | ✓ | ✓ | | | | | | | | | |
| DotNet/Java/Python bytecode | ✓ | | ✓ | | ✓ | | | | | | |
| Java bytecode (JAR/class) | | | | | | | | | | ✓ | |
| Android APK | | | | | | | | | | | ✓ |
| Android malware analysis | | | | | | | | | | ✓ | ✓ |
| PowerShell obfuscated | | | | | | | | | | | |
| CTF reverse challenge | ✓ | | | | | | ✓ | | ✓ | | |
| Unknown / unclear | | | | | | | | | ✓ | | |

**Rule**: If a cell is empty, do NOT load that skill. This keeps tool calls minimal.

### 3b. P3 Tooling Selector — Load When Deeper Analysis Demands It

After loading P0-P2 per the core matrix, if the deobfuscation encounters a specific bottleneck, load the matching P3 tool:

| Scenario | P3 skill to load |
|----------|------------------|
| String encryption detected (runtime decrypt loop, encoded strings in .rdata) | `deobf-string` |
| Indirect branches (CSEL/BR pattern) blocking CFG recovery | `deobf-indirect` |
| LLVM-obfuscated binary (OLLVM, bogus CF, CFF) | `llvm-obfuscation` |
| Need to lift binary → LLVM IR for recompilation or advanced analysis | `binary-lifting` |
| JavaScript malware (phishing, dropper, web attack) | `deobfuscating-javascript-malware` |
| Multi-layer PowerShell payload | `deobfuscating-powershell-obfuscated-malware` |
| Disassembly / CFG / code patching analysis needed | `binary-analysis-patterns` |
| Post-analysis signature generation (threat hunting, classification) | `yara-rule-authoring` |
| Automated Ghidra headless decompilation at scale | `ghidra-headless` |
| Dynamic instrumentation / runtime hooking needed | `frida-17` |
| Ghidra malware analysis workflow (imports, decrypt, unpack) | `reverse-engineering-malware-with-ghidra` |
| radare2 disassembly, debugging, or scripting preferred | `radare2` |

**Rule**: Only load one P3 skill at a time, and only when the P0-P2 workflow hits a specific bottleneck that the P3 tool addresses.

## 4. WORKFLOW

### Step 1: Triage (0–1 tool call)
Inspect the target. Use `read_file` for source code or `file`/`DIE`/`PEiD` output for binaries. Produce the triage line.

### Step 2: Load P0 (1–2 tool calls)
`read_skill` for the P0 skill(s) the route demands. For native binaries that's `code-obfuscation-deobfuscation`; for JavaScript that's `ast-deobfuscation`.

### Step 3: Load P1/P2 only if routed (0–3 tool calls)
Only `read_skill` for P1/P2 skills that the routing matrix marks ✓ for your target type.

### Step 4: Deobfuscate
- **Static first**: pattern matching, CFF reduction, string decryption, dispatcher inlining
- **Dynamic if blocked**: debugger scripting, emulation, symbolic execution
- For JS: run `scripts/detect-patterns.js` from ast-deobfuscation first, then apply the matching pipeline
- For JS malware / phishing: load `deobfuscating-javascript-malware` (P3) for web-specific deobf patterns
- For PowerShell: load `deobfuscating-powershell-obfuscated-malware` (P3) for layered AST/dynamic analysis
- For native: identify protector (VMProtect/Themida/OLLVM/custom) before choosing strategy
- For native with string encryption: load `deobf-string` (P3) to auto-decrypt runtime-decrypt loops
- For native with indirect branch obfuscation (CSEL+BR): load `deobf-indirect` (P3) for CFG recovery
- For LLVM-obfuscated targets: load `llvm-obfuscation` (P3) for OLLVM/CFF/bogus-CF reduction
- For binary lifting / recompilation: load `binary-lifting` (P3) to convert machine code → LLVM IR
- For disassembly / CFG / code patching: load `binary-analysis-patterns` (P3) as a general analysis aid
- For YARA signature authoring after analysis: load `yara-rule-authoring` (P3)
- For automated Ghidra headless analysis: load `ghidra-headless` (P3)
- For Ghidra malware analysis workflow: load `reverse-engineering-malware-with-ghidra` (P3)
- For dynamic instrumentation / runtime hooking: load `frida-17` (P3)
- For radare2 disassembly / debugging / scripting: load `radare2` (P3)
- For Java bytecode: decompile with `java-decompile` (CFR/Procyon/Fernflower)
- For Java bytecode with string obfuscation: also load `deobf-string` (P3)
- For Android APK: unpack with `apktool`, then decompile DEX with `jadx`
- For Android malware: also load `reverse-engineering-android-malware-with-jadx` + optionally scan Firebase config with `firebase-apk-scanner`

### Step 5: Validate
- Compare deobfuscated output to original symptoms
- Verify functional equivalence
- Check for residual/nested obfuscation layers

## 5. FALLBACK — When Triage Is Uncertain

If you cannot determine the target type after inspection:

1. `read_skill` for `deep-analysis` (P2)
2. Follow deep-analysis methodology to classify the target
3. Return to the routing matrix with the classification result
4. Load the appropriate P0/P1 skills

This is the **only** scenario where you should load a P2 skill before P0.

## 6. QUICK REFERENCE CHECKLISTS

### Native Binary
1. [ ] Triage: identify protector/packer (file, DIE, PEiD)
2. [ ] Load P0: `code-obfuscation-deobfuscation`
3. [ ] Anti-debug? → Load `anti-debugging-techniques`
4. [ ] VM-protected? → Load `vm-and-bytecode-reverse`
5. [ ] Stuck on CFF? → Load `symbolic-execution-tools`
6. [ ] Packed/protected? → Load `binary-protection-bypass`
7. [ ] Anti-reversing? → Load `anti-reversing-techniques`
8. [ ] String encryption? → Load `deobf-string`
9. [ ] Indirect branch obfuscation? → Load `deobf-indirect`
10. [ ] LLVM-obfuscated (OLLVM)? → Load `llvm-obfuscation`
11. [ ] Binary lifting / recompilation needed? → Load `binary-lifting`
12. [ ] Disassembly / CFG / patching? → Load `binary-analysis-patterns`
13. [ ] Dynamic instrumentation / hooking? → Load `frida-17`
14. [ ] Ghidra headless at scale? → Load `ghidra-headless`
15. [ ] Ghidra malware workflow? → Load `reverse-engineering-malware-with-ghidra`
16. [ ] radare2 preferred? → Load `radare2`
17. [ ] YARA signatures after analysis? → Load `yara-rule-authoring`
18. [ ] Deobfuscate → validate

### JavaScript
1. [ ] Triage: identify obfuscator (obfuscator.io, JSFuck, custom)
2. [ ] Load P0: `ast-deobfuscation`
3. [ ] Run `scripts/detect-patterns.js` to identify site/framework
4. [ ] Apply matching pipeline (CFF reduction, string decryption, dispatcher inline)
5. [ ] Heavy obfuscation? → also load `code-obfuscation-deobfuscation`
6. [ ] JS malware / phishing / dropper? → Load `deobfuscating-javascript-malware`
7. [ ] PowerShell payload mixed in? → Load `deobfuscating-powershell-obfuscated-malware`
8. [ ] Re-parse after each stage → validate

### CTF
1. [ ] Load P2: `ctf-reverse` + `deep-analysis`
2. [ ] Identify challenge type (VM, packing, crypto, custom)
3. [ ] Load P0/P1 per routing matrix
4. [ ] String encryption in challenge? → Load `deobf-string`
5. [ ] VM-based challenge? → also consider `deobf-indirect`
6. [ ] OLLVM/CFF challenge? → also consider `llvm-obfuscation`
7. [ ] Dynamic analysis needed? → Load `frida-17` or `radare2`
8. [ ] Solve → validate flag

### Java / Android
1. [ ] Triage: JAR/class file? Android APK?
2. [ ] Java bytecode → Load P2: `java-decompile`
3. [ ] Android APK → Load P2: `jadx` (and `apktool` for unpacking if needed)
4. [ ] Android malware analysis → also load `reverse-engineering-android-malware-with-jadx`
5. [ ] Firebase config scan → Load P3: `firebase-apk-scanner`
6. [ ] String obfuscation? → also load `deobf-string`
7. [ ] Dynamic instrumentation? → Load `frida-17`
8. [ ] Decompile → analyze → validate

### PowerShell / JS Malware
1. [ ] Triage: identify obfuscation layers (base64, XOR, compression, eval chains)
2. [ ] PowerShell → Load P3: `deobfuscating-powershell-obfuscated-malware`
3. [ ] JavaScript malware → Load P0: `ast-deobfuscation` + also load `deobfuscating-javascript-malware`
4. [ ] Apply layered deobf (Unicode → decode → AST cleanup)
5. [ ] YARA signatures post-analysis? → Load `yara-rule-authoring`
6. [ ] Validate behavioral equivalence

### Generic P3 Tooling — Load When Bottleneck Appears
1. [ ] String encryption? → `deobf-string`
2. [ ] Indirect branch / CFG blocked? → `deobf-indirect`
3. [ ] LLVM obfuscation? → `llvm-obfuscation`
4. [ ] Binary lifting? → `binary-lifting`
5. [ ] General binary analysis? → `binary-analysis-patterns`
6. [ ] Automated Ghidra? → `ghidra-headless`
7. [ ] Ghidra malware workflow? → `reverse-engineering-malware-with-ghidra`
8. [ ] Live hooking / tracing? → `frida-17`
9. [ ] radare2 scripting? → `radare2`
10. [ ] YARA signatures? → `yara-rule-authoring`
