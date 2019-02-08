export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppCompatRecyclerViewDemo1
jarsigner -verify -verbose -certs /lamw/workspace/AppCompatRecyclerViewDemo1/bin/AppCompatRecyclerViewDemo1-release.apk
