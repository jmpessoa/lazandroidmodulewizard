set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_101
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\Users\jmpessoa\workspace\AppCompatTabLayoutDemo2
keytool -genkey -v -keystore AppCompatTabLayoutDemo2-release.keystore -alias appcompattablayoutdemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\Users\jmpessoa\workspace\AppCompatTabLayoutDemo2\keytool_input.txt
