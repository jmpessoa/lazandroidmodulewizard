set Path=%PATH%;C:\android\sdkJ11\platform-tools
set GRADLE_HOME=C:\android\gradle-7.6.3\
set PATH=%PATH%;%GRADLE_HOME%\bin
gradle clean bundle --info
