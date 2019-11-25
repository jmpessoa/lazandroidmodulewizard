export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterBluetoothSPPDemo1
keytool -genkey -v -keystore appjcenterbluetoothsppdemo1-release.keystore -alias appjcenterbluetoothsppdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppJCenterBluetoothSPPDemo1/keytool_input.txt
