set Path=%PATH%;C:\fpcupdeluxe\ccr\lamw-ant\apache-ant-1.10.12\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_301
cd C:\fpcupdeluxe\ccr\lamw\demos\GUI\AppBGRABitmapDemo1
call ant clean release
if errorlevel 1 pause
