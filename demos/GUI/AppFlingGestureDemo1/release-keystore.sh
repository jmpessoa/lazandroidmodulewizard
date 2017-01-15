export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppFlingGestureDemo1
keytool -genkey -v -keystore AppFlingGestureDemo1-release.keystore -alias appflinggesturedemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppFlingGestureDemo1/appflinggesturedemo1keytool_input.txt
