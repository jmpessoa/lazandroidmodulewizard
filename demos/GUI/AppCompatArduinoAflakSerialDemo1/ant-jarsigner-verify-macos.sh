export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatArduinoAflakSerialDemo1
jarsigner -verify -verbose -certs /android/workspace/AppCompatArduinoAflakSerialDemo1/bin/AppCompatArduinoAflakSerialDemo1-release.apk
