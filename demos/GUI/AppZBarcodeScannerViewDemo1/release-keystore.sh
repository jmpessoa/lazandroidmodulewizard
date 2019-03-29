export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppZBarcodeScannerViewDemo1
keytool -genkey -v -keystore appzbarcodescannerviewdemo1-release.keystore -alias appzbarcodescannerviewdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppZBarcodeScannerViewDemo1/keytool_input.txt
