set Path=%PATH%;C:\adt32\ant\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
cd C:\lamw\workspace\AppCompatRecyclerViewDemo1
call ant clean release
if errorlevel 1 pause
