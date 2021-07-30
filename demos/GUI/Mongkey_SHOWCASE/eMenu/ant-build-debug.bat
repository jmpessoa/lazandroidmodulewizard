set Path=%PATH%;F:\fpcupdeluxe\ccr\lamw-ant\apache-ant-1.10.9\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_251
cd F:\lamw\latihan\eMenu
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
