@echo off

set COMPILER=vs
set VS_VERSION=14
set PLATFORM=amd64_x86
set EXTRA=-newcc
set CMAKE_EXTRA_FLAGS=-DNEWCC:BOOL=TRUE

call __buildmaster.cmd
