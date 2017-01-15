export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppIntentDemo2
keytool -genkey -v -keystore AppIntentDemo2-release.keystore -alias appintentdemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppIntentDemo2/appintentdemo2keytool_input.txt
