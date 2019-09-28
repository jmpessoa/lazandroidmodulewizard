export JAVA_HOME=/Program Files/Java/jdk1.8.0_221
cd /!work/FPC/demos/GUI/AppSpriteDemo/AppSpriteDemo
keytool -genkey -v -keystore appspritedemo-release.keystore -alias appspritedemo.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /!work/FPC/demos/GUI/AppSpriteDemo/AppSpriteDemo/keytool_input.txt
