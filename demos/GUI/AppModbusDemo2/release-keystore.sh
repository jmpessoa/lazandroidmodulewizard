export JAVA_HOME=/Program Files/Java/jdk1.8.0_251
cd /lamw/latihan/modbus
keytool -genkey -v -keystore modbus-release.keystore -alias modbus.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /lamw/latihan/modbus/keytool_input.txt
