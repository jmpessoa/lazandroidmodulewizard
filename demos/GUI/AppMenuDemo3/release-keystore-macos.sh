export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppMenuDemo3
keytool -genkey -v -keystore appmenudemo3-release.keystore -alias appmenudemo3.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppMenuDemo3/keytool_input.txt
