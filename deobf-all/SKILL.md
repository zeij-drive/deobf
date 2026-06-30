---
name: deobf-all
description: >-
  Master dispatcher for deobfuscation workflows. Loads all installed deobf and
  reverse-engineering skills at once, then routes to the right sub-skill based
  on the target type. Use when you need comprehensive deobfuscation
  capabilities for any target — native binary, JavaScript, VM-protected, or packed.
---

# Deobf-All — Unified Deobfuscation Dispatcher

> Load this skill when you encounter **any** obfuscated or protected code and need the full deobfuscation arsenal. It pulls in all relevant sub-skills simultaneously, then routes based on the concrete situation.

## 1. SKILL INVENTORY — Load All on Activation

When this skill is activated, **immediately read_skill for ALL of the following** to bring their instructions into context:

| # | Skill Name | Purpose | Priority |
|---|-----------|---------|----------|
| 1 | `code-obfuscation-deobfuscation` | Core deobf: CFF, opaque predicates, string encrypt, import hiding, anti-disasm | **P0** |
| 2 | `ast-deobfuscation` | JavaScript AST deobfuscation: pattern detection, pipeline, site-specific adapters | **P0** (for JS) |
| 3 | `vm-and-bytecode-reverse` | VM protectors (VMProtect/Themida), custom VM dispatcher, opcode mapping | **P1** |
| 4 | `anti-debugging-techniques` | Anti-debug detection & bypass (ptrace, PEB, timing, TLS callback, VEH) | **P1** |
| 5 | `symbolic-execution-tools` | angr/Z3/Triton automated deobfuscation, constraint solving, emulation unpacking | **P1** |
| 6 | `binary-protection-bypass` | ASLR/NX/PIE/Canary/RELRO bypass (often layered with obfuscation) | **P2** |
| 7 | `ctf-reverse` | CTF reverse engineering challenges methodology | **P2** |
| 8 | `anti-reversing-techniques` | Anti-reversing identification and circumvention | **P2** |
| 9 | `deep-analysis` | Deep reverse engineering analysis (comprehensive triage) | **P2** |

**Loading procedure**: Call `read_skill` for each skill above in a single batch of parallel calls (or sequentially if batch not available). This ensures the full deobfuscation knowledge base is in context before analysis begins.

## 2. ROUTING DECISION TREE

After loading all sub-skills, determine the target type and route accordingly:

```
┌─ Is the target obfuscated code?
│
├─ Native binary (ELF/PE/Mach-O)
│   ├─ Has VM protection? → code-obfuscation-deobfuscation + vm-and-bytecode-reverse
│   ├─ Has anti-debug?    → + anti-debugging-techniques
│   ├─ Needs constraint solve? → + symbolic-execution-tools
│   ├─ Has binary protections? → + binary-protection-bypass
│   └─ General deobf only? → code-obfuscation-deobfuscation alone
│
├─ JavaScript code
│   ├─ Known site/framework? → ast-deobfuscation (use detect-patterns.js first)
│   ├─ Control flow flattening in JS? → ast-deobfuscation pipeline
│   └─ General JS obfuscation? → ast-deobfuscation + code-obfuscation-deobfuscation
│
├─ DotNet/Java/Python bytecode
│   └─ vm-and-bytecode-reverse + symbolic-execution-tools
│
├─ CTF challenge
│   └─ ctf-reverse + deep-analysis + relevant sub-skills
│
└─ Unknown / triage needed
    └─ deep-analysis first, then route based on findings
```

## 3. WORKFLOW — Step by Step

### Step 1: Triage (always)
- Identify target type: native binary, JavaScript, bytecode, other
- Identify obfuscation family: CFF, VM, string encryption, packing, JS obfuscator (obfuscator.io, jsfuck, etc.)
- Check for anti-debug/anti-reversing layers
- **Output**: Triage summary with recommended sub-skill combination

### Step 2: Load & Apply
- Based on triage, apply the relevant sub-skill knowledge
- For JavaScript: run `scripts/detect-patterns.js` from ast-deobfuscation to identify site/framework
- For native binaries: identify protector type (VMProtect/Themida/OLLVM/custom)

### Step 3: Deobfuscate
- Apply static deobfuscation first (pattern matching, CFF reduction, string decryption)
- If blocked, pivot to dynamic strategies (debugger scripting, emulation, symbolic execution)
- Use symbolic-execution-tools for automated constraint solving when manual analysis stalls

### Step 4: Validate
- Compare deobfuscated output to original symptoms
- Verify that the deobfuscated code is functionally equivalent
- Check for residual obfuscation layers (nested/stacked protectors)

## 4. CROSS-SKILL COORDINATION

| Situation | Primary Skill | Supporting Skills |
|-----------|--------------|-------------------|
| VMProtect binary with anti-debug | vm-and-bytecode-reverse | anti-debugging-techniques, code-obfuscation-deobfuscation |
| OLLVM CFF binary | code-obfuscation-deobfuscation | symbolic-execution-tools |
| Packed + anti-reverse | code-obfuscation-deobfuscation | anti-reversing-techniques, binary-protection-bypass |
| Heavily obfuscated JS (obfuscator.io) | ast-deobfuscation | code-obfuscation-deobfuscation |
| CTF reverse pwn challenge | ctf-reverse | deep-analysis, all relevant sub-skills |
| Unknown protector, need triage | deep-analysis | code-obfuscation-deobfuscation |

## 5. QUICK REFERENCE — Common Patterns

### Native Binary Deobfuscation Checklist
1. [ ] Identify protector/packer (file, Detect-It-Easy, PEiD)
2. [ ] Check for anti-debug (load anti-debugging-techniques)
3. [ ] Identify obfuscation type (CFF, opaque predicates, string encrypt)
4. [ ] Apply static deobfuscation (scripting, pattern replacement)
5. [ ] If stuck → symbolic execution (load symbolic-execution-tools)
6. [ ] If VM-protected → VM analysis (load vm-and-bytecode-reverse)
7. [ ] Verify deobfuscated output

### JavaScript Deobfuscation Checklist
1. [ ] Run detect-patterns.js from ast-deobfuscation
2. [ ] Identify obfuscation family (obfuscator.io, custom, JSFuck, etc.)
3. [ ] Apply matching pipeline from ast-deobfuscation
4. [ ] For control flow flattening: dispatcher inlining, CFF reduction
5. [ ] For string encryption: inline-literals pass
6. [ ] Re-parse after each transformation stage
7. [ ] Verify output readability and correctness
