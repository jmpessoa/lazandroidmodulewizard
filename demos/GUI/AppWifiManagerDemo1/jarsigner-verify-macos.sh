export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppWifiManagerDemo1
jarsigner -verify -verbose -certs /android/workspace/AppWifiManagerDemo1/bin/AppWifiManagerDemo1-release.apk
