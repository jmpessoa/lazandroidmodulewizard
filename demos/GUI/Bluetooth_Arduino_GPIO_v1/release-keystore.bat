set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_91
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\lamw\projects\\Bluetooth_Arduino_GPIO_v1
keytool -genkey -v -keystore Bluetooth_Arduino_GPIO_v1-release.keystore -alias bluetooth_arduino_gpio_v1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\lamw\projects\\Bluetooth_Arduino_GPIO_v1\keytool_input.txt
