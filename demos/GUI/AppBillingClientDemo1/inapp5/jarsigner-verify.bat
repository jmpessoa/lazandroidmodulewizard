set JAVA_HOME=C:\Android\jdk1.8.0_201
path %JAVA_HOME%\bin;%path%
cd c:\svn\apps\inapp5
jarsigner -verify -verbose -certs c:\svn\apps\inapp5\bin\inapp5-release.apk
