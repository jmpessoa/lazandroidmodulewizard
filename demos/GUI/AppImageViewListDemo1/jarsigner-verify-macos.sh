export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppImageViewListDemo1
jarsigner -verify -verbose -certs /android/workspace/AppImageViewListDemo1/bin/AppImageViewListDemo1-release.apk
