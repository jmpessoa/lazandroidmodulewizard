export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppMenuDemo2
keytool -genkey -v -keystore appmenudemo2-release.keystore -alias appmenudemo2.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppMenuDemo2/keytool_input.txt
