set Path=%PATH%;C:\adt32\ant\bin
set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_101
cd C:\Users\jmpessoa\workspace\AppCompatCollapsingToolbarDemo1
call ant clean release
if errorlevel 1 pause
