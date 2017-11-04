#!/bin/bash
# Original Author of this script: Renato Bordin
# you can find me on http://forum.lazarus.freepascal.org as renabor

# If you need to fix something and or want to contribute, send your 
# changes to renabor at iol dot it with "new_how_to_install_by_renabor"
# in the subject line.


BASE=$HOME/bin/freepascal
FPC_TARGET=fpc_fixes_3_0
FPC_BUILD=3.0.3
NDK_TARGET=4.9

FPC_BIN=fpc-bin
PPC_CONFIG_PATH=$BASE/fpc-bin

if [[ ! ":$PATH:" == *":$PPC_CONFIG_PATH:"* ]]; then
  echo export PATH=$PATH:$PPC_CONFIG_PATH:~/Android/ndk/toolchains/arm-linux-androideabi-$NDK_TARGET/prebuilt/linux-x86_64/bin >> ~/.bashrc
  export PATH=$PATH:$PPC_CONFIG_PATH:~/Android/ndk/toolchains/arm-linux-androideabi-$NDK_TARGET/prebuilt/linux-x86_64/bin
  echo export ANDROID_HOME=$HOME/Android/sdk >> ~/.bashrc
fi

if [ ! -L /etc/fpc.cfg ]; then
  sudo cp /etc/fpc.cfg /etc/fpc.cfg.bak
  sudo rm /etc/fpc.cfg
  sudo ln -s $BASE/fpc.cfg /etc/fpc.cfg
fi

if [ ! -L $BASE/fpc.cfg ]; then
  ln -s $PPC_CONFIG_PATH/fpc.cfg $BASE/fpc.cfg
fi

if [ ! -L $BASE/fpc-$FPC_BUILD ]; then
  ln -s $BASE/$FPC_TARGET $BASE/fpc-$FPC_BUILD
fi

if [ ! -L $BASE/$FPC_BIN ]; then
  ln -s $BASE/$FPC_TARGET/bin $BASE/$FPC_BIN
fi

if [ ! -L $BASE/fpc ]; then
  ln -s $BASE/$FPC_TARGET $BASE/fpc
fi

if [ ! -d $BASE/$FPC_TARGET ]; then
  mkdir $BASE/$FPC_TARGET
fi 

if [ ! -d $BASE/lazarus ]; then
  mkdir $BASE/lazarus
fi 

if [ ! -L /usr/bin/arm-linux-androideabi-as ]; then
  ln -s $HOME/Android/ndk/toolchains/arm-linux-androideabi-$NDK_TARGET/prebuilt/linux-x86_64/bin/arm-linux-androideabi-as /usr/bin/arm-linux-androideabi-as
fi
if [ ! -L /usr/bin/arm-linux-androideabi-ld ]; then
  ln -s $HOME/Android/ndk/toolchains/arm-linux-androideabi-$NDK_TARGET/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ld.bfd /usr/bin/arm-linux-androideabi-ld
fi
if [ ! -L /usr/bin/arm-linux-as ]; then
  ln -s /usr/bin/arm-linux-androideabi-as /usr/bin/arm-linux-as
fi

if [ ! -L /usr/bin/arm-linux-ld ]; then
  ln -s /usr/bin/arm-linux-androideabi-ld /usr/bin/arm-linux-ld
fi


