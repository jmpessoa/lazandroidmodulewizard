export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppDrawingViewDemo2
keytool -genkey -v -keystore appdrawingviewdemo2-release.keystore -alias appdrawingviewdemo2.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppDrawingViewDemo2/keytool_input.txt
