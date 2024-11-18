set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_60
path %JAVA_HOME%\bin;%path%
cd C:\Projects\Karat\Xnix\AppWebDAVDemo1
jarsigner -verify -verbose -certs C:\Projects\Karat\Xnix\AppWebDAVDemo1\build\outputs\apk\release\AppWebDAVDemo1-release.apk
