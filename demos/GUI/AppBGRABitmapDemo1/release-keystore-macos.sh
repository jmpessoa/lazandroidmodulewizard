export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /fpcupdeluxe/ccr/lamw/demos/GUI/AppBGRABitmapDemo1
keytool -genkey -v -keystore appbgrabitmapdemo1-release.keystore -alias appbgrabitmapdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /fpcupdeluxe/ccr/lamw/demos/GUI/AppBGRABitmapDemo1/keytool_input.txt
