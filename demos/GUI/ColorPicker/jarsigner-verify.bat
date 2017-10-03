set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_91
path %JAVA_HOME%\bin;%path%
cd C:\lamw\projects\\ColorPicker
jarsigner -verify -verbose -certs C:\lamw\projects\\ColorPicker\bin\ColorPicker-release.apk
