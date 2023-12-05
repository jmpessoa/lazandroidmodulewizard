export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatEscPosThermalPrinterDemo1
keytool -genkey -v -keystore appcompatescposthermalprinterdemo1-release.keystore -alias appcompatescposthermalprinterdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCompatEscPosThermalPrinterDemo1/keytool_input.txt
