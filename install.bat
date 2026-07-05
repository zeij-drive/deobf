@echo off
setlocal enabledelayedexpansion

:: -- Self-remove Mark-of-the-Web (MOTW) --
:: If downloaded from internet, Unblock-File removes the Zone.Identifier ADS.
if exist "%~f0:Zone.Identifier" (
    powershell -c "Unblock-File '%~f0'" 2>nul
)

:: ============================================================
::  deobf-all ??Auto-Install Script (Windows)
::  Flat sequential npx skills add ??no subroutines, no goto.
:: ============================================================

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

:: ???? Install deobf-all dispatcher ????
echo.
echo === Installing deobf-all dispatcher ===
npx skills add zeij-drive/deobf -g -y

:: ???? Install all 26 sub-skills ????
echo.
echo === Installing 26 sub-skills ===

:: P0: Core deobfuscation
npx skills add yaklang/hack-skills --skill code-obfuscation-deobfuscation -g -y
npx skills add lwjjike/xbsreverseskill --skill ast-deobfuscation -g -y

:: P1: Helper deobfuscation (yaklang ecosystem)
npx skills add yaklang/hack-skills --skill vm-and-bytecode-reverse -g -y
npx skills add yaklang/hack-skills --skill anti-debugging-techniques -g -y
npx skills add yaklang/hack-skills --skill symbolic-execution-tools -g -y

:: P2: Supplementary
npx skills add yaklang/hack-skills --skill binary-protection-bypass -g -y
npx skills add ljagiello/ctf-skills --skill ctf-reverse -g -y
npx skills add wshobson/agents --skill anti-reversing-techniques -g -y
npx skills add cyberkaida/reverse-engineering-assistant --skill deep-analysis -g -y

:: P3: Binary deobfuscation add-ons
npx skills add p4nda0s/bin-deobf-skills --skill deobf-string -g -y
npx skills add p4nda0s/bin-deobf-skills --skill deobf-indirect -g -y
npx skills add gmh5225/awesome-llvm-security --skill llvm-obfuscation -g -y
npx skills add gmh5225/awesome-llvm-security --skill binary-lifting -g -y

:: P3: JS / PowerShell deobfuscation
npx skills add mukul975/anthropic-cybersecurity-skills --skill deobfuscating-javascript-malware -g -y
npx skills add mukul975/anthropic-cybersecurity-skills --skill deobfuscating-powershell-obfuscated-malware -g -y

:: P3: Toolchain & binary analysis
npx skills add wshobson/agents --skill binary-analysis-patterns -g -y
npx skills add trailofbits/skills --skill yara-rule-authoring -g -y
npx skills add trailofbits/skills-curated --skill ghidra-headless -g -y
npx skills add yfe404/frida-17-skill --skill frida-17 -g -y
npx skills add mukul975/anthropic-cybersecurity-skills --skill reverse-engineering-malware-with-ghidra -g -y
npx skills add zhaoxuya520/reverse-skill --skill radare2 -g -y

:: P3: Java / Android deobfuscation
npx skills add quarkusio/quarkusdev-skills --skill java-decompile -g -y
npx skills add brownfinesecurity/iothackbot --skill jadx -g -y
npx skills add brownfinesecurity/iothackbot --skill apktool -g -y
npx skills add mukul975/anthropic-cybersecurity-skills --skill reverse-engineering-android-malware-with-jadx -g -y
npx skills add trailofbits/skills --skill firebase-apk-scanner -g -y

:: ???? Done ????
echo.
echo ============================================
echo   All done! Use /deobf-all to activate.
echo ============================================
echo.
pause
