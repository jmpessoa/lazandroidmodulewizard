export PATH=/fpcupdeluxe/ccr/lamw-ant/apache-ant-1.10.9/bin:$PATH
export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/latihan/modbus
ant clean release
