export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppToggleButtonDemo1
keytool -genkey -v -keystore AppToggleButtonDemo1-release.keystore -alias apptogglebuttondemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppToggleButtonDemo1/apptogglebuttondemo1keytool_input.txt
