@echo off
REM Run heightmap_demo.exe and log a simple timestamp + exit code.
set APP1=heightmap_demo.exe
set APP2=Volstrax1.2.exe
set LOG=%~dp0\volstrax_run_log.txt
echo ------------------------------- >> "%LOG%"
echo Start: %DATE% %TIME% >> "%LOG%"
cd /d "%~dp0"
if exist "%~dp0\%APP1%" (
  echo Running %APP1% >> "%LOG%"
  start "Volstrax" /wait "%~dp0\%APP1%"
  echo Exit code: %ERRORLEVEL% >> "%LOG%"
) else if exist "%~dp0\%APP2%" (
  echo Running %APP2% >> "%LOG%"
  start "Volstrax" /wait "%~dp0\%APP2%"
  echo Exit code: %ERRORLEVEL% >> "%LOG%"
) else (
  echo No executable found (tried %APP1% and %APP2%) >> "%LOG%"
  echo Files in folder: >> "%LOG%"
  dir /b >> "%LOG%"
)
echo End: %DATE% %TIME% >> "%LOG%"
echo ------------------------------- >> "%LOG%"
echo Log written to %LOG%
pause
