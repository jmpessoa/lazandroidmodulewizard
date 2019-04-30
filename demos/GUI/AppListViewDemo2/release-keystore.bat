set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151\
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\laztoapk\projects\project1\AppListViewDemo2
keytool -genkey -v -keystore applistviewdemo2-release.keystore -alias applistviewdemo2.keyalias -keyalg RSA -keysize 2048 -validity 10000 < C:\laztoapk\projects\project1\AppListViewDemo2\keytool_input.txt
