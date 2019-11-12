export JAVA_HOME=/Program Files/Java/jdk1.8.0_221
cd /!work/FPC/TestView
keytool -genkey -v -keystore testview-release.keystore -alias testview.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /!work/FPC/TestView/keytool_input.txt
