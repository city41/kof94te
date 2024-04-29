;; randomSelect
;; called if a player's cursor is over random select
;; need to fill the chosen team section with random characters
cmpi.b #3, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)
beq randomSelect_done ; chose three characters? don't randomize then

;; throttle back the speed of random select
move.b $CHAR_SELECT_COUNTER, D4
andi.b #$3, D4
;; if there are any lower bits, bail
;; this means only random select every 4 frames
bne randomSelect_done

move.w #2, D4
sub.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D4 ; decrement D4 by number already chosen

move.w $PX_CHOSEN_TEAM_SPRITEINDEX_OFFSET(A0), D6 ; load si
add.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D6 ; move si forward to first unchosen character
add.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D6 ; twice since avatars are 2 sprites each

randomSelect_pickRandomChar:
;; get a random number between 0-23
;; the game's rng uses A0
movem.l A0, $MOVEM_STORAGE
jsr $2582 ; call the game's rng, it leaves a random byte in D0
movem.l $MOVEM_STORAGE, A0
andi.b #$1f, D0 ; chop the random byte down to 5 bits -> 0 through 31
cmpi.b #24, D0
bge randomSelect_pickRandomChar ;; it was too big, try again

cmpi.b #0, D4
bne randomSelect_checkFirst
;; this means D0 is destined for the third character
;; let's make sure char 0 and 1 aren't already this character
movea.l $PX_STARTING_CHOSE_CHAR_ADDRESS_OFFSET(A0), A2
cmp.b (A2), D0
beq randomSelect_pickRandomChar ; they already have this character, choose again
adda.w #2, A2
cmp.b (A2), D0
beq randomSelect_pickRandomChar ; they already have this character, choose again
randomSelect_checkFirst:
cmpi.b #1, D4
bne randomSelect_saveChar ; if D4 is 2, then this is the very first character, no checks needed
;; this makes D0 is destined for the second characterG
;; let's make sure char 0 isn't already this character
movea.l $PX_STARTING_CHOSE_CHAR_ADDRESS_OFFSET(A0), A2
cmp.b (A2), D0
beq randomSelect_pickRandomChar ; they already have this character, choose again


randomSelect_saveChar:
;; save the chosen id into CHOSEN_CHAR
movea.l $PX_STARTING_CHOSE_CHAR_ADDRESS_OFFSET(A0), A2
move.w #2, D5
sub.w D4, D5
adda.w D5, A2 ; add it twice since chosen chars are words
adda.w D5, A2 ; add it twice since chosen chars are words
move.b D0, (A2)

clr.w D7
move.b D0, D7 ; load up the random char id
;; parameters
;; D4.b - palette flag
;; D6.w - sprite index
;; D7.w - character id
;; TODO: this really should use the alternate palette flag by looking at the
;; other team, but punting on that for now
; move.b #0, D4
move.w D6, D3
jsr $2RENDER_CHOSEN_AVATAR
move.w D3, D6
tst.b $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
; don't play the sfx during slot machine, as kof94 can only play one sfx at a time
bne randomSelect_skipSoundEffect ; don't play the sfx during slot machine
move.b #$60, $320000  ; play the sound effect
randomSelect_skipSoundEffect:

addi.w #2, D6 ; move to next avatar
dbra D4, randomSelect_pickRandomChar

randomSelect_done:
rts