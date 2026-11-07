@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo               Astrify - GitHub Push Script
echo           Developed by Varq ^| discord.gg/astria
echo ========================================================
echo.

cd /d "%~dp0"

echo [1/4] Configuring Git Remote...
git remote set-url origin https://github.com/varuntheaio/Astrify.git 2>nul || git remote add origin https://github.com/varuntheaio/Astrify.git

echo [2/4] Setting main branch...
git branch -M main

echo [3/4] Staging all files...
git add -A

echo [4/4] Committing changes...
git commit -m "Astrify release - Dev by Varq (credits: discord.gg/astria)" 2>nul

echo.
echo Pushing to GitHub (https://github.com/varuntheaio/Astrify.git)...
git push -u origin main

echo.
if %ERRORLEVEL% equ 0 (
    echo ========================================================
    echo   SUCCESS: Pushed to https://github.com/varuntheaio/Astrify
    echo ========================================================
) else (
    echo ========================================================
    echo   Push failed or rejected. Attempting push with --force...
    git push -u origin main --force
    if !ERRORLEVEL! equ 0 (
        echo ========================================================
        echo   SUCCESS: Force-pushed to https://github.com/varuntheaio/Astrify
        echo ========================================================
    ) else (
        echo ========================================================
        echo   ERROR: Could not push. Please check your GitHub login.
        echo ========================================================
    )
)

echo.
pause
