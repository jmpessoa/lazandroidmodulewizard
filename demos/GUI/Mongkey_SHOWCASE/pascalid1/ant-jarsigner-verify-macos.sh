export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /fpcupdeluxe/projects/LAMWProjects/pascalid1
jarsigner -verify -verbose -certs /fpcupdeluxe/projects/LAMWProjects/pascalid1/bin/pascalid1-release.apk
