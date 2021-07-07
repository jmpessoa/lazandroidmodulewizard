export PATH=/Users/artem.bogomolov.a/develop/instruments/ObjectPascal/lamw_manager/LAMW/sdk/platform-tools:$PATH
export GRADLE_HOME=/Users/artem.bogomolov.a/develop/instruments/ObjectPascal/fpcdeluxe/ccr/lamw-gradle/gradle-6.8.3/
export PATH=$PATH:$GRADLE_HOME/bin
source ~/.bashrc
gradle clean build --info
