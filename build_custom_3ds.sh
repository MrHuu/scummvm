#!/bin/sh

## Setup environment
## ---------------------

export DEVKITPRO=/opt/devkitpro
export DEVKITARM=$DEVKITPRO/devkitARM
export CTRULIB=$DEVKITPRO/libctru

export PATH=$DEVKITARM/bin:$PATH
export PATH=$DEVKITPRO/tools/bin:$PATH
export PORTLIBS=$DEVKITPRO/portlibs/3ds


## ScummVM doesn't provide the CA certificates bundle required by the cloud synchronization features.
## https://github.com/scummvm/scummvm/blob/036d61cbd62dc7907f4eeb36764bef9f794588f4/backends/platform/3ds/README.md#42-compiling-scummvm
## ---------------------
FILE=./backends/platform/3ds/app/cacert.pem
if [ ! -f "$FILE" ]; then
	echo "$FILE does not exist"
	wget -O "./backends/platform/3ds/app/cacert.pem" https://curl.haxx.se/ca/cacert.pem
fi
export DIST_3DS_EXTRA_FILES=./backends/platform/3ds/app/cacert.pem
## ---------------------


GAMEID=$1
GAMEDAT=NONE

rm -r ./romfs

mkdir -p ./pkg

if [ $# -eq 0 ] ; then
	GAMEID=NOTSET
fi

if [ $GAMEID = "ALL" ] ; then

	for GAMEID in BBDOU BBVS COMI DIG DW DW2 FT HDB LSL1 MANIAC MONKEY MONKEY2 MYST NEVERHOOD PHANTASMAGORIA QFG4 QUEEN RIVEN SAMNMAX TENTACLE TOON
	do
		./build_custom_3ds.sh $GAMEID
	done
	exit

elif [ $GAMEID = "BBDOU" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=illusions

elif [ $GAMEID = "BBVS" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=bbvs

elif [ $GAMEID = "COMI" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=scumm-7-8

elif [ $GAMEID = "DIG" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=scumm-7-8

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

elif [ $GAMEID = "PHANTASMAGORIA" ] ; then

	./configure --host=3ds --disable-all-engines --enable-engine=sci32

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
	echo  BBDOU BBVS COMI DIG DW DW2 FT LSL1 MANIAC MONKEY MONKEY2 MYST NEVERHOOD PHANTASMAGORIA QFG4
	echo  QUEEN RIVEN SAMNMAX TENTACLE TOON
	echo
	echo Engines available:
	echo agi,agos,agos2,cruise,gob,hugo,kyra,lure,myst,riven,queen,saga,ihnm,scumm,scumm-7-8,he,sci,sci32,
	echo sherlock,sky,sword1,sword2,sword25,teenagent,tinsel,toon,touche,zvision
	echo access,adl,bbvs,cge,cge2,cine,composer,draci,drascula,dreamweb,fullpipe,gnap,groovie,hopkins,
	echo illusions,lol,eob,lab,made,mads,mohawk,mortevielle,neverhood,parallaction,pegasus,plumbers,
	echo titanic,toltecs,tony,tsage,tucker,voyeur,wintermute,xeen
	echo
	echo Unstable:
	echo avalanche,bladerunner,chewy,cryo,director,dm,groovie2,lastexpress,lilliput,macventure,cstime,
	echo mutationofjb,pink,prince,sludge,startrek,supernova,testbed,wage
	echo -------------------------------------------------------------------------------------------
	echo Current:
	echo [ENGINE] ALL - does not initially save scummmvm.ini
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
