export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatFirebasePushNotificationListenerDemo1
keytool -genkey -v -keystore appcompatfirebasepushnotificationlistenerdemo1-release.keystore -alias appcompatfirebasepushnotificationlistenerdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCompatFirebasePushNotificationListenerDemo1/keytool_input.txt
