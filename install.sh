#!/usr/bin/env bash
# deobf-all auto installer.
# Default mode is global. Use --local for workspace-only installs.

set -euo pipefail

REMOTE_REPO="zeij-drive/deobf"
DISPATCHER_SKILL="deobf-all"

SKILLS=(
  "yaklang/hack-skills:code-obfuscation-deobfuscation"
  "lwjjike/xbsreverseskill:ast-deobfuscation"
  "yaklang/hack-skills:vm-and-bytecode-reverse"
  "yaklang/hack-skills:anti-debugging-techniques"
  "yaklang/hack-skills:symbolic-execution-tools"
  "yaklang/hack-skills:binary-protection-bypass"
  "ljagiello/ctf-skills:ctf-reverse"
  "wshobson/agents:anti-reversing-techniques"
  "cyberkaida/reverse-engineering-assistant:deep-analysis"
  "p4nda0s/bin-deobf-skills:deobf-string"
  "p4nda0s/bin-deobf-skills:deobf-indirect"
  "gmh5225/awesome-llvm-security:llvm-obfuscation"
  "gmh5225/awesome-llvm-security:binary-lifting"
  "mukul975/anthropic-cybersecurity-skills:deobfuscating-javascript-malware"
  "mukul975/anthropic-cybersecurity-skills:deobfuscating-powershell-obfuscated-malware"
  "wshobson/agents:binary-analysis-patterns"
  "trailofbits/skills:yara-rule-authoring"
  "trailofbits/skills-curated:ghidra-headless"
  "yfe404/frida-17-skill:frida-17"
  "mukul975/anthropic-cybersecurity-skills:reverse-engineering-malware-with-ghidra"
  "zhaoxuya520/reverse-skill:radare2"
  "quarkusio/quarkusdev-skills:java-decompile"
  "brownfinesecurity/iothackbot:jadx"
  "brownfinesecurity/iothackbot:apktool"
  "mukul975/anthropic-cybersecurity-skills:reverse-engineering-android-malware-with-jadx"
  "trailofbits/skills:firebase-apk-scanner"
)

MODE="global"
GLOBAL_FLAG="-g"
DRY_RUN=false
FORCE=false
NO_DEPS=false

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --global   Install skills globally (default)
  --local    Install skills to the current workspace only
  --dry-run  Show what would be installed without installing
  --force    Reinstall even if a skill directory already exists
  --no-deps  Install only the deobf-all dispatcher
  --help     Show this help message
EOF
}

for arg in "$@"; do
  case "$arg" in
    --global|-g)
      MODE="global"
      GLOBAL_FLAG="-g"
      ;;
    --local)
      MODE="local"
      GLOBAL_FLAG=""
      ;;
    --dry-run)
      DRY_RUN=true
      ;;
    --force)
      FORCE=true
      ;;
    --no-deps)
      NO_DEPS=true
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      usage >&2
      exit 1
      ;;
  esac
done

SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [ -f "$0" ] && [ "${0#-}" = "$0" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

if [ "$MODE" = "global" ]; then
  SKILL_ROOT="${HOME}/.agents/skills"
else
  SKILL_ROOT="${PWD}/.agents/skills"
fi

DISPATCHER_DIR="${SKILL_ROOT}/${DISPATCHER_SKILL}"
LOCAL_DISPATCHER=""
if [ -n "$SCRIPT_DIR" ] && [ -f "${SCRIPT_DIR}/${DISPATCHER_SKILL}/SKILL.md" ]; then
  LOCAL_DISPATCHER="${SCRIPT_DIR}/${DISPATCHER_SKILL}/SKILL.md"
fi

echo ""
echo "deobf-all installer"
echo "Mode: $MODE"
echo "Skill root: $SKILL_ROOT"
echo ""

if ! $DRY_RUN; then
  if ! command -v npx >/dev/null 2>&1; then
    echo "npx not found. Please install Node.js >= 18 first." >&2
    exit 1
  fi

  NODE_VERSION="$(node --version 2>/dev/null || echo 'unknown')"
  echo "Node.js: $NODE_VERSION"
  echo ""
fi

run_skills_add() {
  local repo="$1"
  local skill="$2"
  local extra_arg="${3:-}"
  local cmd=(npx skills add "$repo" --skill "$skill")

  if [ -n "$GLOBAL_FLAG" ]; then
    cmd+=("$GLOBAL_FLAG")
  fi

  cmd+=(-y)

  if [ -n "$extra_arg" ]; then
    cmd+=("$extra_arg")
  fi

  "${cmd[@]}"
}

copy_dispatcher_from_local() {
  mkdir -p "$DISPATCHER_DIR"
  cp "$LOCAL_DISPATCHER" "${DISPATCHER_DIR}/SKILL.md"
}

install_dispatcher() {
  if [ -f "${DISPATCHER_DIR}/SKILL.md" ] && ! $FORCE; then
    echo "[skip] ${DISPATCHER_SKILL} already installed at ${DISPATCHER_DIR}"
    return 0
  fi

  if $DRY_RUN; then
    if [ -n "$LOCAL_DISPATCHER" ]; then
      echo "[dry-run] install ${DISPATCHER_SKILL} from local repo to ${DISPATCHER_DIR}"
    else
      echo "[dry-run] npx skills add ${REMOTE_REPO} --skill ${DISPATCHER_SKILL} ${GLOBAL_FLAG} -y"
    fi
    return 0
  fi

  echo "Installing ${DISPATCHER_SKILL} dispatcher..."

  if [ -n "$LOCAL_DISPATCHER" ]; then
    if run_skills_add "$SCRIPT_DIR" "$DISPATCHER_SKILL" >/dev/null 2>&1; then
      echo "[ok] ${DISPATCHER_SKILL} installed via npx from local repo"
      return 0
    fi

    echo "[warn] npx local install failed; copying SKILL.md directly"
    copy_dispatcher_from_local
    echo "[ok] ${DISPATCHER_SKILL} copied to ${DISPATCHER_DIR}"
    return 0
  fi

  if run_skills_add "$REMOTE_REPO" "$DISPATCHER_SKILL" >/dev/null 2>&1; then
    echo "[ok] ${DISPATCHER_SKILL} installed from ${REMOTE_REPO}"
    return 0
  fi

  echo "[warn] dispatcher install failed; retrying with --full-depth"
  if run_skills_add "$REMOTE_REPO" "$DISPATCHER_SKILL" "--full-depth" >/dev/null 2>&1; then
    echo "[ok] ${DISPATCHER_SKILL} installed from ${REMOTE_REPO}"
    return 0
  fi

  echo "[error] Failed to install ${DISPATCHER_SKILL}" >&2
  echo "        Try: npx skills add ${REMOTE_REPO} --skill ${DISPATCHER_SKILL} ${GLOBAL_FLAG} -y" >&2
  return 1
}

SUCCESS=0
FAILED=0
TOTAL=${#SKILLS[@]}
CURRENT=0

install_subskill() {
  local entry="$1"
  local repo="${entry%%:*}"
  local skill="${entry##*:}"
  local installed_dir="${SKILL_ROOT}/${skill}"

  CURRENT=$((CURRENT + 1))

  if $DRY_RUN; then
    printf '[dry-run] [%d/%d] npx skills add %s --skill %s %s -y\n' \
      "$CURRENT" "$TOTAL" "$repo" "$skill" "$GLOBAL_FLAG"
    SUCCESS=$((SUCCESS + 1))
    return 0
  fi

  if [ -d "$installed_dir" ] && ! $FORCE; then
    printf '[skip] [%d/%d] %s already installed\n' "$CURRENT" "$TOTAL" "$skill"
    SUCCESS=$((SUCCESS + 1))
    return 0
  fi

  printf '[install] [%d/%d] %-42s -> %-44s ' "$CURRENT" "$TOTAL" "$repo" "$skill"

  if run_skills_add "$repo" "$skill" >/dev/null 2>&1; then
    echo "ok"
    SUCCESS=$((SUCCESS + 1))
    return 0
  fi

  printf 'retry... '
  if run_skills_add "$repo" "$skill" "--full-depth" >/dev/null 2>&1; then
    echo "ok"
    SUCCESS=$((SUCCESS + 1))
    return 0
  fi

  echo "failed"
  echo "         Try: npx skills add ${repo} --skill ${skill} ${GLOBAL_FLAG} -y" >&2
  FAILED=$((FAILED + 1))
  return 0
}

install_dispatcher
echo ""

if $NO_DEPS; then
  echo "--no-deps: skipped sub-skills"
  echo "Done. Use /deobf-all to activate."
  exit 0
fi

echo "Installing ${TOTAL} sub-skills..."
for entry in "${SKILLS[@]}"; do
  install_subskill "$entry"
done

echo ""
echo "Installed sub-skills: ${SUCCESS}/${TOTAL}"
if [ "$FAILED" -gt 0 ]; then
  echo "Failed sub-skills: ${FAILED}"
  exit 1
fi

echo "Done. Use /deobf-all or run_skill('deobf-all') to activate."
