@echo off

set START_TIME=%time%

echo Setting up ...

set SRCPATH=%CD%
set BUILDPATH=%SRCPATH%\..\build-vs10
set BEPATH=%SRCPATH%\..\rosbe\bin

set PATH=c:\windows\system32\wbem;%PATH%;%BEPATH%

set PF=%PROGRAMFILES(x86)%
if "%PF%"=="" do set PF=%PROGRAMFILES%

call "%PF%\Microsoft Visual Studio 10.0\vc\bin\vcvars32.bat"

IF NOT EXIST "%BUILDPATH%" (
  md %BUILDPATH%
)

cd /D %BUILDPATH%

IF NOT EXIST "%BUILDPATH%\reactos\CMakeCache.txt" (
  set MODE=configure
)

IF "%MODE%"=="configure" (
  echo Configuring...
  call %SRCPATH%\configure VSSolution
)

echo Building Host Tools ...
cd host-tools

msbuild ALL_BUILD.vcxproj

echo Building ReactOS ...
cd ../reactos

msbuild ALL_BUILD.vcxproj

echo Creating the BootCD ...
cd boot

msbuild bootcd.vcxproj

echo Finished. Returning to the source directory.
echo Output is in %BUILDPATH%
cd /D %SRCPATH%

echo Start Time: %START_TIME%
echo End Time: %TIME%

pause