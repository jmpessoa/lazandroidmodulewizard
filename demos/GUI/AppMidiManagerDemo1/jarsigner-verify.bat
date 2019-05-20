set JAVA_HOME=C:\Android\jdk1.8.0_201
path %JAVA_HOME%\bin;%path%
cd C:\SVN\micrologus\Client\Apps\AppMidiManagerDemo1
jarsigner -verify -verbose -certs C:\SVN\micrologus\Client\Apps\AppMidiManagerDemo1\bin\AppMidiManagerDemo1-release.apk
