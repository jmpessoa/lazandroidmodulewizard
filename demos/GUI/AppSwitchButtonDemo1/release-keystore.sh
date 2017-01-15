export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppSwitchButtonDemo1
keytool -genkey -v -keystore AppSwitchButtonDemo1-release.keystore -alias appswitchbuttondemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppSwitchButtonDemo1/appswitchbuttondemo1keytool_input.txt
