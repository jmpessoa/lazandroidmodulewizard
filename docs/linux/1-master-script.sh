#!/bin/bash
# Original Author of this script: Renato Bordin
# you can find me on http://forum.lazarus.freepascal.org as renabor

# If you need to fix something and or want to contribute, send your 
# changes to renabor at iol dot it with "new_how_to_install_by_renabor"
# in the subject line.

BASE=bin/freepascal

################
# How to install LAMW on Linux.
################

if [ ! -d $HOME/$BASE ]; then
  mkdir $HOME/$BASE
  cp *.sh $HOME/$BASE
fi

################
# install some necessary programs:
################

#sudo apt-get install android-tools-adb ant openjdk-8-jdk subversion freeglut3 freeglut3-dev
#sudo apt-get install libgtk2-gladexml-perl libgtk2.0-bin libgtk2.0-cil libwxgtk3.0-0v5 
#sudo apt-get install libgtk2.0-dev libgdk-pixbuf2.0-dev libgpm-dev fakeroot libncurses5-dev libtinfo-dev

################
# initial setup
################

if [ ! -d $HOME/Android ]; then
  mkdir $HOME/Android
fi
cd $HOME/Android

################
# install Android NDK
################

# Download Android NDK from https://developer.android.com/ndk/downloads/index.html#download 
wget https://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip
unzip android-ndk-r11c-linux-x86_64.zip

# create a symbolic link for later use
if [ ! -L $HOME/Android/ndk ]; then
  ln -s $HOME/Android/android-ndk-r11c $HOME/Android/ndk
fi

################
# create symbolic link for linker
################

cd /usr/bin
if [ ! -L arm-linux-androideabi-as ]; then 
  sudo ln -s $HOME/Android/ndk/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-as arm-linux-androideabi-as
  sudo ln -s $HOME/Android/ndk/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ld.bfd arm-linux-androideabi-ld
  sudo ln -s /usr/bin/arm-linux-androideabi-as arm-linux-as
  sudo ln -s /usr/bin/arm-linux-androideabi-ld arm-linux-ld
fi

################
# create necessary symlinks under ~/$BASE in which we install fpc and lazarus
#
# The script rename /etc/fpc.cfg and replace it with a symlink !!!
#
################

source $HOME/$BASE/2-fpc-configure.sh
export PATH

################
# download fpc and lazarus source
################

~/$BASE/3-fpc-getsource.sh

################
# compile fpc, lazarus and many crosscompiler
################

~/$BASE/4-fpc-build-fixes_3.0.sh


################
# install Android Sdk
################

# Download Android Sdk from https://developer.android.com/sdk/index.html#Other (SDK Tools Only)
# and extract it 
cd $HOME/Android
wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
tar xzvf android-sdk_r24.4.1-linux.tgz

# create a symbolik link for later use
if [ ! -L $HOME/Android/sdk ]; then
  ln -s $HOME/Android/android-sdk-linux $HOME/Android/sdk
  ln -s $HOME/Android/android-sdk-linux $HOME/Android/Sdk
fi

################
# install SDK packages
################

# Follow these instructions
# https://developer.android.com/sdk/installing/adding-packages.html
# and install SDK packages

~/Android/sdk/tools/android sdk

################
# install LAMW
################

svn co https://github.com/jmpessoa/lazandroidmodulewizard.git
if [ ! -L $HOME/Android/lazandroidmodulewizard ]; then
  ln -s $HOME/Android/svn-lazandroidmodulewizard/trunk $HOME/Android/lazandroidmodulewizard
fi
# ( for further updating: cd $HOME/Android/svn-lazandroidmodulewizard/ && svn up )

################
# Install LAMW on Lazarus 
################

cat << EOF
1. From Lazarus IDE - Install Wizard Packages
  1.1 Package -> Open Package -> "tfpandroidbridge_pack.lpk"  [Android Components Bridges!]
     1.1.1 From Package Wizard
                                - Compile
                                - Use -> Install
  1.2 Package -> Open Package -> "lazandroidwizardpack.lpk"
     1.2.1 From Package Wizard
                                - Compile
                                - Use -> Install
  1.3 Package -> Open Package -> "amw_ide_tools.lpk"  [folder: ..\LazAndroidWizard\ide_tools]
     1.3.1 From Package Wizard
                                - Compile
                                - Use -> Install

2. From Lazarus IDE menu Tools -->> "Android Module Wizard" --> Paths Settings"
  update paths settings according to your system
(ref. https://jmpessoa.opendrive.com/files?Ml82Nzg4MzA1OF9yVVU3RA)

     -Path to Java JDK (ex. /usr/lib/jvm/java-7-openjdk-amd64)
     -Path to Android SDK( ex. $HOME/Android/sdk)
     -Path to Ant bin (ex. /usr/bin)
     -Select Ndk version: [10]
     -Path to Ndk (ex.  $HOME/Android/android-ndk-r11c)
     -Path to Java Resources  [Simonsayz's Controls.java,  *.xml and default Icons]: (ex. $HOME/Android/svn-lazandroidmodulewizard/trunk/java)

################
BUILD YOUR FIRST PROJECT
################

Open a project from lazandroidmodulewizard/demos/Ant or lazandroidmodulewizard/demos/Eclipse directory
open ~/Android/lazandroidmodulewizard/demos/Eclipse/AppDemo1/jni/controls.lpi
from Project->Options, change/modify paths according to your system (under «paths» and «other»)

(ex. for «paths» ../../../Android/android-ndk-r11c/platforms/android-21/arch-arm/usr/lib;$HOME/Android/android-ndk-r11c/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9/)

(ex. for «other» -Xd -CfSoft -CpARMV6 -XParm-linux-androideabi- -FD$HOME/Android/android-ndk-r11c/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin)

build it!

################
################
compile for ARM
################
################

from shell
(CMD) cd ~/Android/lazandroidmodulewizard/demos/Eclipse/AppDemo1

################
build.xml
################

<?xml version="1.0" encoding="UTF-8"?>
<project name="AppDemo1" default="help">
<property name="sdk.dir" location="$HOME/Android/sdk"/>
<property name="target"  value="android-19"/>
<property file="ant.properties"/>
<fail message="sdk.dir is missing." unless="sdk.dir"/>
<import file="${sdk.dir}/tools/ant/build.xml"/>
</project>

################
build.sh
################
edit build.sh and leave only this line:

   ant -Dtouchtest.enabled=true debug

################
install.sh
################

remove content of install.sh with:

$HOME/Android/sdk/platform-tools/adb uninstall com.example.appdemo1
$HOME/Android/sdk/platform-tools/adb install -r bin/AppDemo1-debug.apk
$HOME/Android/sdk/platform-tools/adb logcat

################
Connect a device
################

run an emulator
(CMD) ~/Android/sdk/tools/android avd &

################
COMPILE AND INSTALL
################

(CMD) chmod +x ./build.sh && chmod +x ./install.sh
(CMD) ./build.sh
(CMD) ./install.sh

Enjoy!
EOF

