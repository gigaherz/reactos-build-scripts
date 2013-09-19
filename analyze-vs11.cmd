rem @echo off

set START_TIME=%time%

echo Setting up ...

set MODE=%1

set SRCPATH=%CD%
set BUILDPATH=%SRCPATH%\..\analyze-vs11-ninja
set BEPATH=%SRCPATH%\..\rosbe\bin

set PATH=%PATH%;%BEPATH%

set PF=%PROGRAMFILES(x86)%
if "%PF%"=="" do set PF=%PROGRAMFILES%

call "%PF%\Microsoft Visual Studio 11.0\vc\bin\vcvars32.bat"

IF NOT EXIST "%BUILDPATH%" (
  md %BUILDPATH%
)

cd /D %BUILDPATH%

IF NOT EXIST "%BUILDPATH%\reactos\CMakeCache.txt" (
  set MODE=configure
)

IF "%MODE%"=="configure" (
  echo Configuring...
  call %SRCPATH%\configure ninja
)

echo Take this chance to edit the CMakeCache.exe file...
pause

echo Building Host Tools ...
cd host-tools

ninja

echo Building ReactOS ...
cd ../reactos

ninja clean
ninja -k 0 -j 1 | tee %BUILDPATH%\build.log

echo Finished. Returning to the source directory.
echo Output is in %BUILDPATH%
cd /D %SRCPATH%

echo Start Time: %START_TIME%
echo End Time: %TIME%

pause
