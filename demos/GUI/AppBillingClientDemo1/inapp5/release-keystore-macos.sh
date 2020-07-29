export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /svn/apps/inapp5
keytool -genkey -v -keystore inapp5-release.keystore -alias inapp5.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /svn/apps/inapp5/keytool_input.txt
