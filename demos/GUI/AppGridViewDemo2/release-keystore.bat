set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_65
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\Documents\lazarus\Essais\AppGridViewDemo2
keytool -genkey -v -keystore AppGridViewDemo2-release.keystore -alias appgridviewdemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\Documents\lazarus\Essais\AppGridViewDemo2\keytool_input.txt
