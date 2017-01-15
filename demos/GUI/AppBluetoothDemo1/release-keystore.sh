export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppBluetoothDemo1
keytool -genkey -v -keystore AppBluetoothDemo1-release.keystore -alias appbluetoothdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppBluetoothDemo1/appbluetoothdemo1keytool_input.txt
