export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppWebviewDemoEvaluateJavaScript
jarsigner -verify -verbose -certs /android/workspace/AppWebviewDemoEvaluateJavaScript/bin/AppWebviewDemoEvaluateJavaScript-release.apk
