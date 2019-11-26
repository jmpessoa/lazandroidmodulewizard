set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_221
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\Temp\AppChronometerDemo2
keytool -genkey -v -keystore appchronometerdemo2-release.keystore -alias appchronometerdemo2.keyalias -keyalg RSA -keysize 2048 -validity 10000 < C:\Temp\AppChronometerDemo2\keytool_input.txt
