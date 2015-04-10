set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
cd C:\adt32\eclipse\workspace\AppBluetoothDemo1
keytool -genkey -v -keystore AppBluetoothDemo1-release.keystore -alias appbluetoothdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\adt32\eclipse\workspace\AppBluetoothDemo1\keytool_input.txt
