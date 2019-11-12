export PATH=/Android_SDK_NDK/sdk-tools-windows/platform-tools:$PATH
export GRADLE_HOME=/FPC_Luxe/gradle-5.5.1/
export PATH=$PATH:$GRADLE_HOME/bin
source ~/.bashrc
gradle clean build --info
