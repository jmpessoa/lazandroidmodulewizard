export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppModbusDemo1
keytool -genkey -v -keystore appmodbusdemo1-release.keystore -alias appmodbusdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppModbusDemo1/keytool_input.txt
