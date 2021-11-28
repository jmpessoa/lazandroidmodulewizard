export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Core/Projs/Android/LAMW/LAMWThreadTest
jarsigner -verify -verbose -certs /Core/Projs/Android/LAMW/LAMWThreadTest/build/outputs/apk/release/LAMWThreadTest-release.apk
