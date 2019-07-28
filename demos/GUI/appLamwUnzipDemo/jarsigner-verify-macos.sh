export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /dev/dev/lazarus/Unzipper/AppLAMWUnzipDemo
jarsigner -verify -verbose -certs /dev/dev/lazarus/Unzipper/AppLAMWUnzipDemo/bin/AppLAMWUnzipDemo-release.apk
