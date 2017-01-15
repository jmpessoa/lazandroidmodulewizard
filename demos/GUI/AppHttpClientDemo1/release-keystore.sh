export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppHttpClientDemo1
keytool -genkey -v -keystore AppHttpClientDemo1-release.keystore -alias apphttpclientdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppHttpClientDemo1/apphttpclientdemo1keytool_input.txt
