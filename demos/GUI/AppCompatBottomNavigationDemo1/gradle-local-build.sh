export PATH=/Users/sotrafa/AppData/Local/Android/Sdk/platform-tools:$PATH
export GRADLE_HOME=/laztoapk/downloads/gradle-6.6.1/
export PATH=$PATH:$GRADLE_HOME/bin
source ~/.bashrc
gradle clean build --info
