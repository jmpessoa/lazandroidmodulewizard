export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppHttpClientDemo3
keytool -genkey -v -keystore AppHttpClientDemo3-release.keystore -alias apphttpclientdemo3aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppHttpClientDemo3/apphttpclientdemo3keytool_input.txt
