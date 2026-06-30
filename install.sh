#!/usr/bin/env bash
# ============================================================
#  deobf-all — Auto-Install Script
#  Installs all deobfuscation-related agent skills at once.
#
#  Usage:
#    chmod +x install.sh
#    ./install.sh            # install all skills (global)
#    ./install.sh --local    # install to current project only
#    ./install.sh --dry-run  # preview without installing
#
#  Requirements: Node.js >= 18, npm, npx
# ============================================================

set -euo pipefail

# ── Config ───────────────────────────────────────────────────
SKILLS=(
  # ── Core deobfuscation ──
  "yaklang/hack-skills:code-obfuscation-deobfuscation"
  "lwjjike/xbsreverseskill:ast-deobfuscation"

  # ── Helper deobfuscation (yaklang ecosystem) ──
  "yaklang/hack-skills:vm-and-bytecode-reverse"
  "yaklang/hack-skills:anti-debugging-techniques"
  "yaklang/hack-skills:symbolic-execution-tools"
  "yaklang/hack-skills:binary-protection-bypass"

  # ── Supplementary reverse engineering ──
  "ljagiello/ctf-skills:ctf-reverse"
  "wshobson/agents:anti-reversing-techniques"
  "cyberkaida/reverse-engineering-assistant:deep-analysis"
)

GLOBAL_FLAG="-g"
DRY_RUN=false

# ── Args ─────────────────────────────────────────────────────
for arg in "$@"; do
  case "$arg" in
    --local)  GLOBAL_FLAG="" ;;
    --dry-run) DRY_RUN=true ;;
    --help|-h)
      echo "Usage: $0 [--local] [--dry-run]"
      echo ""
      echo "  --local    Install skills to current project instead of globally"
      echo "  --dry-run  Show what would be installed without installing"
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
echo "  ██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║██╔════╝"
echo "  ██║  ██║█████╗  ██║     ██║   ██║██╔██╗ ██║██║  ███╗"
echo "  ██║  ██║██╔══╝  ██║     ██║   ██║██║╚██╗██║██║   ██║"
echo "  ██████╔╝███████╗╚██████╗╚██████╔╝██║ ╚████║╚██████╔╝"
echo "  ╚═════╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝"
echo ""
echo "  Deobfuscation Skill Suite — Auto Installer"
echo "  ————————————————————————————————————————————"
echo ""

# ── Check npx ───────────────────────────────────────────────
if ! command -v npx &>/dev/null; then
  echo "❌ npx not found. Please install Node.js >= 18 first."
  echo "   https://nodejs.org/"
  exit 1
fi

# ── Install deobf-all dispatcher skill ──────────────────────
SKILL_DIR="${HOME}/.agents/skills/deobf-all"
if [ -d "$SKILL_DIR" ]; then
  echo "  ⏩ deobf-all (dispatcher) already installed — skipping"
else
  if $DRY_RUN; then
    echo "  🔍 [DRY-RUN] Would install: deobf-all (dispatcher skill from local repo)"
  else
    echo "  📦 Installing deobf-all (dispatcher skill)..."
    mkdir -p "$SKILL_DIR"
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    if [ -f "$SCRIPT_DIR/deobf-all/SKILL.md" ]; then
      cp "$SCRIPT_DIR/deobf-all/SKILL.md" "$SKILL_DIR/SKILL.md"
      echo "  ✅ deobf-all installed from local repo"
    else
      echo "  ⚠️  deobf-all/SKILL.md not found in repo — you may need to install manually"
    fi
  fi
fi
echo ""

# ── Install each skill ──────────────────────────────────────
SUCCESS=0
FAILED=0
TOTAL=${#SKILLS[@]}

for entry in "${SKILLS[@]}"; do
  REPO="${entry%%:*}"
  SKILL="${entry##*:}"

  if $DRY_RUN; then
    echo "  🔍 [DRY-RUN] npx skills add $REPO --skill $SKILL $GLOBAL_FLAG -y"
    SUCCESS=$((SUCCESS + 1))
    continue
  fi

  printf "  📦 [%2d/%d] %-40s → %-30s ... " "$((SUCCESS + FAILED + 1))" "$TOTAL" "$REPO" "$SKILL"

  if npx skills add "$REPO" --skill "$SKILL" $GLOBAL_FLAG -y &>/dev/null; then
    echo "✅"
    SUCCESS=$((SUCCESS + 1))
  else
    echo "❌ (retrying with full depth...)"
    # Retry once without shallow clone issues
    if npx skills add "$REPO" --skill "$SKILL" $GLOBAL_FLAG -y --full-depth &>/dev/null 2>&1; then
      echo "    ✅ (recovered on retry)"
      SUCCESS=$((SUCCESS + 1))
    else
      echo "    ❌ Failed — install manually: npx skills add $REPO --skill $SKILL $GLOBAL_FLAG -y"
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
