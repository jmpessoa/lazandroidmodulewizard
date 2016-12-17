export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppImageBtnDemo1
keytool -genkey -v -keystore AppImageBtnDemo1-release.keystore -alias appimagebtndemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppImageBtnDemo1/appimagebtndemo1keytool_input.txt
