set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_101
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\android-neon\eclipse\workspace\AppDBGridViewDemo1
keytool -genkey -v -keystore AppDBGridViewDemo1-release.keystore -alias appdbgridviewdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\android-neon\eclipse\workspace\AppDBGridViewDemo1\keytool_input.txt
