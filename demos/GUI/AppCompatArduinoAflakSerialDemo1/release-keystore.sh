export JAVA_HOME=/Program Files/Eclipse Adoptium/jdk-11.0.21.9
cd /android/workspace/AppCompatArduinoAflakSerialDemo1
LC_ALL=C keytool -genkey -v -keystore appcompatarduinoaflakserialdemo1-release.keystore -alias appcompatarduinoaflakserialdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCompatArduinoAflakSerialDemo1/keytool_input.txt
