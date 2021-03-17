export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppJNIException
keytool -genkey -v -keystore appjniexception-release.keystore -alias appjniexception.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Temp/AppJNIException/keytool_input.txt
