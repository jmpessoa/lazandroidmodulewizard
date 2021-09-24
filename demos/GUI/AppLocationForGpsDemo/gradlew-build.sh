export PATH=/lamw_manager/LAMW/sdk/platform-tools:$PATH
export GRADLE_HOME=/lamw_manager/LAMW/gradle-4.4.1
export PATH=$PATH:$GRADLE_HOME/bin
source ~/.bashrc
gradlew build
