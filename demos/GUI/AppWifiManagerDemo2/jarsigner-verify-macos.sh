export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppWifiManagerDemo2
jarsigner -verify -verbose -certs /android/workspace/AppWifiManagerDemo2/bin/AppWifiManagerDemo2-release.apk
