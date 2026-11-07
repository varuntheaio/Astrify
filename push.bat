@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo               Astrify - GitHub Push Script
echo           Developed by Varq ^| discord.gg/astria
echo ========================================================
echo.

cd /d "%~dp0"

echo [1/5] Configuring Git Remote...
git remote set-url origin https://github.com/varuntheaio/Astrify.git 2>nul || git remote add origin https://github.com/varuntheaio/Astrify.git

echo [2/5] Setting main branch...
git branch -M main

echo [3/5] Staging all files...
git add -A

echo [4/5] Committing changes...
git commit -m "Astrify release v3.1.0 - Dev by Varq (credits: discord.gg/astria)" 2>nul

echo [5/5] Creating release tag v3.1.0...
git tag v3.1.0 2>nul

echo.
echo Pushing commits and tags to GitHub (https://github.com/varuntheaio/Astrify.git)...
git push -u origin main
git push origin --tags

echo.
if %ERRORLEVEL% equ 0 (
    echo ========================================================
    echo   SUCCESS: Pushed to https://github.com/varuntheaio/Astrify
    echo ========================================================
) else (
    echo ========================================================
    echo   Push failed or rejected. Attempting push with --force...
    git push -u origin main --force
    git push origin --tags --force
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
