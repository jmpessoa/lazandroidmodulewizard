export JAVA_HOME=/Program Files (x86)/Java/jdk1.8.0_101
cd /lamw/workspace/AppCompatAdMobDemo1
keytool -genkey -v -keystore AppCompatAdMobDemo1-release.keystore -alias appcompatadmobdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppCompatAdMobDemo1/appcompatadmobdemo1keytool_input.txt
