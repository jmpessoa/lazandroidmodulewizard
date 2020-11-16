export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatNavigationDrawerDemo2
keytool -genkey -v -keystore appcompatnavigationdrawerdemo2-release.keystore -alias appcompatnavigationdrawerdemo2.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCompatNavigationDrawerDemo2/keytool_input.txt
