set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
path %JAVA_HOME%\bin;%path%
cd C:\android\workspace\AppMenuDemo3
jarsigner -verify -verbose -certs C:\android\workspace\AppMenuDemo3\build\outputs\apk\release\AppMenuDemo3-release.apk
