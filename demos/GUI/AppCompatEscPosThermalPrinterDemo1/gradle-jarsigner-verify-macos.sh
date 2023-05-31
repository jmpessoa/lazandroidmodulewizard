export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatEscPosThermalPrinterDemo1
jarsigner -verify -verbose -certs /android/workspace/AppCompatEscPosThermalPrinterDemo1/build/outputs/apk/release/AppCompatEscPosThermalPrinterDemo1-release.apk
