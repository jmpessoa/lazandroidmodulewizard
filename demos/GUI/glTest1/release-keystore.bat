set JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
set PATH=%JAVA_HOME%/bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd /home/handoko/Projects/Project Software/Android Test/glTest1
keytool -genkey -v -keystore glTest1-release.keystore -alias gltest1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /home/handoko/Projects/Project Software/Android Test/glTest1/keytool_input.txt
