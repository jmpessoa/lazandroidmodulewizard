export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppCameraDemo2
keytool -genkey -v -keystore appcamerademo2-release.keystore -alias appcamerademo2.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCameraDemo2/keytool_input.txt
