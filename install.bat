@echo off
setlocal enabledelayedexpansion

:: ============================================================
::  deobf-all — Auto-Install Script (Windows)
::  Installs all deobfuscation-related agent skills at once.
::
::  Usage:
::    install.bat            # install all skills (global)
::    install.bat --local    # install to current project only
::    install.bat --dry-run  # preview without installing
:: ============================================================

set "GLOBAL_FLAG=-g"
set "DRY_RUN=0"

if "%~1"=="--local" set "GLOBAL_FLAG="
if "%~1"=="--dry-run" set "DRY_RUN=1"
if "%~1"=="--help" goto :usage
if "%~1"=="-h" goto :usage

echo.
echo   ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗ ██████╗
echo   ██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║██╔════╝
echo   ██║  ██║█████╗  ██║     ██║   ██║██╔██╗ ██║██║  ███╗
echo   ██║  ██║██╔══╝  ██║     ██║   ██║██║╚██╗██║██║   ██║
echo   ██████╔╝███████╗╚██████╗╚██████╔╝██║ ╚████║╚██████╔╝
echo   ╚═════╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝
echo.
echo   Deobfuscation Skill Suite - Auto Installer
echo   --------------------------------------------
echo.

:: Check npx
where npx >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo   X npx not found. Please install Node.js ^>= 18 first.
    echo     https://nodejs.org/
    exit /b 1
)

:: Install deobf-all dispatcher
set "SKILL_DIR=%USERPROFILE%\.agents\skills\deobf-all"
if exist "%SKILL_DIR%" (
    echo   SKIP: deobf-all ^(dispatcher^) already installed
) else (
    if "!DRY_RUN!"=="1" (
        echo   [DRY-RUN] Would install: deobf-all
    ) else (
        echo   Installing deobf-all ^(dispatcher^)...
        if not exist "%SKILL_DIR%" mkdir "%SKILL_DIR%"
        copy /Y "%~dp0deobf-all\SKILL.md" "%SKILL_DIR%\SKILL.md" >nul 2>&1
        echo   OK deobf-all installed from local repo
    )
)
echo.

:: Install each skill
set /a SUCCESS=0
set /a FAILED=0
set /a TOTAL=9

call :install_skill "yaklang/hack-skills" "code-obfuscation-deobfuscation"
call :install_skill "lwjjike/xbsreverseskill" "ast-deobfuscation"
call :install_skill "yaklang/hack-skills" "vm-and-bytecode-reverse"
call :install_skill "yaklang/hack-skills" "anti-debugging-techniques"
call :install_skill "yaklang/hack-skills" "symbolic-execution-tools"
call :install_skill "yaklang/hack-skills" "binary-protection-bypass"
call :install_skill "ljagiello/ctf-skills" "ctf-reverse"
call :install_skill "wshobson/agents" "anti-reversing-techniques"
call :install_skill "cyberkaida/reverse-engineering-assistant" "deep-analysis"

echo.
echo   --------------------------------------------
echo   Installed: %SUCCESS% / %TOTAL% sub-skills
if !FAILED! gtr 0 echo   Failed:   %FAILED%
echo.
echo   All done! Use /deobf-all or run_skill^('deobf-all'^) to activate.
echo.
exit /b 0

:install_skill
set "REPO=%~1"
set "SKILL=%~2"
set /a "NUM=SUCCESS+FAILED+1"
if "!DRY_RUN!"=="1" (
    echo   [DRY-RUN] npx skills add %REPO% --skill %SKILL% %GLOBAL_FLAG% -y
    set /a SUCCESS+=1
) else (
    echo   [%NUM%/%TOTAL%] %REPO%: %SKILL% ...
    npx skills add %REPO% --skill %SKILL% %GLOBAL_FLAG% -y >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        echo     OK
        set /a SUCCESS+=1
    ) else (
        echo     FAILED - install manually: npx skills add %REPO% --skill %SKILL% %GLOBAL_FLAG% -y
        set /a FAILED+=1
    )
)
exit /b 0

:usage
echo Usage: install.bat [--local] [--dry-run] [--help]
echo.
echo   --local    Install skills to current project instead of globally
echo   --dry-run  Show what would be installed without installing
echo   --help     Show this help message
exit /b 0
