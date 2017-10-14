set Path=%PATH%;C:\adt32\ant\bin
set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
cd C:\android-neon\eclipse\workspace\AppToolbarDemo2
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
