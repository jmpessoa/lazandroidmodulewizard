export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppIntentDemoPrinting1
keytool -genkey -v -keystore AppIntentDemoPrinting1-release.keystore -alias appintentdemoprinting1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppIntentDemoPrinting1/appintentdemoprinting1keytool_input.txt
