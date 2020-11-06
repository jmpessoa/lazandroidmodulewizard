set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_151
path %JAVA_HOME%\bin;%path%
cd C:\Temp\AppCompactFileprovider
jarsigner -verify -verbose -certs C:\Temp\AppCompactFileprovider\bin\AppCompactFileprovider-release.apk
