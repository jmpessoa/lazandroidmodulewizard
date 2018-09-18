export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppCalendarViewDemo1
keytool -genkey -v -keystore AppCalendarViewDemo1-release.keystore -alias appcalendarviewdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppCalendarViewDemo1/appcalendarviewdemo1keytool_input.txt
