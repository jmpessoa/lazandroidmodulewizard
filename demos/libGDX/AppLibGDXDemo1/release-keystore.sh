export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppLibGDXDemo1
keytool -genkey -v -keystore applibgdxdemo1-release.keystore -alias applibgdxdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppLibGDXDemo1/keytool_input.txt
