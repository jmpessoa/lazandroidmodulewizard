export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /fpcupdeluxe/ccr/lamw/demos/GUI/AppBGRABitmapDemo1
jarsigner -verify -verbose -certs /fpcupdeluxe/ccr/lamw/demos/GUI/AppBGRABitmapDemo1/bin/AppBGRABitmapDemo1-release.apk
