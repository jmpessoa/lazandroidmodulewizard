set Path=%PATH%;C:\adt32\ant\bin
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.21.9
cd C:\android\workspace\AppTextViewVerticalScrolling
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
