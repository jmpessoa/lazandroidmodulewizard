set Path=%PATH%;C:\adt32\ant\bin
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.9.9
cd C:\android\workspace\AppNotificationManagerDemo2\
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
