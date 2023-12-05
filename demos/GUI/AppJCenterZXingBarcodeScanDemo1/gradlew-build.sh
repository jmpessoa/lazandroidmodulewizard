export PATH=/android/sdkr25/platform-tools:$PATH
export GRADLE_HOME=/android/gradle-6.6.1
export PATH=$PATH:$GRADLE_HOME/bin
. ~/.bashrc
gradlew build
