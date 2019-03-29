export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppZBarcodeScannerViewDemo1
jarsigner -verify -verbose -certs /android/workspace/AppZBarcodeScannerViewDemo1/bin/AppZBarcodeScannerViewDemo1-release.apk
