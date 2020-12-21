export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppBluetoothLowEnergyDemo1
keytool -genkey -v -keystore appbluetoothlowenergydemo1-release.keystore -alias appbluetoothlowenergydemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppBluetoothLowEnergyDemo1/keytool_input.txt
