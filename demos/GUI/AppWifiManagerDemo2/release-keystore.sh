export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppWifiManagerDemo2
keytool -genkey -v -keystore appwifimanagerdemo2-release.keystore -alias appwifimanagerdemo2.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppWifiManagerDemo2/keytool_input.txt
