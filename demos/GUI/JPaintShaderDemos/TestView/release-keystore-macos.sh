export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /!work/FPC/TestView
keytool -genkey -v -keystore testview-release.keystore -alias testview.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /!work/FPC/TestView/keytool_input.txt
