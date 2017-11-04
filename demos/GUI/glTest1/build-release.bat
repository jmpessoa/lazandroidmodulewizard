set Path=%PATH%;/usr/bin
set JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
cd /home/handoko/Projects/Project Software/Android Test/glTest1
call ant clean release
if errorlevel 1 pause
