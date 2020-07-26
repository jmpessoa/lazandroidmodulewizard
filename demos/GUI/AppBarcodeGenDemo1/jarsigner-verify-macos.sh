export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppBarcodeGenDemo1
jarsigner -verify -verbose -certs /android/workspace/AppBarcodeGenDemo1/bin/AppBarcodeGenDemo1-release.apk
