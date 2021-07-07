set Path=%PATH%;C:\Users\artem.bogomolov.a\develop\instruments\ObjectPascal\fpcdeluxe\ccr\lamw-ant\apache-ant-1.10.9\bin
set JAVA_HOME=C:\Users\artem.bogomolov.a\.jdks\adopt-openj9-1.8.0_292
cd C:\Users\artem.bogomolov.a\develop\instruments\ObjectPascal\fpcdeluxe\ccr\lamw\demos\GUI\AppCompatNavigationDrawerDemo1\
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
