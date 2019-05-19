export PATH=/Android/android-sdk/platform-tools:$PATH
export GRADLE_HOME=/Android/gradle-4.10/
export PATH=$PATH:$GRADLE_HOME/bin
source ~/.bashrc
gradlew run
