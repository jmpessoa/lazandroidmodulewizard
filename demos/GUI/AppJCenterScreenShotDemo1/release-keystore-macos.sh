export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterScreenShotDemo1
keytool -genkey -v -keystore appjcenterscreenshotdemo1-release.keystore -alias appjcenterscreenshotdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppJCenterScreenShotDemo1/keytool_input.txt
