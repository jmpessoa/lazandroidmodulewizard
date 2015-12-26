export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppRadioGroupDemo1
keytool -genkey -v -keystore AppRadioGroupDemo1-release.keystore -alias appradiogroupdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppRadioGroupDemo1/appradiogroupdemo1keytool_input.txt
