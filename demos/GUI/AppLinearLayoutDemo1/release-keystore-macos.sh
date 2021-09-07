export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppLinearLayoutDemo1
keytool -genkey -v -keystore applinearlayoutdemo1-release.keystore -alias applinearlayoutdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppLinearLayoutDemo1/keytool_input.txt
