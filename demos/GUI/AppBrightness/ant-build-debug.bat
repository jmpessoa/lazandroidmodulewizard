set Path=%PATH%;c:\laztoapk\downloads\apache-ant-1.10.3\bin
set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_151
cd C:\Temp\AppBrightness
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
