export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppFCLMySQL57ConnectionBridgeDemo1
keytool -genkey -v -keystore appfclmysql57connectionbridgedemo1-release.keystore -alias appfclmysql57connectionbridgedemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppFCLMySQL57ConnectionBridgeDemo1/keytool_input.txt
