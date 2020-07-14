export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCustomSpeechToTextDemo1
keytool -genkey -v -keystore appcustomspeechtotextdemo1-release.keystore -alias appcustomspeechtotextdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCustomSpeechToTextDemo1/keytool_input.txt
