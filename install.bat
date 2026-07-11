@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem deobf-all auto installer for Windows.
rem Default mode is global. Use --local for workspace-only installs.

set "REMOTE_REPO=zeij-drive/deobf"
set "DISPATCHER_SKILL=deobf-all"
set "MODE=global"
set "GLOBAL_FLAG=-g"
set "DRY_RUN=0"
set "FORCE=0"
set "NO_DEPS=0"
set "TOTAL=26"
set "CURRENT=0"
set "SUCCESS=0"
set "FAILED=0"
set "SCRIPT_DIR=%~dp0"

:parse_args
if "%~1"=="" goto args_done
if /I "%~1"=="--global" (
    set "MODE=global"
    set "GLOBAL_FLAG=-g"
    shift
    goto parse_args
)
if /I "%~1"=="-g" (
    set "MODE=global"
    set "GLOBAL_FLAG=-g"
    shift
    goto parse_args
)
if /I "%~1"=="--local" (
    set "MODE=local"
    set "GLOBAL_FLAG="
    shift
    goto parse_args
)
if /I "%~1"=="--dry-run" (
    set "DRY_RUN=1"
    shift
    goto parse_args
)
if /I "%~1"=="--force" (
    set "FORCE=1"
    shift
    goto parse_args
)
if /I "%~1"=="--no-deps" (
    set "NO_DEPS=1"
    shift
    goto parse_args
)
if /I "%~1"=="--help" (
    call :Usage
    exit /b 0
)
if /I "%~1"=="-h" (
    call :Usage
    exit /b 0
)

echo Unknown argument: %~1
call :Usage
exit /b 1

:args_done
if /I "%MODE%"=="global" (
    set "SKILL_ROOT=%USERPROFILE%\.agents\skills"
) else (
    set "SKILL_ROOT=%CD%\.agents\skills"
)

echo.
echo deobf-all installer
echo Mode: %MODE%
echo Skill root: %SKILL_ROOT%
echo.

if not "%DRY_RUN%"=="1" (
    where npx >nul 2>&1
    if errorlevel 1 (
        echo npx not found. Please install Node.js ^>= 18 first.
        exit /b 1
    )

    for /f "tokens=*" %%v in ('node --version 2^>nul') do set "NODE_VER=%%v"
    echo Node.js: !NODE_VER!
    echo.
)

call :InstallDispatcher
if errorlevel 1 exit /b 1
echo.

if "%NO_DEPS%"=="1" (
    echo --no-deps: skipped sub-skills
    echo Done. Use /deobf-all to activate.
    exit /b 0
)

echo Installing %TOTAL% sub-skills...
for %%E in (
    yaklang/hack-skills:code-obfuscation-deobfuscation
    lwjjike/xbsreverseskill:ast-deobfuscation
    yaklang/hack-skills:vm-and-bytecode-reverse
    yaklang/hack-skills:anti-debugging-techniques
    yaklang/hack-skills:symbolic-execution-tools
    yaklang/hack-skills:binary-protection-bypass
    ljagiello/ctf-skills:ctf-reverse
    wshobson/agents:anti-reversing-techniques
    cyberkaida/reverse-engineering-assistant:deep-analysis
    p4nda0s/bin-deobf-skills:deobf-string
    p4nda0s/bin-deobf-skills:deobf-indirect
    gmh5225/awesome-llvm-security:llvm-obfuscation
    gmh5225/awesome-llvm-security:binary-lifting
    mukul975/anthropic-cybersecurity-skills:deobfuscating-javascript-malware
    mukul975/anthropic-cybersecurity-skills:deobfuscating-powershell-obfuscated-malware
    wshobson/agents:binary-analysis-patterns
    trailofbits/skills:yara-rule-authoring
    trailofbits/skills-curated:ghidra-headless
    yfe404/frida-17-skill:frida-17
    mukul975/anthropic-cybersecurity-skills:reverse-engineering-malware-with-ghidra
    zhaoxuya520/reverse-skill:radare2
    quarkusio/quarkusdev-skills:java-decompile
    brownfinesecurity/iothackbot:jadx
    brownfinesecurity/iothackbot:apktool
    mukul975/anthropic-cybersecurity-skills:reverse-engineering-android-malware-with-jadx
    trailofbits/skills:firebase-apk-scanner
) do call :InstallSubskill "%%E"

echo.
echo Installed sub-skills: !SUCCESS!/%TOTAL%
if !FAILED! gtr 0 (
    echo Failed sub-skills: !FAILED!
    exit /b 1
)

echo Done. Use /deobf-all or run_skill('deobf-all') to activate.
exit /b 0

:Usage
echo Usage: install.bat [options]
echo.
echo Options:
echo   --global   Install skills globally (default)
echo   --local    Install skills to the current workspace only
echo   --dry-run  Show what would be installed without installing
echo   --force    Reinstall even if a skill directory already exists
echo   --no-deps  Install only the deobf-all dispatcher
echo   --help     Show this help message
exit /b 0

:RunSkillsAdd
set "RSA_REPO=%~1"
set "RSA_SKILL=%~2"
set "RSA_EXTRA=%~3"

if defined RSA_EXTRA (
    call npx skills add "%RSA_REPO%" --skill "%RSA_SKILL%" %GLOBAL_FLAG% -y %RSA_EXTRA% >nul 2>&1
) else (
    call npx skills add "%RSA_REPO%" --skill "%RSA_SKILL%" %GLOBAL_FLAG% -y >nul 2>&1
)
exit /b %ERRORLEVEL%

:InstallDispatcher
set "DISPATCHER_DIR=%SKILL_ROOT%\%DISPATCHER_SKILL%"
set "LOCAL_DISPATCHER=%SCRIPT_DIR%%DISPATCHER_SKILL%\SKILL.md"

if exist "%DISPATCHER_DIR%\SKILL.md" if not "%FORCE%"=="1" (
    echo [skip] %DISPATCHER_SKILL% already installed at %DISPATCHER_DIR%
    exit /b 0
)

if "%DRY_RUN%"=="1" (
    if exist "%LOCAL_DISPATCHER%" (
        echo [dry-run] install %DISPATCHER_SKILL% from local repo to %DISPATCHER_DIR%
    ) else (
        echo [dry-run] npx skills add %REMOTE_REPO% --skill %DISPATCHER_SKILL% %GLOBAL_FLAG% -y
    )
    exit /b 0
)

echo Installing %DISPATCHER_SKILL% dispatcher...

if exist "%LOCAL_DISPATCHER%" (
    call :RunSkillsAdd "%SCRIPT_DIR%" "%DISPATCHER_SKILL%" ""
    if not errorlevel 1 (
        echo [ok] %DISPATCHER_SKILL% installed via npx from local repo
        exit /b 0
    )

    echo [warn] npx local install failed; copying SKILL.md directly
    if not exist "%DISPATCHER_DIR%" mkdir "%DISPATCHER_DIR%" >nul 2>&1
    copy /Y "%LOCAL_DISPATCHER%" "%DISPATCHER_DIR%\SKILL.md" >nul
    if errorlevel 1 (
        echo [error] Failed to copy %LOCAL_DISPATCHER% to %DISPATCHER_DIR%
        exit /b 1
    )
    echo [ok] %DISPATCHER_SKILL% copied to %DISPATCHER_DIR%
    exit /b 0
)

call :RunSkillsAdd "%REMOTE_REPO%" "%DISPATCHER_SKILL%" ""
if not errorlevel 1 (
    echo [ok] %DISPATCHER_SKILL% installed from %REMOTE_REPO%
    exit /b 0
)

echo [warn] dispatcher install failed; retrying with --full-depth
call :RunSkillsAdd "%REMOTE_REPO%" "%DISPATCHER_SKILL%" "--full-depth"
if not errorlevel 1 (
    echo [ok] %DISPATCHER_SKILL% installed from %REMOTE_REPO%
    exit /b 0
)

echo [error] Failed to install %DISPATCHER_SKILL%
echo         Try: npx skills add %REMOTE_REPO% --skill %DISPATCHER_SKILL% %GLOBAL_FLAG% -y
exit /b 1

:InstallSubskill
set "ENTRY=%~1"
for /f "tokens=1,2 delims=:" %%A in ("!ENTRY!") do (
    set "REPO=%%A"
    set "SKILL=%%B"
)

set /a CURRENT+=1

if "%DRY_RUN%"=="1" (
    echo [dry-run] [!CURRENT!/%TOTAL%] npx skills add !REPO! --skill !SKILL! %GLOBAL_FLAG% -y
    set /a SUCCESS+=1
    exit /b 0
)

if exist "%SKILL_ROOT%\!SKILL!" if not "%FORCE%"=="1" (
    echo [skip] [!CURRENT!/%TOTAL%] !SKILL! already installed
    set /a SUCCESS+=1
    exit /b 0
)

<nul set /p=" [install] [!CURRENT!/%TOTAL%] !REPO! -^> !SKILL! "
call :RunSkillsAdd "!REPO!" "!SKILL!" ""
if not errorlevel 1 (
    echo ok
    set /a SUCCESS+=1
    exit /b 0
)

<nul set /p="retry... "
call :RunSkillsAdd "!REPO!" "!SKILL!" "--full-depth"
if not errorlevel 1 (
    echo ok
    set /a SUCCESS+=1
    exit /b 0
)

echo failed
echo          Try: npx skills add !REPO! --skill !SKILL! %GLOBAL_FLAG% -y
set /a FAILED+=1
exit /b 0
