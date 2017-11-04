#!/bin/bash
# Original Author of this script: Renato Bordin
# you can find me on http://forum.lazarus.freepascal.org as renabor

# If you need to fix something and or want to contribute, send your 
# changes to renabor at iol dot it with "new_how_to_install_by_renabor"
# in the subject line.

# Change the line below to define your own install folder
green=$'\e[1;32m'
red=$'\e[1;31m'
end=$'\e[0m'

BASE=$HOME/bin/freepascal
FPC_STABLE=3.0.0
FPC_TARGET=fpc-3.0.0
PPC_CONFIG_PATH=$BASE/fpc-bin

unlink $BASE/fpc
ln -s $BASE/$FPC_TARGET $BASE/fpc

unlink $BASE/fpc-bin
ln -s $BASE/$FPC_TARGET/bin $BASE/fpc-bin

unlink $BASE/fpc.cfg
ln -s $PPC_CONFIG_PATH/fpc.cfg $BASE/fpc.cfg

# Generate a valid fpc.cfg file
$PPC_CONFIG_PATH/fpcmkcfg -d basepath=$BASE/fpc-$FPC_STABLE/lib/fpc/$FPC_STABLE -o $PPC_CONFIG_PATH/fpc.cfg

GCCPATH=`gcc --print-libgcc-file-name`
DIRGCCPATH=$(dirname "${GCCPATH}")
FPCGCCPATH=`grep -m1 \/usr\/lib\/gcc /etc/fpc.cfg`
echo $DIR
if [[ ! "FPCGCCPATH" == *"$DIRGCCPATH"* ]]; then
 echo "OK"
  printf "${green}fpc.fpg contains a valid gcc path\n"
  printf "$DIRGCCPATH${end}\n"
else
  printf "${red}fpc.fpg does not contains a valid gcc path\n"
  printf "should be : $DIRGCCPATH${red}\n"
fi
