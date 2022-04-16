set Path=%PATH%;C:\android\sdkr25\platform-tools
set GRADLE_HOME=C:\android\gradle-6.6.1\
set PATH=%PATH%;%GRADLE_HOME%\bin
gradle clean bundle --info
