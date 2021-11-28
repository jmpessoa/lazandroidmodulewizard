set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_25
path %JAVA_HOME%\bin;%path%
cd C:\Core\Projs\Android\LAMW\LAMWThreadTest
jarsigner -verify -verbose -certs C:\Core\Projs\Android\LAMW\LAMWThreadTest\build\outputs\apk\release\LAMWThreadTest-release.apk
