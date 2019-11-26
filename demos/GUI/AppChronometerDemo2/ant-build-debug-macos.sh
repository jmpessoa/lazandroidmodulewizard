export PATH=/laztoapk/downloads/apache-ant-1.10.3/bin:$PATH
export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppChronometerDemo2
ant -Dtouchtest.enabled=true debug
