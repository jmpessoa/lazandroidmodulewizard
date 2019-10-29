export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppAjustScreen
jarsigner -verify -verbose -certs /Temp/AppAjustScreen/bin/AppAjustScreen-release.apk
