export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppUploadServiceDemo1
jarsigner -verify -verbose -certs /lamw/workspace/AppUploadServiceDemo1/bin/AppUploadServiceDemo1-release.apk
