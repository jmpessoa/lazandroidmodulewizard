set JAVA_HOME=C:\Android\jdk1.8.0_201
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd c:\svn\apps\inapp5
keytool -genkey -v -keystore inapp5-release.keystore -alias inapp5.keyalias -keyalg RSA -keysize 2048 -validity 10000 < c:\svn\apps\inapp5\keytool_input.txt
