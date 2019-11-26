set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_221
path %JAVA_HOME%\bin;%path%
cd C:\Temp\AppChronometerDemo2
jarsigner -verify -verbose -certs C:\Temp\AppChronometerDemo2\bin\AppChronometerDemo2-release.apk
