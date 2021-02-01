export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppNoGUIDemo1
keytool -genkey -v -keystore appnoguidemo1-release.keystore -alias appnoguidemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppNoGUIDemo1/keytool_input.txt
