export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppLibGDXDemo2
keytool -genkey -v -keystore applibgdxdemo2-release.keystore -alias applibgdxdemo2.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppLibGDXDemo2/keytool_input.txt
