export PATH=/adt32/ant/bin:$PATH
export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatFirebasePushNotificationListenerDemo1/
ant -Dtouchtest.enabled=true debug
