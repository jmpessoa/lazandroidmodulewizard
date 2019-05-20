set JAVA_HOME=C:\Android\jdk1.8.0_201
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\SVN\micrologus\Client\Apps\AppMidiManagerDemo1
keytool -genkey -v -keystore appmidimanagerdemo1-release.keystore -alias appmidimanagerdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < C:\SVN\micrologus\Client\Apps\AppMidiManagerDemo1\keytool_input.txt
