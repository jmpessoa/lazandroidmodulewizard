export JAVA_HOME=/Program Files (x86)/Java/jdk1.8.0_101
cd /android-neon/eclipse/workspace/AppCustomCameraDemo1
keytool -genkey -v -keystore AppCustomCameraDemo1-release.keystore -alias appcustomcamerademo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppCustomCameraDemo1/appcustomcamerademo1keytool_input.txt
