# Cross Continue

This is when one player loses and gets the continue screen, but then the other player continues. This is more common on AES as it's a way to extend the 4 credits to 8, but it's possible on MVS too.

## Detecting cross continue

scenario: p1 lost, p2 continued

A cross continue can be detected by
108238 is $80, indicating p1 lost
BIOS_PLAYER_MOD1 is 0, indicating p1 is not playing
BIOS_PLAYER_MOD2 is 1, indicating p2 is playing

and the opposite for the opposite scenario, but 108438 for loss detection

Is that enough to detect this situation 100% of the time?

## A fresh p1 game after hard reset

BIOS_PLAYER_MOD1: 1
BIOS_PLAYER_MOD2: 0
108238 (p1 lost): 0
108438 (p2 lost): 0

## A fresh p2 game after hard reset

BIOS_PLAYER_MOD1: 0
BIOS_PLAYER_MOD2: 1
108238 (p1 lost): 0
108438 (p2 lost): 0

## p1 continues after p1 loses

BIOS_PLAYER_MOD1: 1
BIOS_PLAYER_MOD2: 0
108238 (p1 lost): 80
108438 (p2 lost): 2

## p2 continues after p2 loses

BIOS_PLAYER_MOD1: 0
BIOS_PLAYER_MOD2: 1
108238 (p1 lost): 2
108438 (p2 lost): 80

## p1 challenges p2 during char select

BIOS_PLAYER_MOD1: 1
BIOS_PLAYER_MOD2: 1
108238 (p1 lost): 0
108438 (p2 lost): 0

# p1 wins a single player round and moves onto next

BIOS_PLAYER_MOD1: 1
BIOS_PLAYER_MOD2: 0
108238 (p1 lost): 2
108438 (p2 lost): 80

# p2 challenges p1 during a session, p2 loses, p1 keeps going single player

BIOS_PLAYER_MOD1: 1
BIOS_PLAYER_MOD2: 2
108238 (p1 lost): 2
108438 (p2 lost): 80

# p1 is about to face Rugal

BIOS_PLAYER_MOD1: 1
BIOS_PLAYER_MOD2: 0
108238 (p1 lost): 2
108438 (p2 lost): 80

# p2 challenges p1 during Rugal

BIOS_PLAYER_MOD1: 1
BIOS_PLAYER_MOD2: 2
108238 (p1 lost): 2
108438 (p2 lost): 0
