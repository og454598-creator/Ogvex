@echo off
setlocal
cd /d "%~dp0"

where node >nul 2>nul
if errorlevel 1 goto missing_node

node -e "if (Number(process.versions.node.split('.')[0]) < 20) process.exit(1)"
if errorlevel 1 goto old_node

if not exist "node_modules\wrangler\bin\wrangler.js" (
  echo Installing project dependencies...
  call npm.cmd ci
  if errorlevel 1 goto install_failed
)

echo Starting Vexora at http://127.0.0.1:8788
echo Press Ctrl+C in this window to stop it.
call npm.cmd run dev
if errorlevel 1 goto start_failed
exit /b 0

:missing_node
echo Node.js 20 or newer is required. Install it from https://nodejs.org/ and try again.
pause
exit /b 1

:old_node
echo Node.js 20 or newer is required. Update Node.js and try again.
pause
exit /b 1

:install_failed
echo Dependency installation failed. Check your internet connection and try again.
pause
exit /b 1

:start_failed
echo Vexora did not start. Read the error above, then try again.
pause
exit /b 1
