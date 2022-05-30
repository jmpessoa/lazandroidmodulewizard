export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppImageViewRippleEffectDemo1
jarsigner -verify -verbose -certs /android/workspace/AppImageViewRippleEffectDemo1/build/outputs/apk/release/AppImageViewRippleEffectDemo1-release.apk
