set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_151
path %JAVA_HOME%\bin;%path%
cd C:\Temp\AppJNIException
jarsigner -verify -verbose -certs C:\Temp\AppJNIException\bin\AppJNIException-release.apk
