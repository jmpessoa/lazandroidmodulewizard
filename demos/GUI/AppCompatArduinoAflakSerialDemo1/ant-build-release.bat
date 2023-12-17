set Path=%PATH%;C:\adt32\ant\bin
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.21.9
cd C:\android\workspace\AppCompatArduinoAflakSerialDemo1
call ant clean release
if errorlevel 1 pause
