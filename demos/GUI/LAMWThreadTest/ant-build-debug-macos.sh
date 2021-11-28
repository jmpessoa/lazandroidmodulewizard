export PATH=/apache-ant-1.9.9/bin:$PATH
export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Core/Projs/Android/LAMW/LAMWThreadTest
ant -Dtouchtest.enabled=true debug
