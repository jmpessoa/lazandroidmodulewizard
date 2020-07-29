export JAVA_HOME=/Android/jdk1.8.0_201
cd /svn/apps/inapp5
keytool -genkey -v -keystore inapp5-release.keystore -alias inapp5.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /svn/apps/inapp5/keytool_input.txt
