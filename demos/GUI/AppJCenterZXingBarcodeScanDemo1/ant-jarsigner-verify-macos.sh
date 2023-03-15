export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterZXingBarcodeScanDemo1
jarsigner -verify -verbose -certs /android/workspace/AppJCenterZXingBarcodeScanDemo1/bin/AppJCenterZXingBarcodeScanDemo1-release.apk
