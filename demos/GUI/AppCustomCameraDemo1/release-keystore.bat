set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_101
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\android-neon\eclipse\workspace\AppCustomCameraDemo1
keytool -genkey -v -keystore AppCustomCameraDemo1-release.keystore -alias appcustomcamerademo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\android-neon\eclipse\workspace\AppCustomCameraDemo1\keytool_input.txt
