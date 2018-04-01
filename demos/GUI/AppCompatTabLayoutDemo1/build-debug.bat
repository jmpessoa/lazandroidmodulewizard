set Path=%PATH%;C:\adt32\ant\bin
set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_101
cd C:\Users\jmpessoa\workspace\AppCompatTabLayoutDemo1
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
