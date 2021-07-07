export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatBottomNavigationDemo1
jarsigner -verify -verbose -certs /android/workspace/AppCompatBottomNavigationDemo1/build/outputs/apk/release/AppCompatBottomNavigationDemo1-release.apk
