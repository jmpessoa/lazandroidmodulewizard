set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151\
path %JAVA_HOME%\bin;%path%
cd C:\laztoapk\projects\project1\AppListViewDemo2
jarsigner -verify -verbose -certs C:\laztoapk\projects\project1\AppListViewDemo2\bin\AppListViewDemo2-release.apk
