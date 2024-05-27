;; teamRandomSelect
;; randomly selects a team of 3 out of the 8 pre-formed teams


cmpi.b #3, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)
beq teamRandomSelect_done ; chose three characters? don't randomize then

;; throttle back the speed of random select
move.b $CHAR_SELECT_COUNTER, D4
andi.b #$3, D4
;; if there are any lower bits, bail
;; this means only random select every 4 frames
bne teamRandomSelect_done

teamRandomSelect_pickRandomTeam:
;; get a random number between 0-7
;; the game's rng uses A0
movem.l A0, $MOVEM_STORAGE
jsr $2582 ; call the game's rng, it leaves a random byte in D0
movem.l $MOVEM_STORAGE, A0
andi.b #$7, D0; chop the random byte down to 3 bits -> 0 through 7

;; now we have a random team ID in D0, load that team as the three characters
lea $534DC, A3 ; load the starting team->character list address
mulu.w #4, D0  ; multiply team id by 4, as there are 4 bytes per team (three characters and a ff delimiter)
adda.w D0, A3  ; move into the list to the correct team

;; now take the team and save them as the player's chosen characters (temporarily)

lea $PX_TEAM_RANDOM_TEMP_CHOSEN_CHARS_OFFSET(A0), A2
move.w #2, D4 ; loop 3 times using dbra

teamRandomSelect_saveTeamCharacter:
move.b (A3), (A2) ; save the member of the team as chosen
move.b $PX_RANDOM_SELECT_PALETTE_FLAG_CHOICE_OFFSET(A0), $1(A2)


adda.w #1, A3 ; move to the next character
adda.w #1, A2 ; move to the next save slot

dbra D4, teamRandomSelect_saveTeamCharacter

tst.b $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
; don't play the sfx during slot machine, as kof94 can only play one sfx at a time
bne teamRandomSelect_skipSoundEffect ; don't play the sfx during slot machine
move.b #$60, $320000  ; play the sound effect
teamRandomSelect_skipSoundEffect:


teamRandomSelect_done:
rts