@echo off
:: CV As Code – Windows Launcher
:: Double-click to start. Close browser tab or press Ctrl+C to stop.

setlocal EnableExtensions EnableDelayedExpansion
title CV As Code

:: -------------------------
:: Helpers
:: -------------------------

:print_error
echo.
echo [ERROR] %*
echo.
exit /b 1

:print_info
echo [INFO] %*
exit /b 0

:print_success
echo [SUCCESS] %*
exit /b 0

:: -------------------------
:: Check Node.js
:: -------------------------

where node >nul 2>nul
if not "%ERRORLEVEL%"=="0" (
    echo.
    echo [ERROR] Node.js is not installed.
    echo.
    echo Would you like to install Node.js automatically using winget?
    echo.

    set /p INSTALL_NODE=Press Y to install automatically, or any other key to exit: 
    if /I "!INSTALL_NODE!"=="Y" (
        call :install_node
        echo.
        echo [SUCCESS] Node.js installed successfully!
        echo [INFO] Please close this window and run RunWindows.bat again.
        echo.
        pause
        exit /b 0
    ) else (
        echo.
        echo [INFO] Installation cancelled.
        echo [INFO] Please install Node.js manually from https://nodejs.org
        echo.
        pause
        exit /b 1
    )
)

:: -------------------------
:: Run app
:: -------------------------

echo.
echo [INFO] Starting CV As Code...
cd /d "%~dp0"
node src\launcher\index.js

:: Auto-close after exit
timeout /t 2 /nobreak >nul
exit /b 0

:: -------------------------
:: Install Node.js
:: -------------------------

:install_node
where winget >nul 2>nul
if not "%ERRORLEVEL%"=="0" (
    echo.
    echo [ERROR] winget is not available on this system.
    echo [INFO] Please install Node.js manually from https://nodejs.org
    echo.
    pause
    exit /b 1
)

echo.
echo [INFO] Installing Node.js via winget...
echo.

winget install OpenJS.NodeJS.LTS ^
    --accept-source-agreements ^
    --accept-package-agreements

if not "%ERRORLEVEL%"=="0" (
    echo.
    echo [ERROR] Failed to install Node.js via winget.
    echo [INFO] Please install manually from https://nodejs.org
    echo.
    pause
    exit /b 1
)

exit /b 0
