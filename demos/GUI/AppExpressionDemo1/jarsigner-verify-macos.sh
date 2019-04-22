export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppExpressionDemo1
jarsigner -verify -verbose -certs /android/workspace/AppExpressionDemo1/bin/AppExpressionDemo1-release.apk
