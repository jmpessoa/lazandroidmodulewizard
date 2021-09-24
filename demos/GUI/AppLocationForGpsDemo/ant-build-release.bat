set Path=%PATH%;D:\lamw_manager\LAMW\apache-ant-1.10.5\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_65
cd C:\Users\mali.aydin\Desktop\Lazarus_Jni\AppLocationForGpsDemo
call ant clean release
if errorlevel 1 pause
