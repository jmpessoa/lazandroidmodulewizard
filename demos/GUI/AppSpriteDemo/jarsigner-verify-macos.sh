export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /!work/FPC/demos/GUI/AppSpriteDemo/AppSpriteDemo
jarsigner -verify -verbose -certs /!work/FPC/demos/GUI/AppSpriteDemo/AppSpriteDemo/bin/AppSpriteDemo-release.apk
