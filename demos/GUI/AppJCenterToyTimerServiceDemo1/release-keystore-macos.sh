export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterToyTimerServiceDemo1
keytool -genkey -v -keystore appjcentertoytimerservicedemo1-release.keystore -alias appjcentertoytimerservicedemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppJCenterToyTimerServiceDemo1/keytool_input.txt
