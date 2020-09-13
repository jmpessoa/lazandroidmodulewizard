export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppListviewDemo7
keytool -genkey -v -keystore applistviewdemo7-release.keystore -alias applistviewdemo7.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppListviewDemo7/keytool_input.txt
