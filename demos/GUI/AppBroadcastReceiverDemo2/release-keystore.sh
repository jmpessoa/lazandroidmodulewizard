export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppBroadcastReceiverDemo2
keytool -genkey -v -keystore AppBroadcastReceiverDemo2-release.keystore -alias appbroadcastreceiverdemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppBroadcastReceiverDemo2/appbroadcastreceiverdemo2keytool_input.txt
