set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_101
path %JAVA_HOME%\bin;%path%
cd C:\lamw\workspace\AppCompatAdMobDemo1
jarsigner -verify -verbose -certs C:\lamw\workspace\AppCompatAdMobDemo1\bin\AppCompatAdMobDemo1-release.apk
