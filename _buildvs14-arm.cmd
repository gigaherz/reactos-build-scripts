@echo off

set CMAKE_SYSTEM_NAME=Windows
set CMAKE_SYSTEM_PROCESSOR=ARM

set COMPILER=vs
set VS_VERSION=14
set PLATFORM=x86_arm

call __buildmaster.cmd
