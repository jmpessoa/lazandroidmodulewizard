set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_151
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\Temp\AppBrightness
keytool -genkey -v -keystore appbrightness-release.keystore -alias appbrightness.keyalias -keyalg RSA -keysize 2048 -validity 10000 < C:\Temp\AppBrightness\keytool_input.txt
