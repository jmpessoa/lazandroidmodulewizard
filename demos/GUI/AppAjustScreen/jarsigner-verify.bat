set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_151
path %JAVA_HOME%\bin;%path%
cd C:\Temp\AppAjustScreen
jarsigner -verify -verbose -certs C:\Temp\AppAjustScreen\bin\AppAjustScreen-release.apk
