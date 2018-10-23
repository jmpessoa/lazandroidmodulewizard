export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppTelephonyManagerDemo1
keytool -genkey -v -keystore AppTelephonyManagerDemo1-release.keystore -alias apptelephonymanagerdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppTelephonyManagerDemo1/apptelephonymanagerdemo1keytool_input.txt
