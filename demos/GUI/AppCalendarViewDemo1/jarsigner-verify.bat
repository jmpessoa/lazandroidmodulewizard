set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
path %JAVA_HOME%\bin;%path%
cd C:\lamw\workspace\AppCalendarViewDemo1
jarsigner -verify -verbose -certs C:\lamw\workspace\AppCalendarViewDemo1\bin\AppCalendarViewDemo1-release.apk
