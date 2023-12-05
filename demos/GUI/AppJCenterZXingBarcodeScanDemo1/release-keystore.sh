export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppJCenterZXingBarcodeScanDemo1
LC_ALL=C keytool -genkey -v -keystore appjcenterzxingbarcodescandemo1-release.keystore -alias appjcenterzxingbarcodescandemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppJCenterZXingBarcodeScanDemo1/keytool_input.txt
