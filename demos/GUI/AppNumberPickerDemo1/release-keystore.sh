export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppNumberPickerDemo1
keytool -genkey -v -keystore AppNumberPickerDemo1-release.keystore -alias appnumberpickerdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppNumberPickerDemo1/appnumberpickerdemo1keytool_input.txt
