export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatArduinoAflakSerialDemo1
keytool -genkey -v -keystore appcompatarduinoaflakserialdemo1-release.keystore -alias appcompatarduinoaflakserialdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCompatArduinoAflakSerialDemo1/keytool_input.txt
