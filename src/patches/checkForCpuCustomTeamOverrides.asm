;; called just as the player presses start
;; to start a new game
;; here we will see if they held down C or D
;; and apply cpu custom team overrides accordingly.
;; if an override does get applied, the game pauses for a bit to say "Go Red!"

;; restore what was clobbered
jsr $15a0

;; clear any previous override, they do to do this everytime they play the game
move.b #0, $OVERRODE_CPU_CSTM_FLAG
move.b #0, $CPU_CUSTOM_TEAMS_FLAG

cmpi.b #1, $BIOS_PLAYER_MOD1 ; is player 1 playing?
bne skipPlayer1
move.b $BIOS_P1CURRENT, D1
bra checkForOverrides
skipPlayer1:
move.b $BIOS_P2CURRENT, D1

checkForOverrides:
btst #6, D1 ; is C pressed?
bne doForceCustomOverride
btst #7, D1 ; is D pressed?
bne doForceOriginal8Override
bra doneWithOverride ; neither is pressed, no override

doForceCustomOverride:
btst #7, D1 ; is D also pressed?
bne doneWithOverride    ; it is? then player is giving mixed signals, default to doing nothing
move.b #1, $CPU_CUSTOM_TEAMS_FLAG ; force custom teams
move.b #1, $OVERRODE_CPU_CSTM_FLAG ; and note it was overridden so nothing else touches it
bra doneWithOverride

doForceOriginal8Override:
btst #6, D1 ; is C also pressed?
bne doneWithOverride    ; it is? then player is giving mixed signals, default to doing nothing
move.b #0, $CPU_CUSTOM_TEAMS_FLAG
move.b #1, $OVERRODE_CPU_CSTM_FLAG ; and note it was overridden so nothing else touches it
bra doneWithOverride

doneWithOverride:
cmpi.b #1, $OVERRODE_CPU_CSTM_FLAG
bne done

;; play "Go red!" as confirmation
move.b #7, $320000
move.b #$50, $320000 ;; go red!
bsr waitABit

done:
rts



;;;;;;;;;;; SUBROUTINES ;;;;;;;;;;;;;;;;;

waitABit:
move.w #$efff, D2
waitCycle:
move.w #11, D3
waitNop:
nop
dbra D3, waitNop
move.b #1, $300001 ; watchdog
dbra D2, waitCycle
rts
