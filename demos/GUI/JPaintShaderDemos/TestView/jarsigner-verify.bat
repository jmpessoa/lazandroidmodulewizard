set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_221
path %JAVA_HOME%\bin;%path%
cd J:\!work\FPC\TestView
jarsigner -verify -verbose -certs J:\!work\FPC\TestView\bin\TestView-release.apk
