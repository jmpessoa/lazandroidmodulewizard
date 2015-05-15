export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppCustomShowMessageDemo1
keytool -genkey -v -keystore AppCustomShowMessageDemo1-release.keystore -alias appcustomshowmessagedemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppCustomShowMessageDemo1/appcustomshowmessagedemo1keytool_input.txt
