export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppApplyDrawableXMLDemo1
keytool -genkey -v -keystore appapplydrawablexmldemo1-release.keystore -alias appapplydrawablexmldemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppApplyDrawableXMLDemo1/keytool_input.txt
