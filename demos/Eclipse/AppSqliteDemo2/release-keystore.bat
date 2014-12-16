set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
cd C:\adt32\eclipse\workspace\AppSqliteDemo2
keytool -genkey -v -keystore AppSqliteDemo2-release.keystore -alias appsqlitedemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\adt32\eclipse\workspace\AppSqliteDemo2\keytool_input.txt
