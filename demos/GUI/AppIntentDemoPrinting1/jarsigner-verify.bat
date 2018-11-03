set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
path %JAVA_HOME%\bin;%path%
cd C:\lamw\workspace\AppIntentDemoPrinting1
jarsigner -verify -verbose -certs C:\lamw\workspace\AppIntentDemoPrinting1\bin\AppIntentDemoPrinting1-release.apk
