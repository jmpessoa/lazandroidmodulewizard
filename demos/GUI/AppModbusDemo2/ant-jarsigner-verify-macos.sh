export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/latihan/modbus
jarsigner -verify -verbose -certs /lamw/latihan/modbus/bin/modbus-release.apk
