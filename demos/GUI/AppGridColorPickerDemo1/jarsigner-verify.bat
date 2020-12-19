set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_181
path %JAVA_HOME%\bin;%path%
cd D:\lamw\projects\AppGridColorPickerDemo1
jarsigner -verify -verbose -certs D:\lamw\projects\AppGridColorPickerDemo1\bin\AppGridColorPickerDemo1-release.apk
