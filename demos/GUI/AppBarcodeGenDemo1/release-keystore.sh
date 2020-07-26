export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppBarcodeGenDemo1
keytool -genkey -v -keystore appbarcodegendemo1-release.keystore -alias appbarcodegendemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppBarcodeGenDemo1/keytool_input.txt
