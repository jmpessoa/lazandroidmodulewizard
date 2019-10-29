export JAVA_HOME=/Program Files (x86)/Java/jdk1.8.0_151
cd /Temp/AppAjustScreen
keytool -genkey -v -keystore appajustscreen-release.keystore -alias appajustscreen.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Temp/AppAjustScreen/keytool_input.txt
