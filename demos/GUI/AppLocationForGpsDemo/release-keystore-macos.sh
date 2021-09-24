export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Users/mali.aydin/Desktop/Lazarus_Jni/AppLocationForGpsDemo
keytool -genkey -v -keystore applocationforgpsdemo-release.keystore -alias applocationforgpsdemo.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Users/mali.aydin/Desktop/Lazarus_Jni/AppLocationForGpsDemo/keytool_input.txt
