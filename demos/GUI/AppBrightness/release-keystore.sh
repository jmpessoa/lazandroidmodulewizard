export JAVA_HOME=/Program Files (x86)/Java/jdk1.8.0_151
cd /Temp/AppBrightness
keytool -genkey -v -keystore appbrightness-release.keystore -alias appbrightness.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Temp/AppBrightness/keytool_input.txt
