export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppBluetoothLowEnergyDemo1
jarsigner -verify -verbose -certs /android/workspace/AppBluetoothLowEnergyDemo1/bin/AppBluetoothLowEnergyDemo1-release.apk
