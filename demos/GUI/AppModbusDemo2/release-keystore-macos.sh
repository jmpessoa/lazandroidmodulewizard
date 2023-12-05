export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/latihan/modbus
keytool -genkey -v -keystore modbus-release.keystore -alias modbus.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /lamw/latihan/modbus/keytool_input.txt
