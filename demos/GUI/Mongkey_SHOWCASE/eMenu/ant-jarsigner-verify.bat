set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_251
path %JAVA_HOME%\bin;%path%
cd F:\lamw\latihan\eMenu
jarsigner -verify -verbose -certs F:\lamw\latihan\eMenu\bin\eMenu-release.apk
