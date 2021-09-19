export PATH=/Install/android-sdk_r24.4.1-windows/android-sdk-windows/platform-tools:$PATH
export GRADLE_HOME=/Install/gradle-6.5-all/gradle-6.5/
export PATH=$PATH:$GRADLE_HOME/bin
source ~/.bashrc
gradle clean build --info
