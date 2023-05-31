export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppCompatEscPosThermalPrinterDemo1
LC_ALL=C keytool -genkey -v -keystore appcompatescposthermalprinterdemo1-release.keystore -alias appcompatescposthermalprinterdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCompatEscPosThermalPrinterDemo1/keytool_input.txt
