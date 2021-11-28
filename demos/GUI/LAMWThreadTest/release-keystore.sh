export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_25
cd /Core/Projs/Android/LAMW/LAMWThreadTest
keytool -genkey -v -keystore lamwthreadtest-release.keystore -alias lamwthreadtest.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Core/Projs/Android/LAMW/LAMWThreadTest/keytool_input.txt
