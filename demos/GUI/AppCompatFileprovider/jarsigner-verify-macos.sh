export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppCompactFileprovider
jarsigner -verify -verbose -certs /Temp/AppCompactFileprovider/bin/AppCompactFileprovider-release.apk
