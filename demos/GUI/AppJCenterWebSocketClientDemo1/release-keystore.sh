export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppJCenterWebSocketClientDemo1
LC_ALL=C keytool -genkey -v -keystore appjcenterwebsocketclientdemo1-release.keystore -alias appjcenterwebsocketclientdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppJCenterWebSocketClientDemo1/keytool_input.txt
