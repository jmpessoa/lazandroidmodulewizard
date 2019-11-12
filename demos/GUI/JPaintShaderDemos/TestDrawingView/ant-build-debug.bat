set Path=%PATH%;K:\FPC_Luxe\apache-ant-1.10.6\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_221
cd J:\!work\FPC\TestDrawingView\
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
