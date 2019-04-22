export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppCompatScreenShotDemo1
keytool -genkey -v -keystore appcompatscreenshotdemo1-release.keystore -alias appcompatscreenshotdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCompatScreenShotDemo1/keytool_input.txt
