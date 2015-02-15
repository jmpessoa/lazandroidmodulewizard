export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppBroadcastReceiverDemo1
keytool -genkey -v -keystore AppBroadcastReceiverDemo1-release.keystore -alias appbroadcastreceiverdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppBroadcastReceiverDemo1/appbroadcastreceiverdemo1keytool_input.txt
