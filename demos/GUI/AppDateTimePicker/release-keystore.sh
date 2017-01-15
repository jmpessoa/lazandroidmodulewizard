export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppDateTimePicker
keytool -genkey -v -keystore AppDateTimePicker-release.keystore -alias appdatetimepickeraliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppDateTimePicker/appdatetimepickerkeytool_input.txt
