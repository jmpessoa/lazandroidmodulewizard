export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppBatteryManagerDemo1
jarsigner -verify -verbose -certs /android/workspace/AppBatteryManagerDemo1/build/outputs/apk/release/AppBatteryManagerDemo1-release.apk
