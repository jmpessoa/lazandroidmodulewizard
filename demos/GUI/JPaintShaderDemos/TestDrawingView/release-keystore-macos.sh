export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /!work/FPC/TestDrawingView
keytool -genkey -v -keystore testdrawingview-release.keystore -alias testdrawingview.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /!work/FPC/TestDrawingView/keytool_input.txt
