export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Projects/Karat/Xnix/AppWebDAVDemo1
jarsigner -verify -verbose -certs /Projects/Karat/Xnix/AppWebDAVDemo1/bin/AppWebDAVDemo1-release.apk
