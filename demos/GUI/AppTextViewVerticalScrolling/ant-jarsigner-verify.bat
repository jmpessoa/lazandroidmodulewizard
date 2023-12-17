set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.21.9
path %JAVA_HOME%\bin;%path%
cd C:\android\workspace\AppTextViewVerticalScrolling
jarsigner -verify -verbose -certs C:\android\workspace\AppTextViewVerticalScrolling\bin\AppTextViewVerticalScrolling-release.apk
