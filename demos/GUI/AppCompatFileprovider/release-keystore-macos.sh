export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppCompactFileprovider
keytool -genkey -v -keystore appcompactfileprovider-release.keystore -alias appcompactfileprovider.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Temp/AppCompactFileprovider/keytool_input.txt
