export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppImageViewRippleEffectDemo1
keytool -genkey -v -keystore appimageviewrippleeffectdemo1-release.keystore -alias appimageviewrippleeffectdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppImageViewRippleEffectDemo1/keytool_input.txt
