export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatLanternDemo1
keytool -genkey -v -keystore appcompatlanterndemo1-release.keystore -alias appcompatlanterndemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCompatLanternDemo1/keytool_input.txt
