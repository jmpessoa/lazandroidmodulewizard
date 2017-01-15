export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppMediaPlayerDemo1
keytool -genkey -v -keystore AppMediaPlayerDemo1-release.keystore -alias appmediaplayerdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppMediaPlayerDemo1/appmediaplayerdemo1keytool_input.txt
