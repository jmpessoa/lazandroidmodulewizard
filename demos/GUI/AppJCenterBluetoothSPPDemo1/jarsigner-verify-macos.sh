export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterBluetoothSPPDemo1
jarsigner -verify -verbose -certs /android/workspace/AppJCenterBluetoothSPPDemo1/bin/AppJCenterBluetoothSPPDemo1-release.apk
