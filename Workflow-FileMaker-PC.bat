@echo off
setlocal ENABLEEXTENSIONS

title Workflow Folder Builder
echo ============================================
echo          Workflow Folder Builder
echo ============================================
echo.
CHOICE /C RT /M "Select folder type: (R)esearch or (T)eaching"

:: Order Choice)
IF ERRORLEVEL 2 (
    set "BASE=Teaching"
) ELSE IF ERRORLEVEL 1 (
    set "BASE=Research"
)

echo.
echo Opening a folder picker... select where to create your %BASE% project.
echo.

:: PowerShell GUI folder picker
for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command ^
  "Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; $f.Description = 'Select destination for your %BASE% project'; $f.ShowNewFolderButton = $true; if ($f.ShowDialog() -eq 'OK') { [Console]::WriteLine($f.SelectedPath) }"`) do set "LOC=%%I"

IF "%LOC%"=="" (
  echo No location selected. Exiting.
  pause
  exit /b 1
)

echo.
set /p PROJ="Enter your project name (no slashes): "
if "%PROJ%"=="" (
  echo Project name is required. Exiting.
  pause
  exit /b
)

set "TARGET=%LOC%\%PROJ%"
echo.
echo Creating %BASE% project "%PROJ%" at:
echo   %TARGET%
echo.

:: Create target root
mkdir "%TARGET%" 2>nul

:: RESEARCH STRUCTURE
::  NOTE: By changing the 00-..."  you can change the name of the folders 
::  By changing the 03-Text\00-..." you can change sub folders 
::  Just make sure you link to the proper main folder (03-Text or one of the others)
IF /I "%BASE%"=="Research" (
  mkdir "%TARGET%\00-Hold to Delete" 2>nul
  mkdir "%TARGET%\01-Posted Raw Data" 2>nul
  mkdir "%TARGET%\03-Text" 2>nul
  mkdir "%TARGET%\04-Work" 2>nul
  mkdir "%TARGET%\05-WTF" 2>nul

  mkdir "%TARGET%\03-Text\00-Outlines" 2>nul
  mkdir "%TARGET%\03-Text\01-Draft" 2>nul
  mkdir "%TARGET%\03-Text\02-Submission" 2>nul
)

:: TEACHING STRUCTURE
::  NOTE: By changing the 00-..."  you can change the name of the folders 
::  NOTE:  By making a 06-WTF\01-ReallyWTF you can create sub folders 
::  Just make sure you link to the proper main folder (03-Text or one of the others)
IF /I "%BASE%"=="Teaching" (
  mkdir "%TARGET%\00-To Do" 2>nul
  mkdir "%TARGET%\01-Lectures" 2>nul
  mkdir "%TARGET%\02-Assignments" 2>nul
  mkdir "%TARGET%\03-Readings" 2>nul
  mkdir "%TARGET%\04-Work" 2>nul
  mkdir "%TARGET%\05-Grade Backup" 2>nul
  mkdir "%TARGET%\06-WTF" 2>nul
)

echo.
echo ✅ %BASE% project "%PROJ%" created successfully!
echo Location: %TARGET%
echo.
pause
