@echo off

set START_TIME=%TIME%

title Setting up...
echo Setting up ...

IF "%MAXCPUCOUNT%"=="" set MAXCPUCOUNT=6
IF "%TARGET%"=="" set TARGET=bootcd
IF "%COMPILER%"=="" set COMPILER=gcc
IF "%VS_VERSION%"=="10" set VS_VERSION=14
IF "%PLATFORM%"=="" set PLATFORM=x86
IF "%BUILDER%"=="" set BUILDER=ninja
IF "%TASKS%"=="" set TASKS=build

set COMPILERID=mingw
IF "%COMPILER%"=="vs" set COMPILERID=%COMPILER%%VS_VERSION%

IF "%BUILDID%"=="" set BUILDID=%COMPILERID%-%PLATFORM%-%BUILDER%

set SRCPATH=%CD%
set BUILDPATH=%SRCPATH%\..\build\%BUILDID%
set BEPATH=%SRCPATH%\..\rosbe

set PF=%PROGRAMFILES(x86)%
IF "%PF%"=="" do set PF=%PROGRAMFILES%

IF "%COMPILER%"=="vs" (
  set "PATH=%PATH%;%BEPATH%\bin"

  if "%VCINSTALLDIR%"=="" call "%PF%\Microsoft Visual Studio %VS_VERSION%.0\vc\vcvarsall.bat" %PLATFORM%
) else (
  if "%_ROSBE_BASEDIR%"=="" call %BEPATH%\RosBE.cmd
)

IF NOT EXIST "%BUILDPATH%" (
  md %BUILDPATH%
)

IF NOT EXIST "%BUILDPATH%\reactos\CMakeCache.txt" (
  IF "%TASKS%"=="%TASKS:configure=%" (
    set TASKS=configure;%TASKS%
  )
)

cd /D %BUILDPATH%

echo Settings: %TARGET% / %COMPILERID%-%PLATFORM%-%BUILDER% / %TASKS%

IF "%TASKS%"=="%TASKS:configure=%" GOTO BeginBuild

title Configuring...
echo Configuring...
call %SRCPATH%\configure.cmd %BUILDER%

IF errorlevel 1 (
  title Error Configuring
  goto Cleanup
)

set BUILD_START_TIME=%TIME%

:BeginBuild
IF "%TASKS%"=="%TASKS:build=%" GOTO EndBuild

set ERROR_TITLE=Error building Host-Tools
title Building Host Tools (!TIME!)
echo Building Host Tools ...
cd host-tools

IF "%BUILDER%"=="VSSolution" GOTO HTVS

ninja
IF errorlevel 1 goto Cleanup
goto BeginRos

:HTVS
msbuild /v:q /maxcpucount:%MAXCPUCOUNT% ALL_BUILD.vcxproj
IF errorlevel 1 goto Cleanup

:BeginRos
IF "%TARGET%"=="bootcd" GOTO BootCD
IF "%TARGET%"=="livecd" GOTO BootCD

set ERROR_TITLE=Error building ReactOS
title Building Target %TARGET% (!TIME!)
echo Building ReactOS ...
cd ../reactos

IF "%BUILDER%"=="VSSolution" GOTO MainVS

ninja %TARGET%
IF errorlevel 1 goto Cleanup
goto BootCD

:MainVS
msbuild /v:q /maxcpucount:%MAXCPUCOUNT% %TARGET%
IF errorlevel 1 goto Cleanup

:BootCD
set ERROR_TITLE=Error building ReactOS
title Building ReactOS (!TIME!)
echo Building ReactOS ...
cd ../reactos

IF "%BUILDER%"=="VSSolution" goto RosVS

ninja
IF errorlevel 1 goto Cleanup
goto Iso

:RosVS
msbuild /v:q /maxcpucount:%MAXCPUCOUNT% ALL_BUILD.vcxproj
IF errorlevel 1 goto Cleanup

:Iso
title Creating ISO (!TIME!)
echo Creating ISO ...
cd ../reactos

IF "%BUILDER%"=="VSSolution" goto IsoVS
ninja %TARGET%
IF errorlevel 1 goto Cleanup
goto EndBuild

:IsoVS
msbuild /v:q /maxcpucount:%MAXCPUCOUNT% boot\%TARGET%.vcxproj
IF errorlevel 1 goto Cleanup

:EndBuild
title Success.
echo Success. 

:Cleanup
echo Returning to the source directory.
echo Output is in %BUILDPATH%
cd /D %SRCPATH%

set END_TIME=%TIME%

:: Change formatting for the start and end times
for /F "tokens=1-4 delims=:.," %%a in ("%START_TIME%") do (
   set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

for /F "tokens=1-4 delims=:.," %%a in ("%END_TIME%") do (
   set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

:: Calculate the elapsed time by subtracting values
set /A elapsed=end-start

:: Format the results for output
set /A hh=elapsed/(60*60*100), rest=elapsed%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100
IF %hh% lss 10 set hh=0%hh%
IF %mm% lss 10 set mm=0%mm%
IF %ss% lss 10 set ss=0%ss%
IF %cc% lss 10 set cc=0%cc%

set DURATION=%hh%:%mm%:%ss%,%cc%

echo Start Time:       %START_TIME%
IF NOT "%TASKS%"=="%TASKS:build=%" echo Build Start Time: %BUILD_START_TIME%
echo End Time:         %TIME%
echo Total Elapsed:    %DURATION%

pause