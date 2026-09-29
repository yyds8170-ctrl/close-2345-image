@echo off

:: ===== Admin elevation =====
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin_2345.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin_2345.vbs"
    cscript //nologo "%temp%\getadmin_2345.vbs"
    exit /b
)
if exist "%temp%\getadmin_2345.vbs" del "%temp%\getadmin_2345.vbs" >nul 2>&1

setlocal EnableDelayedExpansion
set TARGETS=2345PicViewer.exe 2345PicWorker.exe PicService.exe 2345PicHelper.exe 2345PicUpdater.exe

:: ===== Stop the 2345Pic guardian service FIRST =====
net stop 2345Pic /y >nul 2>&1
sc config 2345Pic start= demand >nul 2>&1

:: ===== 5 rounds of taskkill =====
for /l %%i in (1,1,5) do (
    for %%p in (%TARGETS%) do (
        taskkill /F /IM %%p /T >nul 2>&1
    )
    timeout /t 1 /nobreak >nul
)

:: ===== PowerShell fallback =====
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match '2345Pic|PicService|2345PicUpdater' } | Stop-Process -Force -ErrorAction SilentlyContinue" 2>nul