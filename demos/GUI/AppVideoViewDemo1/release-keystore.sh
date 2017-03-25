export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppVideoViewDemo1
keytool -genkey -v -keystore AppVideoViewDemo1-release.keystore -alias appvideoviewdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppVideoViewDemo1/appvideoviewdemo1keytool_input.txt
