export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppZoomableImageViewDemo1
keytool -genkey -v -keystore appzoomableimageviewdemo1-release.keystore -alias appzoomableimageviewdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppZoomableImageViewDemo1/keytool_input.txt
