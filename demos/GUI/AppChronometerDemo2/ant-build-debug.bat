set Path=%PATH%;C:\laztoapk\downloads\apache-ant-1.10.3\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_221
cd C:\Temp\AppChronometerDemo2
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
