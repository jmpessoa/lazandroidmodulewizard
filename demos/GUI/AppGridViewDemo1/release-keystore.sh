export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppGridViewDemo1
keytool -genkey -v -keystore AppGridViewDemo1-release.keystore -alias appgridviewdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppGridViewDemo1/appgridviewdemo1keytool_input.txt
