export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppNotificationManagerDemo2
keytool -genkey -v -keystore AppNotificationManagerDemo2-release.keystore -alias appnotificationmanagerdemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppNotificationManagerDemo2/appnotificationmanagerdemo2keytool_input.txt
