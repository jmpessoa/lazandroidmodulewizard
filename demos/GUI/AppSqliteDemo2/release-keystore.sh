export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppSqliteDemo2
keytool -genkey -v -keystore AppSqliteDemo2-release.keystore -alias appsqlitedemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppSqliteDemo2/appsqlitedemo2keytool_input.txt
