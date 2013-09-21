@echo off

set PATH=%PATH%;G:\rosbe\bin

echo Setting up ...

set SRCPATH=%CD%
set BUILDPATH=%SRCPATH%\..\vs12
set BEPATH=%SRCPATH%\..\rosbe\bin

set PATH=%PATH%;%BEPATH%

set PF=%PROGRAMFILES(x86)%
if "%PF%"=="" do set PF=%PROGRAMFILES%

call "%PF%\Microsoft Visual Studio 12.0\vc\bin\vcvars32.bat"

IF NOT EXIST "%BUILDPATH%" (
  md %BUILDPATH%
)

cd /D %BUILDPATH%

echo Generating Visual Studio project files...
call %SRCPATH%\configure VSSolution
