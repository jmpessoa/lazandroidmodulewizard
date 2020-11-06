set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_151
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\Temp\AppCompactFileprovider
keytool -genkey -v -keystore appcompactfileprovider-release.keystore -alias appcompactfileprovider.keyalias -keyalg RSA -keysize 2048 -validity 10000 < C:\Temp\AppCompactFileprovider\keytool_input.txt
