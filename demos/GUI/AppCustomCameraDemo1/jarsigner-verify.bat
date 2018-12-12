set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_101
path %JAVA_HOME%\bin;%path%
cd C:\android-neon\eclipse\workspace\AppCustomCameraDemo1
jarsigner -verify -verbose -certs C:\android-neon\eclipse\workspace\AppCustomCameraDemo1\bin\AppCustomCameraDemo1-release.apk
