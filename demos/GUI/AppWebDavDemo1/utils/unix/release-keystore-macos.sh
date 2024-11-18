export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Projects/Karat/Xnix/AppWebDAVDemo1
keytool -genkey -v -keystore appwebdavdemo1-release.keystore -alias appwebdavdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Projects/Karat/Xnix/AppWebDAVDemo1/keytool_input.txt
