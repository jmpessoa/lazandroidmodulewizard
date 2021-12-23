export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterWebSocketClientDemo1
keytool -genkey -v -keystore appjcenterwebsocketclientdemo1-release.keystore -alias appjcenterwebsocketclientdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppJCenterWebSocketClientDemo1/keytool_input.txt
