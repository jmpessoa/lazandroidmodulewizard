export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppMapsDemo1
keytool -genkey -v -keystore AppMapsDemo1-release.keystore -alias appmapsdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppMapsDemo1/appmapsdemo1keytool_input.txt
