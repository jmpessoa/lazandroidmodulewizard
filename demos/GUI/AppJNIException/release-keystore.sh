export JAVA_HOME=/Program Files (x86)/Java/jdk1.8.0_151
cd /Temp/AppJNIException
keytool -genkey -v -keystore appjniexception-release.keystore -alias appjniexception.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Temp/AppJNIException/keytool_input.txt
