export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatBottomNavigationDemo1
jarsigner -verify -verbose -certs /android/workspace/AppCompatBottomNavigationDemo1/bin/AppCompatBottomNavigationDemo1-release.apk
