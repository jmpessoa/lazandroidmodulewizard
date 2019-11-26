export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppChronometerDemo2
keytool -genkey -v -keystore appchronometerdemo2-release.keystore -alias appchronometerdemo2.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Temp/AppChronometerDemo2/keytool_input.txt
