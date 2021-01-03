set Path=%PATH%;C:\adt32\ant\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
cd C:\eclipse\demos\GUI\AppCustomShowMessageDemo1\
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
