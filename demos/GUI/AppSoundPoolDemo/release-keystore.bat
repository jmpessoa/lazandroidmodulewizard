set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_221
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\Temp\AppSoundPoolDemo
keytool -genkey -v -keystore appsoundpooldemo-release.keystore -alias appsoundpooldemo.keyalias -keyalg RSA -keysize 2048 -validity 10000 < C:\Temp\AppSoundPoolDemo\keytool_input.txt
