export JAVA_HOME=/Program Files (x86)/Java/jdk1.8.0_151
cd /Temp/AppCompactFileprovider
keytool -genkey -v -keystore appcompactfileprovider-release.keystore -alias appcompactfileprovider.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Temp/AppCompactFileprovider/keytool_input.txt
