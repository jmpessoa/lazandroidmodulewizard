set Path=%PATH%;C:\android\ant\bin
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.9.9
cd C:\android\workspace\AppFCLMySQL57ConnectionBridgeDemo1\utils\windows\
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
