export JAVA_HOME=/Program Files/Java/jdk1.8.0_221
cd /Temp/AppSoundPoolDemo
keytool -genkey -v -keystore appsoundpooldemo-release.keystore -alias appsoundpooldemo.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Temp/AppSoundPoolDemo/keytool_input.txt
