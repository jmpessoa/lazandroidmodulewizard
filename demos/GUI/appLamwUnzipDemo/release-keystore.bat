set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_201\
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd D:\dev\dev\lazarus\Unzipper\AppLAMWUnzipDemo
keytool -genkey -v -keystore applamwunzipdemo-release.keystore -alias applamwunzipdemo.keyalias -keyalg RSA -keysize 2048 -validity 10000 < D:\dev\dev\lazarus\Unzipper\AppLAMWUnzipDemo\keytool_input.txt
