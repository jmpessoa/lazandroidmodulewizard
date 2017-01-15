export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppSensorDemo1
keytool -genkey -v -keystore AppSensorDemo1-release.keystore -alias appsensordemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppSensorDemo1/appsensordemo1keytool_input.txt
