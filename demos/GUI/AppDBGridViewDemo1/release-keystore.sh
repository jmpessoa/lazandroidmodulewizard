export JAVA_HOME=/Program Files (x86)/Java/jdk1.8.0_101
cd /android-neon/eclipse/workspace/AppDBGridViewDemo1
keytool -genkey -v -keystore AppDBGridViewDemo1-release.keystore -alias appdbgridviewdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppDBGridViewDemo1/appdbgridviewdemo1keytool_input.txt
