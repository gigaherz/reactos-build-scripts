@echo off

set SRCPATH=%CD%
set BEPATH=%SRCPATH%\..\rosbe

if "%_ROSBE_BASEDIR%"=="" (
 call %BEPATH%\RosBE.cmd
)

echo no | ssvn update