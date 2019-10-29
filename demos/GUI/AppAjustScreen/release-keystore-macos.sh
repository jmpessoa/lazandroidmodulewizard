export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppAjustScreen
keytool -genkey -v -keystore appajustscreen-release.keystore -alias appajustscreen.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Temp/AppAjustScreen/keytool_input.txt
