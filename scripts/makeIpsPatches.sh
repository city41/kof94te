#!/bin/bash -x

GAME='kof94'

rm -rf ipsBinaries
rm -rf ipsPatches

mkdir ipsBinaries
mkdir ipsBinaries/original
mkdir ipsPatches

yarn restore;
cp $MAME_ROM_DIR/${GAME}.zip ipsBinaries/original/
(cd ipsBinaries/original/ && unzip ${GAME}.zip)

buildPatch() {
    variant=$1

    echo "building variant: ${variant}"

    mkdir ipsPatches/${variant}
    mkdir ipsBinaries/hacked_${variant}

    yarn run-srom-crom-${variant}
    yarn ts-node src/patchRom/main.ts src/patches/kof94te_${variant}.json
    cp $MAME_ROM_DIR/$GAME.zip ipsBinaries/hacked_${variant}

    (cd ipsBinaries/hacked_${variant}/ && unzip ${GAME}.zip)

    for f in `ls ipsBinaries/original/ -I kof94.zip`; do
        bf=`basename $f`

        originalFile="ipsBinaries/original/${bf}"
        hackedFile="ipsBinaries/hacked_$variant/${bf}"

        originalSha=$(sha256sum "${originalFile}" | awk '{ print $1 }' )
        hackedSha=$(sha256sum "${hackedFile}" | awk '{ print $1 }' )

        echo "${bf} originalSha: ${originalSha}"
        echo "${bf} hackedSha: ${hackedSha}"

        if [ "${originalSha}" != "${hackedSha}" ]; then
            echo "Creating ${variant} ips for ${bf}"
            yarn ts-node src/tools/makeIpsPatch.ts ipsBinaries/original/${bf} ipsBinaries/hacked_${variant}/${bf} ipsPatches/${variant}/${GAME}_${variant}.${bf}.ips
        fi
    done

    (cd ipsPatches/${variant} && zip kof94teIpsPatches_${variant}.zip *.ips)
}

buildPatch a94
buildPatch a95