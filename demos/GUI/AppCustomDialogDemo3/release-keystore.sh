export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppCustomDialogDemo3
LC_ALL=C keytool -genkey -v -keystore appcustomdialogdemo3-release.keystore -alias appcustomdialogdemo3.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCustomDialogDemo3/keytool_input.txt
