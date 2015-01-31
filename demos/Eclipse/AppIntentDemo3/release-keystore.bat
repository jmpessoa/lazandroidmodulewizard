set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
cd C:\adt32\eclipse\workspace\AppIntentDemo3
keytool -genkey -v -keystore AppIntentDemo3-release.keystore -alias appintentdemo3aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\adt32\eclipse\workspace\AppIntentDemo3\keytool_input.txt
