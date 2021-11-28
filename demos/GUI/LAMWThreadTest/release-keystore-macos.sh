export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Core/Projs/Android/LAMW/LAMWThreadTest
keytool -genkey -v -keystore lamwthreadtest-release.keystore -alias lamwthreadtest.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Core/Projs/Android/LAMW/LAMWThreadTest/keytool_input.txt
