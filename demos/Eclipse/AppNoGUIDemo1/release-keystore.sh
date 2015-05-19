export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppNoGUIDemo1
keytool -genkey -v -keystore AppNoGUIDemo1-release.keystore -alias appnoguidemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppNoGUIDemo1/appnoguidemo1keytool_input.txt
