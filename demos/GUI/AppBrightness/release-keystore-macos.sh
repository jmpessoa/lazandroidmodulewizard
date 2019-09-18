export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppBrightness
keytool -genkey -v -keystore appbrightness-release.keystore -alias appbrightness.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Temp/AppBrightness/keytool_input.txt
