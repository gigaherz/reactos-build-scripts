@echo off

set COMPILER=vs
set VS_VERSION=14
set BUILDER=VSSolution
set TASKS=configure

call __buildmaster.cmd
