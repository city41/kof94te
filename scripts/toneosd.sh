#!/bin/bash

rm -rf toneosd
mkdir toneosd
cd toneosd
cp $MAME_ROM_DIR/kof94.zip .
unzip kof94.zip
neosdconv -i . -o ../kof94te.neo -y 2024 -n "The King of Fighters '94:TE hack" -g Fighting -m SNK_city41 -# 55