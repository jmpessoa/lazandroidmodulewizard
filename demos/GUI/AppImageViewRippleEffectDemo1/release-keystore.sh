export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppImageViewRippleEffectDemo1
LC_ALL=C keytool -genkey -v -keystore appimageviewrippleeffectdemo1-release.keystore -alias appimageviewrippleeffectdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppImageViewRippleEffectDemo1/keytool_input.txt
