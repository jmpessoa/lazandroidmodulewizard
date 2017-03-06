export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppIntentDemoLaunchApp
keytool -genkey -v -keystore AppIntentDemoLaunchApp-release.keystore -alias appintentdemolaunchappaliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppIntentDemoLaunchApp/appintentdemolaunchappkeytool_input.txt
