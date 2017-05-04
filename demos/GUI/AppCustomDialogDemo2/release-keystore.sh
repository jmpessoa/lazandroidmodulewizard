export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppCustomDialogDemo2
keytool -genkey -v -keystore AppCustomDialogDemo2-release.keystore -alias appcustomdialogdemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppCustomDialogDemo2/appcustomdialogdemo2keytool_input.txt
