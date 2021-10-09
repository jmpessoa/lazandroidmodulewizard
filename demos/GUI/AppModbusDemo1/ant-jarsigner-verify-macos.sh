export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppModbusDemo1
jarsigner -verify -verbose -certs /android/workspace/AppModbusDemo1/bin/AppModbusDemo1-release.apk
