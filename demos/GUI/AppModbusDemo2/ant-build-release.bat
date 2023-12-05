set Path=%PATH%;E:\fpcupdeluxe\ccr\lamw-ant\apache-ant-1.10.9\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_251
cd E:\lamw\latihan\modbus
call ant clean release
if errorlevel 1 pause
