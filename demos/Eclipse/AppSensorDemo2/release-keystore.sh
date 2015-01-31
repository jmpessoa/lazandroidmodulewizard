export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppSensorDemo2
keytool -genkey -v -keystore AppSensorDemo2-release.keystore -alias appsensordemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppSensorDemo2/appsensordemo2keytool_input.txt
