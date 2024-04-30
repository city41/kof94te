;; randomSelect
;; called if a player's cursor is over random select
;; need to fill the chosen team section with random characters
cmpi.b #3, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)
beq charRandomSelect_done ; chose three characters? don't randomize then

;; throttle back the speed of random select
move.b $CHAR_SELECT_COUNTER, D4
andi.b #$3, D4
;; if there are any lower bits, bail
;; this means only random select every 4 frames
bne charRandomSelect_done

move.w #2, D4
sub.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D4 ; decrement D4 by number already chosen

charRandomSelect_pickRandomChar:
;; get a random number between 0-23
;; the game's rng uses A0
movem.l A0, $MOVEM_STORAGE
jsr $2582 ; call the game's rng, it leaves a random byte in D0
movem.l $MOVEM_STORAGE, A0
andi.b #$1f, D0 ; chop the random byte down to 5 bits -> 0 through 31
cmpi.b #24, D0
bge charRandomSelect_pickRandomChar ;; it was too big, try again

cmpi.b #0, D4
bne charRandomSelect_checkFirst
;; this means D0 is destined for the third character
;; let's make sure char 0 and 1 aren't already this character
movea.l $PX_STARTING_CHOSE_CHAR_ADDRESS_OFFSET(A0), A2
cmp.b (A2), D0
beq charRandomSelect_pickRandomChar ; they already have this character, choose again
adda.w #2, A2
cmp.b (A2), D0
beq charRandomSelect_pickRandomChar ; they already have this character, choose again
charRandomSelect_checkFirst:
cmpi.b #1, D4
bne charRandomSelect_saveChar ; if D4 is 2, then this is the very first character, no checks needed
;; this makes D0 is destined for the second characterG
;; let's make sure char 0 isn't already this character
movea.l $PX_STARTING_CHOSE_CHAR_ADDRESS_OFFSET(A0), A2
cmp.b (A2), D0
beq charRandomSelect_pickRandomChar ; they already have this character, choose again


charRandomSelect_saveChar:
;; save the chosen id into CHOSEN_CHAR
movea.l $PX_STARTING_CHOSE_CHAR_ADDRESS_OFFSET(A0), A2
move.w #2, D5
sub.w D4, D5
adda.w D5, A2 ; add it twice since chosen chars are words
adda.w D5, A2 ; add it twice since chosen chars are words
move.b D0, (A2)

tst.b $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
; don't play the sfx during slot machine, as kof94 can only play one sfx at a time
bne charRandomSelect_skipSoundEffect ; don't play the sfx during slot machine
move.b #$60, $320000  ; play the sound effect
charRandomSelect_skipSoundEffect:

dbra D4, charRandomSelect_pickRandomChar

charRandomSelect_done:
rts