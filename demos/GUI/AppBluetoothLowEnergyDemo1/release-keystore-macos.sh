export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppBluetoothLowEnergyDemo1
keytool -genkey -v -keystore appbluetoothlowenergydemo1-release.keystore -alias appbluetoothlowenergydemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppBluetoothLowEnergyDemo1/keytool_input.txt
