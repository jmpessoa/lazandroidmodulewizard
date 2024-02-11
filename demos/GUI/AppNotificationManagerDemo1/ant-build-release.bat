set Path=%PATH%;C:\adt32\ant\bin
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.9.9
cd C:\android\workspace\AppNotificationManagerDemo1\
call ant clean release
if errorlevel 1 pause
