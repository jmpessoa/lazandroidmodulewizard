export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppWebviewDemoEvaluateJavaScript
keytool -genkey -v -keystore appwebviewdemoevaluatejavascript-release.keystore -alias appwebviewdemoevaluatejavascript.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppWebviewDemoEvaluateJavaScript/keytool_input.txt
