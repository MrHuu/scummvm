#!/bin/sh

## Setup environment
## ---------------------

export DEVKITPRO=/opt/devkitpro
export DEVKITARM=$DEVKITPRO/devkitARM
export CTRULIB=$DEVKITPRO/libctru
export PORTLIBS=$DEVKITPRO/portlibs/3ds

export PATH=$PORTLIBS/bin:$PATH
export PATH=$DEVKITARM/bin:$PATH
export PATH=$DEVKITPRO/tools/bin:$PATH

GAMEID=$1
GAMEDAT=NONE

rm -r ./romfs

mkdir -p ./pkg

if [ $# -eq 0 ] ; then
	GAMEID=NOTSET
fi

if [ $GAMEID = "ALL" ] ; then

	for GAMEID in BBDOU BBVS COMI DIG DUCKMAN DW DW2 FT HDB LSL1 MANIAC MONKEY MONKEY2 MYST NEVERHOOD PHANTASMAGORIA QFG4 QUEEN RIVEN SAMNMAX TENTACLE TOON
	do
		./build_custom_3ds.sh $GAMEID
	done
	exit

elif [ $GAMEID = "BBDOU" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=illusions

elif [ $GAMEID = "BBVS" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=bbvs

elif [ $GAMEID = "BLADERUNNER" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=bladerunner

elif [ $GAMEID = "COMI" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=scumm-7-8

elif [ $GAMEID = "DIG" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=scumm-7-8

elif [ $GAMEID = "DUCKMAN" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=illusions

elif [ $GAMEID = "DW" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=tinsel

elif [ $GAMEID = "DW2" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=tinsel

elif [ $GAMEID = "FT" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=scumm-7-8

elif [ $GAMEID = "HDB" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=hdb

elif [ $GAMEID = "LSL1" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=agi

elif [ $GAMEID = "MANIAC" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=scumm

elif [ $GAMEID = "MONKEY" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=scumm

elif [ $GAMEID = "MONKEY2" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=scumm

elif [ $GAMEID = "MYST" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=myst

elif [ $GAMEID = "NEVERHOOD" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=neverhood

	GAMEDAT=neverhood.dat

elif [ $GAMEID = "PERIL" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=pink

elif [ $GAMEID = "PHANTASMAGORIA" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=sci32

elif [ $GAMEID = "POKUS" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=pink

elif [ $GAMEID = "QFG4" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=sci32

elif [ $GAMEID = "QUEEN" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=queen

	GAMEDAT=queen.tbl

elif [ $GAMEID = "RIVEN" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=riven

elif [ $GAMEID = "SAMNMAX" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=scumm-7-8

elif [ $GAMEID = "TENTACLE" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=scumm

elif [ $GAMEID = "TOON" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=toon

	GAMEDAT=toon.dat

else

	echo
	echo -------------------------------------------------------------------------------------------
	echo Usage: ./build_custom_3ds.sh *Argument
	echo -------------------------------------------------------------------------------------------
	echo *ONLY single Arguments
	echo
	echo Arguments available: 
	echo  BBDOU BBVS BLADERUNNER COMI DIG DUCKMAN DW DW2 FT LSL1 MANIAC MONKEY MONKEY2 MYST
	echo  NEVERHOOD PERIL PHANTASMAGORIA POKUS QFG4 QUEEN RIVEN SAMNMAX TENTACLE TOON
	echo
	echo -------------------------------------------------------------------------------------------
	echo
	exit

fi

if [ $GAMEDAT = "NONE" ] ; then
	make .cia GAME=${GAMEID} || exit 1
else
	make .cia GAME=${GAMEID} GAMEDAT=${GAMEDAT} || exit 1
fi

mv -f ./${GAMEID}[ScummVM].cia ./pkg/${GAMEID}[ScummVM].cia

rm -f ./scummvm.elf
rm -f ./${GAMEID}[ScummVM].bnr
rm -f ./${GAMEID}[ScummVM].icn
rm -f ./${GAMEID}[ScummVM].smdh
