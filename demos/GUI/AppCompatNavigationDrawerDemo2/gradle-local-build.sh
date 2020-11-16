export PATH=/android/sdk/platform-tools:$PATH
export GRADLE_HOME=/android/gradle-6.6.1/
export PATH=$PATH:$GRADLE_HOME/bin
source ~/.bashrc
gradle clean build --info
