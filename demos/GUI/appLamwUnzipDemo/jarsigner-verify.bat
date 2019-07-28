set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_201\
path %JAVA_HOME%\bin;%path%
cd D:\dev\dev\lazarus\Unzipper\AppLAMWUnzipDemo
jarsigner -verify -verbose -certs D:\dev\dev\lazarus\Unzipper\AppLAMWUnzipDemo\bin\AppLAMWUnzipDemo-release.apk
