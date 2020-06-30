export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppListViewDemo6
keytool -genkey -v -keystore applistviewdemo6-release.keystore -alias applistviewdemo6.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppListViewDemo6/keytool_input.txt
