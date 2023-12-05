set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
path %JAVA_HOME%\bin;%path%
cd C:\android\workspace\AppCustomDialogDemo3
jarsigner -verify -verbose -certs C:\android\workspace\AppCustomDialogDemo3\bin\AppCustomDialogDemo3-release.apk
