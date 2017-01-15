set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
cd C:\adt32\eclipse\workspace\AppDateTimePicker
keytool -genkey -v -keystore AppDateTimePicker-release.keystore -alias appdatetimepickeraliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\adt32\eclipse\workspace\AppDateTimePicker\keytool_input.txt
