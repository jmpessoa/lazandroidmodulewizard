export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppWebViewDemo1
keytool -genkey -v -keystore appwebviewdemo1-release.keystore -alias appwebviewdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppWebViewDemo1/keytool_input.txt
