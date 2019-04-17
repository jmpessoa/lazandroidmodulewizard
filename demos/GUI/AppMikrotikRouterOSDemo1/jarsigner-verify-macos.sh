export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppMikrotikRouterOSDemo1
jarsigner -verify -verbose -certs /android/workspace/AppMikrotikRouterOSDemo1/bin/AppMikrotikRouterOSDemo1-release.apk
