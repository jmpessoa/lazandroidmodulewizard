export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatNavigationDrawerDemo2
jarsigner -verify -verbose -certs /android/workspace/AppCompatNavigationDrawerDemo2/bin/AppCompatNavigationDrawerDemo2-release.apk
