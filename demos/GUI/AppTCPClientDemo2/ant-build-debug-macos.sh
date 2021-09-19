export PATH=/Install/apache-ant-1.9.6/bin:$PATH
export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /AppTCPClientDemo1/
ant -Dtouchtest.enabled=true debug
