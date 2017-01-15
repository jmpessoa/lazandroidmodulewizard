set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
cd C:\adt32\eclipse\workspace\AppToggleButtonDemo1
keytool -genkey -v -keystore AppToggleButtonDemo1-release.keystore -alias apptogglebuttondemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\adt32\eclipse\workspace\AppToggleButtonDemo1\keytool_input.txt
