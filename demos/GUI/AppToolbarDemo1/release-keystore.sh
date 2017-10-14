export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppToolbarDemo1
keytool -genkey -v -keystore AppToolbarDemo1-release.keystore -alias apptoolbardemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppToolbarDemo1/apptoolbardemo1keytool_input.txt
