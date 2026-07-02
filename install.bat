@echo off
setlocal enabledelayedexpansion

:: -- Self-remove Mark-of-the-Web (MOTW) --
:: If downloaded from internet via curl, Windows marks the file as untrusted.
:: Unblock-File removes the Zone.Identifier ADS so the script can run.
if exist "%~f0:Zone.Identifier" (
    powershell -c "Unblock-File '%~f0'" 2>nul
)

:: Jump to main, skipping function definitions
goto :main

:: ============================================================
::  Function: install a single skill via npx
::  Arguments: %~1 = repo, %~2 = skill name
:: ============================================================
:install_skill
set "REPO=%~1"
set "SKILL=%~2"
set /a "NUM=SUCCESS+FAILED+1"

:: Skip if already installed and not --force
set "INSTALLED_DIR=%USERPROFILE%\.agents\skills\%SKILL%"
if exist "%INSTALLED_DIR%\SKILL.md" if "!FORCE!"=="0" (
    echo   [%NUM%/%TOTAL%] %SKILL% - already installed, skipping
    set /a SUCCESS+=1
    exit /b
)

if "!DRY_RUN!"=="1" (
    echo   [DRY-RUN] [%NUM%/%TOTAL%] npx skills add %REPO% --skill %SKILL% %GLOBAL_FLAG% -y
    set /a SUCCESS+=1
    exit /b
)

echo   [%NUM%/%TOTAL%] %REPO%: %SKILL% ...
npx skills add %REPO% --skill %SKILL% %GLOBAL_FLAG% -y >nul 2>&1
if !ERRORLEVEL! equ 0 (
    echo     OK
    set /a SUCCESS+=1
) else (
    echo     Retrying with --full-depth...
    npx skills add %REPO% --skill %SKILL% %GLOBAL_FLAG% -y --full-depth >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        echo     OK ^(recovered^)
        set /a SUCCESS+=1
    ) else (
        echo     FAILED - run manually: npx skills add %REPO% --skill %SKILL% %GLOBAL_FLAG% -y
        set /a FAILED+=1
    )
)
exit /b

:: ============================================================
::  Function: print usage
:: ============================================================
:usage
echo Usage: install.bat [--local] [--dry-run] [--force] [--no-deps] [--help]
echo.
echo   --local    Install skills to current project instead of globally
echo   --dry-run  Show what would be installed without installing
echo   --force    Reinstall even if already installed
echo   --no-deps  Only install the deobf-all dispatcher, skip sub-skills
echo   --help     Show this help message
exit /b 0

:: ============================================================
::  Main entry point
:: ============================================================
:main

:: ============================================================
::  deobf-all - Auto-Install Script (Windows)
::  Installs all deobfuscation-related agent skills at once.
::
::  Usage:
::    install.bat              # install all skills (global)
::    install.bat --local      # install to current project only
::    install.bat --dry-run    # preview without installing
::    install.bat --force      # reinstall even if already installed
::    install.bat --no-deps    # skip sub-skills, only install dispatcher
:: ============================================================

set "GLOBAL_FLAG=-g"
set "DRY_RUN=0"
set "FORCE=0"
set "NO_DEPS=0"

:parse_args
if "%~1"=="" goto :args_done
if "%~1"=="--local"    set "GLOBAL_FLAG=" & shift & goto :parse_args
if "%~1"=="--dry-run"  set "DRY_RUN=1"   & shift & goto :parse_args
if "%~1"=="--force"    set "FORCE=1"     & shift & goto :parse_args
if "%~1"=="--no-deps"  set "NO_DEPS=1"   & shift & goto :parse_args
if "%~1"=="--help"     goto :usage
if "%~1"=="-h"         goto :usage
echo Unknown argument: %~1
exit /b 1
:args_done

echo.
echo  ==========================================================
echo          D E O B F - A L L    I N S T A L L E R
echo  ==========================================================
echo.
echo   Deobfuscation Skill Suite - Auto Installer
if "%GLOBAL_FLAG%"=="-g" (
    echo   Mode: global
) else (
    echo   Mode: local ^(current project^)
)
echo   --------------------------------------------
echo.

:: Check npx
where npx >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo   X npx not found. Please install Node.js ^>= 18 first.
    echo     https://nodejs.org/
    exit /b 1
)

:: Show Node version
for /f "tokens=*" %%v in ('node --version 2^>nul') do set "NODE_VER=%%v"
echo   Node.js: %NODE_VER%
echo.

:: Determine install dir
set "SCRIPT_DIR=%~dp0"
if "%GLOBAL_FLAG%"=="" (
    set "SKILL_DIR=%SCRIPT_DIR%.agents\skills\deobf-all"
) else (
    set "SKILL_DIR=%USERPROFILE%\.agents\skills\deobf-all"
)

:: Install deobf-all dispatcher
if exist "%SKILL_DIR%\SKILL.md" if "!FORCE!"=="0" (
    echo   SKIP: deobf-all ^(dispatcher^) already installed at !SKILL_DIR!
) else if "!DRY_RUN!"=="1" (
    echo   [DRY-RUN] Would install: deobf-all to !SKILL_DIR!
) else (
    echo   Installing deobf-all ^(dispatcher^)...
    if not exist "%SKILL_DIR%" mkdir "%SKILL_DIR%"
    if exist "%SCRIPT_DIR%deobf-all\SKILL.md" (
        copy /Y "%SCRIPT_DIR%deobf-all\SKILL.md" "%SKILL_DIR%\SKILL.md" >nul 2>&1
        echo   OK deobf-all installed to !SKILL_DIR! ^(local^)
    ) else (
        echo     ^(local not found, installing via npx skills...^)
        npx skills add zeij-drive/deobf -g -y >nul 2>&1
        echo   OK deobf-all installed via npx skills
    )
)
echo.

:: Skip sub-skills if --no-deps
if "!NO_DEPS!"=="1" (
    echo   --no-deps: skipping sub-skills installation
    echo.
    echo   Done! Dispatcher installed. Use /deobf-all to activate.
    echo.
    exit /b 0
)

:: Install each skill
set /a SUCCESS=0
set /a FAILED=0
set /a TOTAL=26

call :install_skill "yaklang/hack-skills" "code-obfuscation-deobfuscation"
call :install_skill "lwjjike/xbsreverseskill" "ast-deobfuscation"
call :install_skill "yaklang/hack-skills" "vm-and-bytecode-reverse"
call :install_skill "yaklang/hack-skills" "anti-debugging-techniques"
call :install_skill "yaklang/hack-skills" "symbolic-execution-tools"
call :install_skill "yaklang/hack-skills" "binary-protection-bypass"
call :install_skill "ljagiello/ctf-skills" "ctf-reverse"
call :install_skill "wshobson/agents" "anti-reversing-techniques"
call :install_skill "cyberkaida/reverse-engineering-assistant" "deep-analysis"

:: New: Binary deobfuscation add-ons
call :install_skill "p4nda0s/bin-deobf-skills" "deobf-string"
call :install_skill "p4nda0s/bin-deobf-skills" "deobf-indirect"
call :install_skill "gmh5225/awesome-llvm-security" "llvm-obfuscation"
call :install_skill "gmh5225/awesome-llvm-security" "binary-lifting"

:: New: JS / PowerShell deobfuscation
call :install_skill "mukul975/anthropic-cybersecurity-skills" "deobfuscating-javascript-malware"
call :install_skill "mukul975/anthropic-cybersecurity-skills" "deobfuscating-powershell-obfuscated-malware"

:: New: Toolchain & binary analysis
call :install_skill "wshobson/agents" "binary-analysis-patterns"
call :install_skill "trailofbits/skills" "yara-rule-authoring"
call :install_skill "trailofbits/skills-curated" "ghidra-headless"
call :install_skill "yfe404/frida-17-skill" "frida-17"
call :install_skill "mukul975/anthropic-cybersecurity-skills" "reverse-engineering-malware-with-ghidra"
call :install_skill "zhaoxuya520/reverse-skill" "radare2"

:: New: Java / Android deobfuscation
call :install_skill "quarkusio/quarkusdev-skills" "java-decompile"
call :install_skill "brownfinesecurity/iothackbot" "jadx"
call :install_skill "brownfinesecurity/iothackbot" "apktool"
call :install_skill "mukul975/anthropic-cybersecurity-skills" "reverse-engineering-android-malware-with-jadx"
call :install_skill "trailofbits/skills" "firebase-apk-scanner"

:: Summary
echo.
echo   --------------------------------------------
echo   Installed: %SUCCESS% / %TOTAL% sub-skills
if !FAILED! gtr 0 echo   Failed:   %FAILED%
echo.
echo   All done! Use /deobf-all or run_skill^('deobf-all'^) to activate.
echo.
exit /b 0
