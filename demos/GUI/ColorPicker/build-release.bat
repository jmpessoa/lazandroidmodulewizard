set Path=%PATH%;C:\lamw\apache-ant-1.9.6\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_91
cd C:\lamw\projects\\ColorPicker
call ant clean release
if errorlevel 1 pause
