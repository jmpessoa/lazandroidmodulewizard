@echo off
SET THEFILE=unit1
echo Assembling %THEFILE%
C:\LiteZarus4Android\fpc\2.7.1\bin\i386-win32\arm-linux-androideabi-as.exe -march=armv6 -mfpu=softvfp -o C:\adt32\eclipse\workspace\AppTest2\obj\Controls\unit1.o C:\adt32\eclipse\workspace\AppTest2\obj\Controls\unit1.s
if errorlevel 1 goto asmend
Del C:\adt32\eclipse\workspace\AppTest2\obj\Controls\unit1.s
SET THEFILE=controls
echo Assembling %THEFILE%
C:\LiteZarus4Android\fpc\2.7.1\bin\i386-win32\arm-linux-androideabi-as.exe -march=armv6 -mfpu=softvfp -o C:\adt32\eclipse\workspace\AppTest2\obj\Controls\controls.o C:\adt32\eclipse\workspace\AppTest2\obj\Controls\controls.s
if errorlevel 1 goto asmend
Del C:\adt32\eclipse\workspace\AppTest2\obj\Controls\controls.s
SET THEFILE=C:\adt32\eclipse\workspace\AppTest2\libs\armeabi\libcontrols.so
echo Linking %THEFILE%
C:\LiteZarus4Android\fpc\2.7.1\bin\i386-win32\arm-linux-androideabi-ld.bfd.exe -z max-page-size=0x1000 -z common-page-size=0x1000 -z noexecstack -z now -s --gc-sections -L. -T C:\adt32\eclipse\workspace\AppTest2\libs\armeabi\link.res -o C:\adt32\eclipse\workspace\AppTest2\libs\armeabi\libcontrols.so -shared -soname libcontrols.so
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
