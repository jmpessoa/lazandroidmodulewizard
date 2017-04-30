export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppSqliteDemo3
keytool -genkey -v -keystore AppSqliteDemo3-release.keystore -alias appsqlitedemo3aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppSqliteDemo3/appsqlitedemo3keytool_input.txt
