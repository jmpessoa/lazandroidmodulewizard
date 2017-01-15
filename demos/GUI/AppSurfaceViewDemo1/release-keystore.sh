export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppSurfaceViewDemo1
keytool -genkey -v -keystore AppSurfaceViewDemo1-release.keystore -alias appsurfaceviewdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppSurfaceViewDemo1/appsurfaceviewdemo1keytool_input.txt
