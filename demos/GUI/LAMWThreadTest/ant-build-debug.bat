set Path=%PATH%;C:\apache-ant-1.9.9\bin
set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_25
cd C:\Core\Projs\Android\LAMW\LAMWThreadTest
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
