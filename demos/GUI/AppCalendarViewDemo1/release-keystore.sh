export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /lamw/workspace/AppCalendarViewDemo1
keytool -genkey -v -keystore AppCalendarViewDemo1-release.keystore -alias appcalendarviewdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppCalendarViewDemo1/appcalendarviewdemo1keytool_input.txt
