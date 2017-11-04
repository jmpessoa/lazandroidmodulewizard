#!/bin/bash
# Original Author of this script: Renato Bordin
# you can find me on http://forum.lazarus.freepascal.org as renabor

# If you need to fix something and or want to contribute, send your 
# changes to renabor at iol dot it with "new_how_to_install_by_renabor"
# in the subject line.

BASE=~/bin/freepascal
FPC_STABLE=3.0.0
FPC_BUILD=3.0.1
FPC_TARGET=fpc_fixes_3_0
ANDROIDBASE=~/Android
NDK=android-ndk-r11c
ANDROID_BIN=$ANDROIDBASE/$NDK/toolchains/x86-4.9/prebuilt/linux-x86_64/bin
PPC_CONFIG_PATH=$BASE/fpc-bin                         
WIN32=""
WIN64=""
ARM=""
I386=""
LAZARUS=""
# Ask which crosscompiler do we need
while true; do
	echo -n "MAKE THE WINDOWS win32 CROSSCOMPILER? "
	read CHOICE
	echo
	if [ -z "$CHOICE" ]; then
		WIN32="Y"
	fi

	echo -n "MAKE THE WINDOWS win64 CROSSCOMPILER?"
	read CHOICE
	echo
	if [ -z "$CHOICE" ]; then
		WIN64="Y"
	fi

	echo -n "MAKE THE ANDROID ARM CROSSCOMPILER?"
	read CHOICE
	echo
	if [ -z "$CHOICE" ]; then
		ARM="Y"
	fi

	echo -n "MAKE THE ANDROID i386 CROSSCOMPILER?"
	read CHOICE
	echo
	if [ -z "$CHOICE" ]; then
		I386="Y"
	fi

	echo -n "BUILD LAZARUS?"
	read CHOICE
	echo
	if [ -z "$CHOICE" ]; then
		LAZARUS="Y"
	fi

	break
done
# Determine operating system architecture
CPU=$(uname -m)
if [ "$CPU" = "i686" ]; then
	CPU="i386"
fi

# MAKE FPC_STABLE THE DEFAULT FPC COMPILER 
$BASE/fpc-setver-$FPC_STABLE.sh

# Make the new compiler
cd $BASE/$FPC_TARGET
make distclean
make clean
fpcmake -T$CPU-linux
make all
make install INSTALL_PREFIX=$BASE/$FPC_TARGET

# UPDATE FPC_BUILD WITH REALLY INSTALLED FPC VERSION
FPLIB=`ls -td $BASE/$FPC_TARGET/lib/fpc/3*`
INSTVER="$(basename $FPLIB)"
if [[ ! $INSTVER == $FPC_BUILD ]]; then
  mv $BASE/fpc-setver-$FPC_BUILD.sh $BASE/fpc-setver-$INSTVER.sh
  sed -i "s/=$FPC_BUILD/=$INSTVER/g" $BASE/*.sh
  unlink $BASE/fpc-$FPC_BUILD
  ln -s $BASE/$FPC_TARGET $BASE/fpc-$INSTVER
  FPC_BUILD=$INSTVER
fi

cp $BASE/$FPC_TARGET/lib/fpc/$FPC_BUILD/ppc* $BASE/$FPC_TARGET/bin/.

# MAKE FPC_BUILD THE DEFAULT FPC COMPILER
$BASE/fpc-setver-$FPC_BUILD.sh

# RECOMPILE THE COMPILER
#cd $BASE/$FPC_TARGET/compiler
#make cycle
#cp $BASE/$FPC_TARGET/compiler/ppc

# WINDOWS win32 CROSSCOMPILER
if [[ $WIN32 -eq "Y" ]]; then
  fpcmake -Ti386-win32
  make crossinstall OS_TARGET=win32 CPU_TARGET=i386 INSTALL_PREFIX=$BASE/$FPC_TARGET
  cp $BASE/$FPC_TARGET/lib/fpc/$FPC_BUILD/ppcross386 $BASE/$FPC_TARGET/bin/fpc-cross-i386-win32
fi

# WINDOWS win64 CROSSCOMPILER
if [[ $WIN64 -eq "Y" ]]; then
  fpcmake -Tx86_64-win64
  make crossinstall OS_TARGET=win64 CPU_TARGET=x86_64 INSTALL_PREFIX=$BASE/$FPC_TARGET
  cp $BASE/$FPC_TARGET/lib/fpc/$FPC_BUILD/ppcrossx86 $BASE/$FPC_TARGET/bin/ppcrossx86
fi

# ANDROID ARM CROSSCOMPILER
if [[ $ARM -eq "Y" ]]; then
  fpcmake -Tarm-android
  make clean crossall OS_TARGET=android CPU_TARGET=arm
  make crossinstall OS_TARGET=android CPU_TARGET=arm CROSSOPT="-Cparmv7a -Cfvfpv3 -OpARMv7a -OoFastMath -O3 -XX -Xs -CX" CROSSBINDIR=$ANDROID_BIN BINUTILSPREFIX=arm-linux-androideabi- INSTALL_PREFIX=$BASE/$FPC_TARGET
  cp $BASE/$FPC_TARGET/lib/fpc/$FPC_BUILD/ppcrossarm $BASE/$FPC_TARGET/bin/ppcrossarm
fi

# ANDROID I386 CROSSCOMPILER
if [[ $I386 -eq "Y" ]]; then
  fpcmake -Ti386-android
  make clean crossall OS_TARGET=android CPU_TARGET=i386
  make crossinstall OS_TARGET=android CPU_TARGET=i386 CROSSOPT="-CpCoreI -CfSSE3 -OpCoreI -OoFastMath -O3 -XX -Xs -CX" CROSSBINDIR=$ANDROID_BIN BINUTILSPREFIX=i686-linux-android- INSTALL_PREFIX=$BASE/$FPC_TARGET
  cp $BASE/$FPC_TARGET/lib/fpc/$FPC_BUILD/ppcross386 $BASE/$FPC_TARGET/bin/fpc-cross-i386-android
  cp $BASE/$FPC_TARGET/lib/fpc/$FPC_BUILD/ppcross386 $BASE/$FPC_TARGET/bin/ppcross386
fi

# Make the new lazarus
if [[ $LAZARUS -eq "Y" ]]; then
  cd $BASE/lazarus
  make clean
  make all
fi

# Strip down the new programs
strip -S lazarus
strip -S lazbuild
strip -S startlazarus

