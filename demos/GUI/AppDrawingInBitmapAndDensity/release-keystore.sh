export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppDrawingInBitmap
keytool -genkey -v -keystore appdrawinginbitmap-release.keystore -alias appdrawinginbitmap.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppDrawingInBitmap/keytool_input.txt
