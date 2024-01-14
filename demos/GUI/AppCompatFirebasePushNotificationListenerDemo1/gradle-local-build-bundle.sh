export PATH=/android/sdkJ17/platform-tools:$PATH
export GRADLE_HOME=/android/gradle-8.1.1/
export PATH=$PATH:$GRADLE_HOME/bin
. ~/.bashrc
gradle clean bundle --info
