export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/latihan/eMenu
jarsigner -verify -verbose -certs /lamw/latihan/eMenu/bin/eMenu-release.apk
