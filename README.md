Reactos Build Scripts
=====================

A collection of small scripts I use for compiling and testing ReactOS.

LIMITATIONS
-----------

These scripts assume a certain layout of the environment, and may not be fit for everyone.

My environment follows this pattern:
* <reactos folder>
* * /rosbe
* * /<source folder>
* * * (build scripts go here)
* * /build

The rules for this layout as as follows:
* The location of the parent folder does not matter, as long as it doesn't contain spaces in it.
* The name of the source folder does not matter.
* The build scripts are located inside the source folder.
* The build folder is created automatically based on the settings in the build script.

Known limitations that I may fix someday:
* At the moment, it's not possible to configure a different output folder (such as for separating different branches or build settings beyond the compiler and build manager).
* At the moment, it's not possible to share the same set of build scripts across different source folders.
