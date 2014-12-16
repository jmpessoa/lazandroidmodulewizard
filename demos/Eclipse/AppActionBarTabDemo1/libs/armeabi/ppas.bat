@echo off
SET THEFILE=unit1
echo Assembling %THEFILE%
C:\adt32\ndk10\toolchains\arm-linux-androideabi-4.6\prebuilt\windows\bin\arm-linux-androideabi-as.exe -march=armv6 -mfpu=softvfp -o C:\adt32\eclipse\workspace\AppActionBarTabDemo1\obj\controls\unit1.o  C:\adt32\eclipse\workspace\AppActionBarTabDemo1\obj\controls\unit1.s
if errorlevel 1 goto asmend
Del C:\adt32\eclipse\workspace\AppActionBarTabDemo1\obj\controls\unit1.s
SET THEFILE=controls
echo Assembling %THEFILE%
C:\adt32\ndk10\toolchains\arm-linux-androideabi-4.6\prebuilt\windows\bin\arm-linux-androideabi-as.exe -march=armv6 -mfpu=softvfp -o C:\adt32\eclipse\workspace\AppActionBarTabDemo1\obj\controls\controls.o  C:\adt32\eclipse\workspace\AppActionBarTabDemo1\obj\controls\controls.s
if errorlevel 1 goto asmend
Del C:\adt32\eclipse\workspace\AppActionBarTabDemo1\obj\controls\controls.s
SET THEFILE=..\libs\armeabi\libcontrols.so
echo Linking %THEFILE%
C:\adt32\ndk10\toolchains\arm-linux-androideabi-4.6\prebuilt\windows\bin\arm-linux-androideabi-ld.bfd.exe -z max-page-size=0x1000 -z common-page-size=0x1000 -z noexecstack -z now -s --gc-sections -L. -T ..\libs\armeabi\link.res -o ..\libs\armeabi\libcontrols.so -shared -soname libcontrols.so
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
