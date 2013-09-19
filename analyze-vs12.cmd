rem @echo off

set START_TIME=%time%

echo Setting up ...

set MODE=%1

set SRCPATH=%CD%
set BUILDPATH=%SRCPATH%\..\analyze-vs12-ninja

set PATH=c:\windows\system32\wbem;%PATH%;G:\rosbe\bin

call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\vc\bin\vcvars32.bat"

md %BUILDPATH%
cd /D %BUILDPATH%

IF NOT EXIST "%BUILDPATH%\reactos\CMakeCache.txt" (
  set MODE=configure
)

IF "%MODE%"=="configure" (
  echo Configuring...
  call %SRCPATH%\configure ninja
)

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
