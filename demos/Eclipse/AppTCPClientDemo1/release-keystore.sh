export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppTCPClientDemo1
keytool -genkey -v -keystore AppTCPClientDemo1-release.keystore -alias apptcpclientdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppTCPClientDemo1/apptcpclientdemo1keytool_input.txt
