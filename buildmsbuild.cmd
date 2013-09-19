@echo off

set START_TIME=%time%

echo Setting up ...

set SRCPATH=%CD%
set BUILDPATH=%SRCPATH%\..\build-vs10

set PATH=c:\windows\system32\wbem;%PATH%;C:\Program Files (x86)\CMake 2.8\bin

call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\vcvars32.bat"

md %BUILDPATH%
cd /D %BUILDPATH%

IF "%1"=="configure" (
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
