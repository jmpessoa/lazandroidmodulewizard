export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppUSSDServiceDemo1
keytool -genkey -v -keystore appussdservicedemo1-release.keystore -alias appussdservicedemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppUSSDServiceDemo1/keytool_input.txt
