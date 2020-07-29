export PATH=/Android/apache-ant-1.10.3/bin/:$PATH
export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /svn/apps/inapp5
ant clean release
