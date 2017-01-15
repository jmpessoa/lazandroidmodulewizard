export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppNotificationManagerDemo1
keytool -genkey -v -keystore AppNotificationManagerDemo1-release.keystore -alias appnotificationmanagerdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppNotificationManagerDemo1/appnotificationmanagerdemo1keytool_input.txt
