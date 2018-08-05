export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppCompatAdMobDemo1
jarsigner -verify -verbose -certs /lamw/workspace/AppCompatAdMobDemo1/bin/AppCompatAdMobDemo1-release.apk
