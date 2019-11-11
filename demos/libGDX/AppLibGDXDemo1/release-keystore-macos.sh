export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppLibGDXDemo1
keytool -genkey -v -keystore applibgdxdemo1-release.keystore -alias applibgdxdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppLibGDXDemo1/keytool_input.txt
