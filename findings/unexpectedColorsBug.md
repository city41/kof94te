# Unexpected Colors Bug

## Repro

Set game to single play

Choose default team Italy with D

Joe will be alt color in order select

Choose Joe as the fighter

once match starts, Joe is no longer alternate

now lose round, next round he is alternate

## Order select, Joe's A3 and A2

In the order select case
A3: 79d42
A2: 109c28

before the bra at 330a
PC 00330A
SR 2000
SP 0010F2EC
USP 00000000
SSP 0010F2EC
D0 00000046
D1 0000056A
D2 00000010
D3 0000000D
D4 0000FFFF
D5 00000000
D6 00000000
D7 0000FFFF
A0 000033D2
A1 00108205
A2 0010C7CA
A3 0010C88A
A4 00108100
A5 00108000
A6 0010B9CA
A7 0010F2EC
IR 00000642
PREF_ADDR 00330A
PREF_DATA 00006000

## Start of match: Joe's A3 and A2

in this particular case he was correctly alternate

A3: 79d42
A2: 1088a8

## Second round: Joe's A3 and A2
