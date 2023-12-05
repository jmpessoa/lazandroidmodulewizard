export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCustomDialogDemo3
keytool -genkey -v -keystore appcustomdialogdemo3-release.keystore -alias appcustomdialogdemo3.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCustomDialogDemo3/keytool_input.txt
