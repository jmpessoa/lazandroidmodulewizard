export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterMikrotikRouterOSDemo1
jarsigner -verify -verbose -certs /android/workspace/AppJCenterMikrotikRouterOSDemo1/bin/AppJCenterMikrotikRouterOSDemo1-release.apk
