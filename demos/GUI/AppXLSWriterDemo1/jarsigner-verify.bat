set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
path %JAVA_HOME%\bin;%path%
cd C:\lamw\workspace\AppXLSWriterDemo1
jarsigner -verify -verbose -certs C:\lamw\workspace\AppXLSWriterDemo1\bin\AppXLSWriterDemo1-release.apk
