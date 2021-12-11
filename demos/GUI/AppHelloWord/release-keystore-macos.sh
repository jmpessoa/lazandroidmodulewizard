export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppHelloWord
keytool -genkey -v -keystore apphelloword-release.keystore -alias apphelloword.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppHelloWord/keytool_input.txt
