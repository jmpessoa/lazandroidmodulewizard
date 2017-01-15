set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
path %JAVA_HOME%\bin;%path%
cd C:\adt32\eclipse\workspace\AppPanelRotateDemo1
jarsigner -verify -verbose -certs C:\adt32\eclipse\workspace\AppPanelRotateDemo1\bin\AppPanelRotateDemo1-release.apk
