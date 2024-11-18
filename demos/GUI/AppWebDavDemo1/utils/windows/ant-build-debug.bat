set Path=%PATH%;C:\Android\apache-ant-1.9.7\bin
set JAVA_HOME=C:\Program Files\Java\jdk-21.0.4+7
cd C:\Projects\Karat\Xnix\AppWebDAVDemo1\utils\windows\
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
