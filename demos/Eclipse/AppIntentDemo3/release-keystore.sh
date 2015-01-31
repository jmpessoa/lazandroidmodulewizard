export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppIntentDemo3
keytool -genkey -v -keystore AppIntentDemo3-release.keystore -alias appintentdemo3aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppIntentDemo3/appintentdemo3keytool_input.txt
