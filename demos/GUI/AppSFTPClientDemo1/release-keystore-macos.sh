export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppSFTPClientDemo1
keytool -genkey -v -keystore appsftpclientdemo1-release.keystore -alias appsftpclientdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppSFTPClientDemo1/keytool_input.txt
