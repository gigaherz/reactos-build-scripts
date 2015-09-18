@echo off

title Setting up...
echo Setting up ...

set SRCPATH=%CD%
set BUILDPATH=%SRCPATH%\..\build\gcc-ninja
set BEPATH=%SRCPATH%\..\rosbe

if "%_ROSBE_BASEDIR%"=="" (
 cmd /k %BEPATH%\RosBE.cmd
)

pause