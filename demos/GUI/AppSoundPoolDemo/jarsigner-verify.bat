set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_221
path %JAVA_HOME%\bin;%path%
cd C:\Temp\AppSoundPoolDemo
jarsigner -verify -verbose -certs C:\Temp\AppSoundPoolDemo\bin\AppSoundPoolDemo-release.apk
