export PATH=/android/sdk/platform-tools:$PATH
export GRADLE_HOME=/android/gradle-5.4.1
export PATH=$PATH:$GRADLE_HOME/bin
source ~/.bashrc
gradlew run
