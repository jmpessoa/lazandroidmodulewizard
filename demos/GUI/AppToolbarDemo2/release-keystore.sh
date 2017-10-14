export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppToolbarDemo2
keytool -genkey -v -keystore AppToolbarDemo2-release.keystore -alias apptoolbardemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppToolbarDemo2/apptoolbardemo2keytool_input.txt
