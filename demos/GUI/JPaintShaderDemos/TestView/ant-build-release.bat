set Path=%PATH%;K:\FPC_Luxe\apache-ant-1.10.6\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_221
cd J:\!work\FPC\TestView
call ant clean release
if errorlevel 1 pause
