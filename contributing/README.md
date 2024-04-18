# Contributing

So far I'm the only one working on this, and the repo shows that. It's a mess and probably has a lot of stuff on it that only works on my setup. If you are interested in contributing, [let me know](https://github.com/city41/kof94te/discussions) and I'll prioritize making this better.

## Pre-reqs

### OS

I am using Linux. I would guess getting this all working on Windows might be tough, but I don't really know. MacOS is probably somewhere in between.

### Node

A recent version of Node, I am using 18.18.2. It can be installed from https://nodejs.org or via something like [nvm](https://github.com/nvm-sh/nvm)

#### Yarn

Install yarn with `npm install -g yarn`. I am using 1.22.21. Yarn 2 and Yarn 3 will likely not work. npm might though.

#### Install Deps

run `yarn install`

run `yarn run-srom-crom` as a test. You should see output like this

```bash
$ yarn run-srom-crom
yarn run v1.22.21
$ NODE_OPTIONS='--loader ts-node/esm' yarn sromcrom -i resources/resources.json
(node:444426) ExperimentalWarning: Custom ESM Loaders is an experimental feature and might change at any time
(Use `node --trace-warnings ...` to show where the warning was created)
$ /home/matt/dev/kof94te/node_modules/.bin/sromcrom -i resources/resources.json
(node:444438) ExperimentalWarning: Custom ESM Loaders is an experimental feature and might change at any time
(Use `node --trace-warnings ...` to show where the warning was created)
{ startingPaletteIndex: 16 }
wrote /home/matt/dev/kof94te/resources/newtiles-c1.c1
wrote /home/matt/dev/kof94te/resources/newtiles-c2.c2
wrote /home/matt/dev/kof94te/resources/newtiles-s1.s1
wrote /home/matt/dev/kof94te/src/patches/palettes.asm
wrote /home/matt/dev/kof94te/src/patches/character_grid.asm
wrote /home/matt/dev/kof94te/src/patches/team_to_grey_out_table.asm
wrote /home/matt/dev/kof94te/src/patches/rugal_character_grid.asm
wrote /home/matt/dev/kof94te/src/patches/avatars.asm
wrote /home/matt/dev/kof94te/src/patches/p1_cursor.asm
wrote /home/matt/dev/kof94te/src/patches/p2_cursor.asm
wrote /home/matt/dev/kof94te/src/patches/cpu_cursor_left.asm
wrote /home/matt/dev/kof94te/src/patches/cpu_cursor_right.asm
Done in 1.73s.
```

If you do, that's a good sign node is setup correctly.

### Clown Assembler

It is in the repo at `clownassembler/`. Head in there and run `make`. If all goes well, you should get a binary at `clownassembler/clownassembler`. If you run it, you should see:

```bash
$ clownassembler/clownassembler
clownassembler: an assembler for the Motorola 68000.

Options:
 -i [path] - Input file. If not specified, STDIN is used instead.
 -o [path] - Output file.
 -l [path] - Listing file. Optional.
 -s [path] - asm68k-style symbol file. Optional.
 -c        - Enable case-insensitive mode.
 -b        - Enable Bison's debug output.
 -d        - Allow EQU/SET to descope local labels
```

### A KOF94 ROM

Copy kof94.zip from a MAME set into the root of the repo. This file is in the gitignore so it won't get checked in. It should be a vanilla kof94.zip and will remain vanilla.

### MAME

Set up the environment variable `MAME_ROM_DIR`. It should be the path to your MAME rom directory. Here is mine

```bash
$ env | grep MAME_ROM_DIR
MAME_ROM_DIR=/home/matt/mame/roms
```

You need MAME installed such that it works on the command line, if `yarn mame` starts MAME with KOF94 running, you're all set.

Whenever you create a patch (more below), your kof94.zip in your MAME directory will get overwritten with the patched version. You can do `yarn restore` to put the vanilla version back.

## Building a patched KOF94

First do `yarn run-srom-crom`. All patches need the files created by sromcrom, even though only the main patch cares about them.

Then, as a test, try

```bash
yarn ts-node src/patchRom/main.ts src/patches/forceKyoInMembDisp.json
```

It will spit out a bit of output and should end with

```bash
wrote patched rom to /home/matt/mame/roms/kof94.zip
Done in 4.81s.
```

The path will be based on your `MAME_ROM_DIR` env variable.

From there, `yarn mame` then go into team select and you should see

![six Kyos in team select](https://github.com/city41/kof94te/blob/main/contributing/sixKyos.png?raw=true)

If you do, great, you can build patches successfully. See below on how to build the main patch, it is more involved.

## The repo

There's a ton of stuff in here, mostly from me reverse engineering the game. The vast majority of it can be ignored and I'll ultimately clean it up.

### src/lua

These are MAME Lua scripts. Can be ran with `yarn mame -autoboot_script src/lua/<script>.lua`

For example `yarn mame -autoboot_script src/lua/forceTeamOfTriplets.lua`, then start a match. Once in the fight, all six characters will be King.o

Lua scripts don't alter the ROM.

### src/tools

These are random typescript scripts that do many various things. Mostly used to explore reverse engineering the game. But some are also part of building the main patch such as `buildWinScreenTables.ts`

### src/patches

These are patches that can be applied to the game. `newCharSelect.json` is the main patch. Any json file in this directory is a patch that can be applied with `yarn ts-node src/patchRom/main.ts src/patches/<patch>.json`. All `.asm` files in this directory are used by patches. If you look inside `newCharSelect.json` you will see the assembly is sometimes right in the json file as string array, and sometimes external to the file in an `.asm` file.

### findings

This directory has Markdown files of discoveries on how the game works. They are a total mishmash of stuff, no organization, all over the place. This info should be organized into the wiki here.

### resources

This is where the new graphics used by the patch are stored, such as `character_grid.png`.

![kof94te char select](https://github.com/city41/kof94te/blob/main/resources/character_grid.png?raw=true)

They are built using [sromcrom](https://github.com/city41/sromcrom), driven by `resources/resources.json`.

## Building the main patch

The main patch involves several steps to get fully built.

WARNING: these steps might be out of date as I will probably forget to update them.

You will need an unzipped vanilla ROM somewhere.

1. `yarn ts-node src/tools/buildWinScreenTables.ts <dir with unzipped vanilla ROM>/055-p1.p1`
2. `yarn ts-node src/tools/buildCutscene2Tables.ts <dir with unzipped vanilla ROM>/055-p1.p1`
3. `yarn run-srom-crom`
4. `yrn ts-node src/patchRom/main.ts src/patches/newCharSelect.json`

Unfortunately if clownassembler encounters an error, it does not return a non-zero exit code. So the only way to know if something went wrong is examine the output. I search my terminal for "error". I need to fix this.

## Building the IPS patch files

`scripts/makeIpsPatches.sh` will do this. It will first build the main patch so you need to do the first three steps above first.

It will dump the ips files in `ipsPatches/`.

Currently it creates an ips file for all ROMS. But really the only files that get patched are the PROM, the C1/C2 ROMs and maybe the C7/C8 ROMS. This should be changed but works for now.

You can then apply the ips patches to a vanilla ROM using an ips patch program. It's easier to just let https://neorh.mattgreer.dev do it for you though.
