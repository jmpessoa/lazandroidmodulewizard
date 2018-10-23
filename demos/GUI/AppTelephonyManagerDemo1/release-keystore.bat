set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\lamw\workspace\AppTelephonyManagerDemo1
keytool -genkey -v -keystore AppTelephonyManagerDemo1-release.keystore -alias apptelephonymanagerdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\lamw\workspace\AppTelephonyManagerDemo1\keytool_input.txt
