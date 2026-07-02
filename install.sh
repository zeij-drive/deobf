#!/usr/bin/env bash
# ============================================================
#  deobf-all — Auto-Install Script
#  Installs all deobfuscation-related agent skills at once.
#
#  Usage:
#    chmod +x install.sh
#    ./install.sh              # install all skills (global)
#    ./install.sh --local      # install to current project only
#    ./install.sh --dry-run    # preview without installing
#    ./install.sh --force      # reinstall even if already installed
#    ./install.sh --no-deps    # skip sub-skills, only install dispatcher
#
#    # One-liner (no clone needed):
#    curl -fsSL https://raw.githubusercontent.com/zeij-drive/deobf/main/install.sh | bash
#
#  Requirements: Node.js >= 18, npm, npx
# ============================================================

set -euo pipefail

# ── Config ───────────────────────────────────────────────────
SKILLS=(
  # ── P0: Core deobfuscation ──
  "yaklang/hack-skills:code-obfuscation-deobfuscation"
  "lwjjike/xbsreverseskill:ast-deobfuscation"

  # ── P1: Helper deobfuscation (yaklang ecosystem) ──
  "yaklang/hack-skills:vm-and-bytecode-reverse"
  "yaklang/hack-skills:anti-debugging-techniques"
  "yaklang/hack-skills:symbolic-execution-tools"

  # ── P2: Supplementary ──
  "yaklang/hack-skills:binary-protection-bypass"
  "ljagiello/ctf-skills:ctf-reverse"
  "wshobson/agents:anti-reversing-techniques"
  "cyberkaida/reverse-engineering-assistant:deep-analysis"

  # ── P3: Binary deobfuscation add-ons ──
  "p4nda0s/bin-deobf-skills:deobf-string"
  "p4nda0s/bin-deobf-skills:deobf-indirect"
  "gmh5225/awesome-llvm-security:llvm-obfuscation"
  "gmh5225/awesome-llvm-security:binary-lifting"

  # ── P3: JS / PowerShell deobfuscation ──
  "mukul975/anthropic-cybersecurity-skills:deobfuscating-javascript-malware"
  "mukul975/anthropic-cybersecurity-skills:deobfuscating-powershell-obfuscated-malware"

  # ── P3: Toolchain & binary analysis ──
  "wshobson/agents:binary-analysis-patterns"
  "trailofbits/skills:yara-rule-authoring"
  "trailofbits/skills-curated:ghidra-headless"
  "yfe404/frida-17-skill:frida-17"
  "mukul975/anthropic-cybersecurity-skills:reverse-engineering-malware-with-ghidra"
  "zhaoxuya520/reverse-skill:radare2"
)

GLOBAL_FLAG="-g"
DRY_RUN=false
FORCE=false
NO_DEPS=false

# ── Args ─────────────────────────────────────────────────────
for arg in "$@"; do
  case "$arg" in
    --local)    GLOBAL_FLAG="" ;;
    --dry-run)  DRY_RUN=true ;;
    --force)    FORCE=true ;;
    --no-deps)  NO_DEPS=true ;;
    --help|-h)
      echo "Usage: $0 [--local] [--dry-run] [--force] [--no-deps]"
      echo ""
      echo "  --local    Install skills to current project instead of globally"
      echo "  --dry-run  Show what would be installed without installing"
      echo "  --force    Reinstall even if already installed"
      echo "  --no-deps  Only install the deobf-all dispatcher, skip sub-skills"
      echo "  --help     Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg"
      exit 1
      ;;
  esac
done

# ── Banner ───────────────────────────────────────────────────
echo ""
echo "  ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗ ██████╗"
echo "  ██╔══██╗██╔════╝██╔════╝██╔═╗██║██╔████╗██║██╔════╝"
echo "  ██║  ██║█████╗  ██║     ██║██╗██║██╔██║██║██║  ███╗"
echo "  ██║  ██║██╔══╝  ██║     ██║██████║██║╚██║██║   ██║"
echo "  ██████╔╝███████╗╚██████╗╚███╔██║██║ ╚████║╚██████╔╝"
echo "  ╚═════╝ ╚══════╝ ╚═════╝ ╚══╝╚═╝╚═╝  ╚═══╝ ╚═════╝"
echo ""
echo "  Deobfuscation Skill Suite — Auto Installer"
if [ "$GLOBAL_FLAG" = "-g" ]; then
  echo "  Mode: global"
else
  echo "  Mode: local (current project)"
fi
echo "  ————————————————————————————————————————————"
echo ""

# ── Check npx ───────────────────────────────────────────────
if ! command -v npx &>/dev/null; then
  echo "  ❌ npx not found. Please install Node.js >= 18 first."
  echo "     https://nodejs.org/"
  exit 1
fi

NODE_VERSION="$(node --version 2>/dev/null || echo 'unknown')"
echo "  Node.js: $NODE_VERSION"
echo ""

# ── Determine install dir ────────────────────────────────────
SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd 2>/dev/null || true)"
elif [ -f "$0" ] && [ "${0#-}" = "$0" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd 2>/dev/null || true)"
fi

if [ -z "$GLOBAL_FLAG" ]; then
  if [ -n "$SCRIPT_DIR" ]; then
    SKILL_DIR="${SCRIPT_DIR}/.agents/skills/deobf-all"
  else
    echo "  ⚠️  --local requires a local script; falling back to global"
    GLOBAL_FLAG="-g"
    SKILL_DIR="${HOME}/.agents/skills/deobf-all"
  fi
else
  SKILL_DIR="${HOME}/.agents/skills/deobf-all"
fi

# ── Install deobf-all dispatcher skill ──────────────────────
if [ -d "$SKILL_DIR" ] && ! $FORCE; then
  echo "  ⏩ deobf-all (dispatcher) already installed at $SKILL_DIR — skipping"
elif $DRY_RUN; then
  echo "  🔍 [DRY-RUN] Would install: deobf-all dispatcher"
else
  echo "  📦 Installing deobf-all (dispatcher)..."
  mkdir -p "$SKILL_DIR"
  if [ -f "${SCRIPT_DIR:-.}/deobf-all/SKILL.md" ]; then
    cp "${SCRIPT_DIR}/deobf-all/SKILL.md" "$SKILL_DIR/SKILL.md"
    echo "  ✅ deobf-all installed → $SKILL_DIR (local)"
  else
    # Fallback: install via npx skills (works with curl|bash too)
    echo "     (local not found, installing via npx skills...)"
    npx skills add zeij-drive/deobf -g -y &>/dev/null
    echo "  ✅ deobf-all installed via npx skills add zeij-drive/deobf"
  fi
fi
echo ""

# ── Install sub-skills ──────────────────────────────────────
if $NO_DEPS; then
  echo "  ⏭️  --no-deps: skipping sub-skills installation"
  echo ""
  echo "  🚀 Done! Dispatcher installed. Use /deobf-all to activate."
  echo ""
  exit 0
fi

SUCCESS=0
FAILED=0
TOTAL=${#SKILLS[@]}
CURRENT=0

for entry in "${SKILLS[@]}"; do
  REPO="${entry%%:*}"
  SKILL="${entry##*:}"
  CURRENT=$((CURRENT + 1))

  if $DRY_RUN; then
    echo "  🔍 [DRY-RUN] [$CURRENT/$TOTAL] npx skills add $REPO --skill $SKILL $GLOBAL_FLAG -y"
    SUCCESS=$((SUCCESS + 1))
    continue
  fi

  # Skip if already installed and not --force
  INSTALLED_DIR="${HOME}/.agents/skills/${SKILL}"
  if [ -d "$INSTALLED_DIR" ] && ! $FORCE; then
    echo "  ⏩ [$CURRENT/$TOTAL] $SKILL — already installed, skipping"
    SUCCESS=$((SUCCESS + 1))
    continue
  fi

  printf "  📦 [%d/%d] %-42s → %-32s ... " "$CURRENT" "$TOTAL" "$REPO" "$SKILL"

  if npx skills add "$REPO" --skill "$SKILL" $GLOBAL_FLAG -y &>/dev/null; then
    echo "✅"
    SUCCESS=$((SUCCESS + 1))
  else
    echo "❌ (retrying --full-depth...)"
    if npx skills add "$REPO" --skill "$SKILL" $GLOBAL_FLAG -y --full-depth &>/dev/null 2>&1; then
      echo "         ✅ (recovered)"
      SUCCESS=$((SUCCESS + 1))
    else
      echo "         ❌ Failed — run manually: npx skills add $REPO --skill $SKILL $GLOBAL_FLAG -y"
      FAILED=$((FAILED + 1))
    fi
  fi
done

# ── Summary ──────────────────────────────────────────────────
echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🎯 Installed: $SUCCESS / $TOTAL sub-skills"
if [ "$FAILED" -gt 0 ]; then
  echo "  ⚠️  Failed:   $FAILED — see manual commands above"
fi
echo ""
echo "  🚀 All done! Use /deobf-all or run_skill('deobf-all') to activate."
echo ""
