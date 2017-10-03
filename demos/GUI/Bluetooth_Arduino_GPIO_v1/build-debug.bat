set Path=%PATH%;C:\lamw\apache-ant-1.9.6\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_91
cd C:\lamw\projects\\Bluetooth_Arduino_GPIO_v1
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
