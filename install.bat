@echo off
setlocal enabledelayedexpansion

:: ============================================================
::  deobf-all — Auto-Install Script (Windows)
::  Installs all deobfuscation-related agent skills at once.
::  Flat sequential npx skills add — no subroutines, no goto.
::
::  Usage:
::    install.bat              # install all skills (global)
::    install.bat --local      # install to current project only
::    install.bat --dry-run    # preview without installing
::    install.bat --force      # reinstall even if already installed
::    install.bat --no-deps    # skip sub-skills, only install dispatcher
::    install.bat --help       # show this help message
::
::  One-liner (no clone needed, PowerShell — handles MOTW):
::    powershell -c "iwr -useb https://raw.githubusercontent.com/zeij-drive/deobf/main/install.bat -outf $env:TEMP\deobf.bat; Unblock-File $env:TEMP\deobf.bat; cmd /c $env:TEMP\deobf.bat"
::
::  One-liner (no clone needed, curl — Windows 10+):
::    curl -fsSLo %temp%\deobf.bat https://raw.githubusercontent.com/zeij-drive/deobf/main/install.bat && "%temp%\deobf.bat"
::
::  Requirements: Node.js >= 18, npm, npx
:: ============================================================

:: -- Self-remove Mark-of-the-Web (MOTW) --
:: If downloaded from internet, Unblock-File removes the Zone.Identifier ADS.
if exist "%~f0:Zone.Identifier" (
    powershell -c "Unblock-File '%~f0'" 2>nul
)

:: Check npx
where npx >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo X npx not found. Please install Node.js ^>= 18 first.
    echo   https://nodejs.org/
    pause
    exit /b 1
)

:: Show Node version
for /f "tokens=*" %%v in ('node --version 2^>nul') do set "NODE_VER=%%v"
echo Node.js: %NODE_VER%
echo.

:: ── Banner ──
echo.
echo   ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗ ██████╗
echo   ██╔══██╗██╔════╝██╔════╝██╔═╗██║██╔████╗██║██╔════╝
echo   ██║  ██║█████╗  ██║     ██║██╗██║██╔██║██║██║  ███╗
echo   ██║  ██║██╔══╝  ██║     ██║██████║██║╚██║██║   ██║
echo   ██████╔╝███████╗╚██████╗╚███╔██║██║ ╚████║╚██████╔╝
echo   ╚═════╝ ╚══════╝ ╚═════╝ ╚══╝╚═╝╚═╝  ╚═══╝ ╚═════╝
echo.
echo   Deobfuscation Skill Suite — Auto Installer
echo   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.

:: === Install deobf-all dispatcher ===
echo === Installing deobf-all dispatcher ===
call npx skills add zeij-drive/deobf -g -y
if errorlevel 1 (
    echo   ⚠️  Dispatcher install failed, retrying...
    call npx skills add zeij-drive/deobf -g -y --full-depth
)
echo.

:: === Install all 26 sub-skills with progress ===
echo === Installing 26 sub-skills ===
echo.

set SUCCESS=0
set FAILED=0
set TOTAL=26
set CURRENT=0

:: ── P0: Core deobfuscation ──
set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] code-obfuscation-deobfuscation ........ "
call npx skills add yaklang/hack-skills --skill code-obfuscation-deobfuscation -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] ast-deobfuscation .................... "
call npx skills add lwjjike/xbsreverseskill --skill ast-deobfuscation -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

:: ── P1: Helper deobfuscation (yaklang ecosystem) ──
set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] vm-and-bytecode-reverse ............. "
call npx skills add yaklang/hack-skills --skill vm-and-bytecode-reverse -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] anti-debugging-techniques .......... "
call npx skills add yaklang/hack-skills --skill anti-debugging-techniques -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] symbolic-execution-tools ........... "
call npx skills add yaklang/hack-skills --skill symbolic-execution-tools -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

:: ── P2: Supplementary ──
set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] binary-protection-bypass .......... "
call npx skills add yaklang/hack-skills --skill binary-protection-bypass -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] ctf-reverse ....................... "
call npx skills add ljagiello/ctf-skills --skill ctf-reverse -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] anti-reversing-techniques ......... "
call npx skills add wshobson/agents --skill anti-reversing-techniques -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] deep-analysis ..................... "
call npx skills add cyberkaida/reverse-engineering-assistant --skill deep-analysis -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

:: ── P3: Binary deobfuscation add-ons ──
set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] deobf-string ...................... "
call npx skills add p4nda0s/bin-deobf-skills --skill deobf-string -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] deobf-indirect .................... "
call npx skills add p4nda0s/bin-deobf-skills --skill deobf-indirect -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] llvm-obfuscation .................. "
call npx skills add gmh5225/awesome-llvm-security --skill llvm-obfuscation -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] binary-lifting .................... "
call npx skills add gmh5225/awesome-llvm-security --skill binary-lifting -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

:: ── P3: JS / PowerShell deobfuscation ──
set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] deobfuscating-javascript-malware .. "
call npx skills add mukul975/anthropic-cybersecurity-skills --skill deobfuscating-javascript-malware -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] deobfuscating-powershell-obfuscated-malware "
call npx skills add mukul975/anthropic-cybersecurity-skills --skill deobfuscating-powershell-obfuscated-malware -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

:: ── P3: Toolchain & binary analysis ──
set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] binary-analysis-patterns ........... "
call npx skills add wshobson/agents --skill binary-analysis-patterns -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] yara-rule-authoring ............... "
call npx skills add trailofbits/skills --skill yara-rule-authoring -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] ghidra-headless ................... "
call npx skills add trailofbits/skills-curated --skill ghidra-headless -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] frida-17 .......................... "
call npx skills add yfe404/frida-17-skill --skill frida-17 -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] reverse-engineering-malware-with-ghidra "
call npx skills add mukul975/anthropic-cybersecurity-skills --skill reverse-engineering-malware-with-ghidra -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] radare2 ........................... "
call npx skills add zhaoxuya520/reverse-skill --skill radare2 -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

:: ── P3: Java / Android deobfuscation ──
set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] java-decompile .................... "
call npx skills add quarkusio/quarkusdev-skills --skill java-decompile -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] jadx .............................. "
call npx skills add brownfinesecurity/iothackbot --skill jadx -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] apktool ........................... "
call npx skills add brownfinesecurity/iothackbot --skill apktool -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] reverse-engineering-android-malware-with-jadx "
call npx skills add mukul975/anthropic-cybersecurity-skills --skill reverse-engineering-android-malware-with-jadx -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

set /a CURRENT+=1
<nul set /p="  [!CURRENT!/%TOTAL%] firebase-apk-scanner .............. "
call npx skills add trailofbits/skills --skill firebase-apk-scanner -g -y >nul 2>&1
if errorlevel 1 (echo ❌ & set /a FAILED+=1) else (echo ✅ & set /a SUCCESS+=1)

:: ── Summary ──
echo.
echo ============================================
echo   🎯 Installed: !SUCCESS! / %TOTAL% sub-skills
if !FAILED! gtr 0 echo   ⚠️  Failed:   !FAILED! — see errors above
echo.
echo   🚀 All done! Use /deobf-all to activate.
echo ============================================
echo.
