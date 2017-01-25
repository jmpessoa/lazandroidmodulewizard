export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppFileProviderDemo1
keytool -genkey -v -keystore AppFileProviderDemo1-release.keystore -alias appfileproviderdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppFileProviderDemo1/appfileproviderdemo1keytool_input.txt
