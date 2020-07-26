export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppBarcodeGenDemo1
keytool -genkey -v -keystore appbarcodegendemo1-release.keystore -alias appbarcodegendemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppBarcodeGenDemo1/keytool_input.txt
