export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppJCenterScreenShotDemo1
keytool -genkey -v -keystore appjcenterscreenshotdemo1-release.keystore -alias appjcenterscreenshotdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppJCenterScreenShotDemo1/keytool_input.txt
