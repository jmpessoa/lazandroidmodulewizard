set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
path %JAVA_HOME%\bin;%path%
cd C:\android\workspace\AppHelloWord
jarsigner -verify -verbose -certs C:\android\workspace\AppHelloWord\bin\AppHelloWord-release.apk
