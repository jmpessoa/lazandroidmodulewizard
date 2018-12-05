export PATH=/adt32/sdk/platform-tools:$PATH
export GRADLE_HOME=/adt32/gradle-4.2.1
export PATH=$PATH:$GRADLE_HOME/bin
source ~/.bashrc
./gradlew build
