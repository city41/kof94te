#!/bin/bash

GAME='kof94'

rm -rf ipsBinaries
rm -rf ipsPatches

mkdir ipsPatches
mkdir ipsBinaries
mkdir ipsBinaries/original
mkdir ipsBinaries/hacked

yarn restore;
cp $MAME_ROM_DIR/$GAME.zip ipsBinaries/original/

yarn ts-node src/patchRom/main.ts src/patches/newCharSelect.json
cp $MAME_ROM_DIR/$GAME.zip ipsBinaries/hacked/

(cd ipsBinaries/original/ && unzip $GAME.zip)
(cd ipsBinaries/hacked/ && unzip $GAME.zip)

# PROM='055-p1.p1'
# SROM='055-s1.s1'
# CROM1='055-c1.c1'
# CROM2='055-c2.c2'

for f in ipsBinaries/original/*; do
    bf=`basename $f`
    yarn ts-node src/tools/makeIpsPatch.ts ipsBinaries/original/$bf ipsBinaries/hacked/$bf ipsPatches/$GAME.$bf.ips
done

(cd ipsPatches && zip kof94teIpsPatches.zip *.ips)