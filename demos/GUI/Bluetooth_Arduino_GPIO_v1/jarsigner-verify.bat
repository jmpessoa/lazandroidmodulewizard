set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_91
path %JAVA_HOME%\bin;%path%
cd C:\lamw\projects\\Bluetooth_Arduino_GPIO_v1
jarsigner -verify -verbose -certs C:\lamw\projects\\Bluetooth_Arduino_GPIO_v1\bin\Bluetooth_Arduino_GPIO_v1-release.apk
