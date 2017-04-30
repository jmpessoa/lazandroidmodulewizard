export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppSMSWidgetProviderDemo1
keytool -genkey -v -keystore AppSMSWidgetProviderDemo1-release.keystore -alias appsmswidgetproviderdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppSMSWidgetProviderDemo1/appsmswidgetproviderdemo1keytool_input.txt
