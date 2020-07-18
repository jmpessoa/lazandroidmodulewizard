export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppUSSDServiceDemo1
keytool -genkey -v -keystore appussdservicedemo1-release.keystore -alias appussdservicedemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppUSSDServiceDemo1/keytool_input.txt
