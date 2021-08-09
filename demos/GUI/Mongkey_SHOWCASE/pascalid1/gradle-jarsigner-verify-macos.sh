export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /fpcupdeluxe/projects/LAMWProjects/pascalid1
jarsigner -verify -verbose -certs /fpcupdeluxe/projects/LAMWProjects/pascalid1/build/outputs/apk/release/pascalid1-release.apk
