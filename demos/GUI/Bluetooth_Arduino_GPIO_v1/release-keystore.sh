export JAVA_HOME=/Program Files/Java/jdk1.8.0_91
cd /lamw/projects//Bluetooth_Arduino_GPIO_v1
keytool -genkey -v -keystore Bluetooth_Arduino_GPIO_v1-release.keystore -alias bluetooth_arduino_gpio_v1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/projects//Bluetooth_Arduino_GPIO_v1/bluetooth_arduino_gpio_v1keytool_input.txt
