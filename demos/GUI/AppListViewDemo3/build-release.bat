set Path=%PATH%;C:\adt32\ant\bin
set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
cd C:\android-neon\eclipse\workspace\AppListViewDemo3
call ant clean release
if errorlevel 1 pause
