export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /lamw/workspace/AppHttpClientDemo3
keytool -genkey -v -keystore AppHttpClientDemo3-release.keystore -alias apphttpclientdemo3aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppHttpClientDemo3/apphttpclientdemo3keytool_input.txt
