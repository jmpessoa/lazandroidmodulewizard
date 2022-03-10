export PATH=/fpcupdeluxe/ccr/lamw-ant/apache-ant-1.10.12/bin:$PATH
export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /fpcupdeluxe/ccr/lamw/demos/GUI/AppBGRABitmapDemo1
ant -Dtouchtest.enabled=true debug
