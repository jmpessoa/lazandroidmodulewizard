export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppHttpClientDemo2
keytool -genkey -v -keystore AppHttpClientDemo2-release.keystore -alias apphttpclientdemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppHttpClientDemo2/apphttpclientdemo2keytool_input.txt
