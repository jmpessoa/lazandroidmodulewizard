export JAVA_HOME=/Program Files/Java/jdk1.8.0_221
cd /!work/FPC/TestDrawingView
keytool -genkey -v -keystore testdrawingview-release.keystore -alias testdrawingview.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /!work/FPC/TestDrawingView/keytool_input.txt
