set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
cd C:\adt32\eclipse\workspace\AppContactManagerDemo2
keytool -genkey -v -keystore AppContactManagerDemo2-release.keystore -alias appcontactmanagerdemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\adt32\eclipse\workspace\AppContactManagerDemo2\keytool_input.txt
