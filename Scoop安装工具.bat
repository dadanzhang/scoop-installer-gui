@echo off
chcp 65001 >nul
echo ========================================
echo    Scoop 开发工具一键安装工具
echo ========================================
echo.
echo 正在启动...
powershell -ExecutionPolicy Bypass -File "%~dp0ScoopInstaller.ps1"
pause