export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /!work/FPC/demos/GUI/AppSpriteDemo/AppSpriteDemo
keytool -genkey -v -keystore appspritedemo-release.keystore -alias appspritedemo.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /!work/FPC/demos/GUI/AppSpriteDemo/AppSpriteDemo/keytool_input.txt
