export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppGifAnimationDemo1
jarsigner -verify -verbose -certs /android/workspace/AppGifAnimationDemo1/bin/AppGifAnimationDemo1-release.apk
