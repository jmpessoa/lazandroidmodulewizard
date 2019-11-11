export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppLibGDXDemo2
keytool -genkey -v -keystore applibgdxdemo2-release.keystore -alias applibgdxdemo2.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppLibGDXDemo2/keytool_input.txt
