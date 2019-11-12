set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_221
path %JAVA_HOME%\bin;%path%
cd J:\!work\FPC\TestDrawingView
jarsigner -verify -verbose -certs J:\!work\FPC\TestDrawingView\bin\TestDrawingView-release.apk
