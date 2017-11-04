set JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
path %JAVA_HOME%/bin;%path%
cd /home/handoko/Projects/Project Software/Android Test/glTest1
jarsigner -verify -verbose -certs /home/handoko/Projects/Project Software/Android Test/glTest1/bin/glTest1-release.apk
