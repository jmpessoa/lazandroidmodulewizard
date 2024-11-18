export PATH=/Android/sdkJ21/platform-tools:$PATH
export GRADLE_HOME=/Android/gradle-8.9/
export PATH=$PATH:$GRADLE_HOME/bin
. ~/.bashrc
gradle clean bundle --info
