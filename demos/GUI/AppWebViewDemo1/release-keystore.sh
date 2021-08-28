export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppWebViewDemo1
keytool -genkey -v -keystore appwebviewdemo1-release.keystore -alias appwebviewdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppWebViewDemo1/keytool_input.txt
