export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppDrawingInBitmap
keytool -genkey -v -keystore appdrawinginbitmap-release.keystore -alias appdrawinginbitmap.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppDrawingInBitmap/keytool_input.txt
