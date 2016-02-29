@echo off

set SRCPATH=%CD%
set BEPATH=%SRCPATH%\..\rosbe

if "%_ROSBE_BASEDIR%"=="" (
 call %BEPATH%\RosBE.cmd
)

svn up

if exist modules\rosapps (
 cd modules\rosapps
 svn up
 cd ..\..
)

if exist modules\rostests (
 cd modules\rostests
 svn up
 cd ..\..
)

pause