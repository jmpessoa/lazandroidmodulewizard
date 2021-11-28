export PATH=/sdk/platform-tools:$PATH
export GRADLE_HOME=/gradle-6.9
export PATH=$PATH:$GRADLE_HOME/bin
source ~/.bashrc
gradlew build
