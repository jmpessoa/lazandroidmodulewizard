export PATH=/lamw/android-sdk-windows/platform-tools:$PATH
export GRADLE_HOME=/fpcupdeluxe/ccr/lamw-gradle/gradle-6.8.3
export PATH=$PATH:$GRADLE_HOME/bin
source ~/.bashrc
gradlew build
