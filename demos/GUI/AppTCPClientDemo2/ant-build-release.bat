set Path=%PATH%;D:\Install\apache-ant-1.9.6\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_251
cd E:\AppTCPClientDemo1\
call ant clean release
if errorlevel 1 pause
