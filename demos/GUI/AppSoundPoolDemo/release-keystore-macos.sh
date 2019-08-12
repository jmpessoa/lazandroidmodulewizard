export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppSoundPoolDemo
keytool -genkey -v -keystore appsoundpooldemo-release.keystore -alias appsoundpooldemo.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Temp/AppSoundPoolDemo/keytool_input.txt
