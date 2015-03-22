@echo off
setlocal enabledelayedexpansion
title CAN-OPENER


echo Skills in different folders must have different names.
echo After performing, update Explorer.
echo.
echo Start extraction....
echo.

for /f "delims=" %%a in ('dir /b /ad *') do (
echo ----Open %%a
    
    for /f "delims=" %%b in ('dir /b /s /a-d "%%a\*"') do (
    move "%%b" "%~dp0" >nul
    echo Moved %%~nb%%~xb
)
    
    rd /s /q "%%a"
    
    echo ----Folder is deleted
    echo.
)
 
echo ----Finished

pause


