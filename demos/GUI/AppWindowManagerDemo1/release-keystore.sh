export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppWindowManagerDemo1
keytool -genkey -v -keystore AppWindowManagerDemo1-release.keystore -alias appwindowmanagerdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppWindowManagerDemo1/appwindowmanagerdemo1keytool_input.txt
