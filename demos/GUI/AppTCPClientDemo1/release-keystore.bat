set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
cd C:\adt32\eclipse\workspace\AppTCPClientDemo1
keytool -genkey -v -keystore AppTCPClientDemo1-release.keystore -alias apptcpclientdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\adt32\eclipse\workspace\AppTCPClientDemo1\keytool_input.txt
