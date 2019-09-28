export PATH=/FPC_Luxe/apache-ant-1.10.6/bin:$PATH
export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /!work/FPC/demos/GUI/AppSpriteDemo/AppSpriteDemo
ant -Dtouchtest.enabled=true debug
