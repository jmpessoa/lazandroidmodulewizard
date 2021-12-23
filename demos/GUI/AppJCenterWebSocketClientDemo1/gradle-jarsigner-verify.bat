set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
path %JAVA_HOME%\bin;%path%
cd C:\android\workspace\AppJCenterWebSocketClientDemo1
jarsigner -verify -verbose -certs C:\android\workspace\AppJCenterWebSocketClientDemo1\build\outputs\apk\release\AppJCenterWebSocketClientDemo1-release.apk
