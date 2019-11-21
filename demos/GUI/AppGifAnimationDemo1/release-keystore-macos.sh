export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppGifAnimationDemo1
keytool -genkey -v -keystore appgifanimationdemo1-release.keystore -alias appgifanimationdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppGifAnimationDemo1/keytool_input.txt
