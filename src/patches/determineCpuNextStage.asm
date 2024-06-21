;; determineCpuNextStage
;; gets a fresh stage from getCpuStage,
;; then set's the cpu's team id to that value
;; this ensures in single player games, all 8 stages (ie teams)
;; are visited, which is a requirement for getting to Rugal
bsr getCpuStage ; the chosen team id is left in D0
btst #0, $PLAY_MODE ; is player one human?
beq setP1CpuStage
;; player one is human, so set the team ID on player 2 
move.b D0, $108431
bra done
setP1CpuStage:
;; player one is not human, so set the team ID there
move.b D0, $108231

done:
rts


;;;;; SUBROUTINES ;;;;;;;

;; getCpuStage
;; chooses the next stage to fight on, making sure it's a stage
;; that hasn't been fought on.
;;
;; parameters: none
;; returns: D0.b: chosen team id
getCpuStage:
;; get a random number between 0-7
;; the game's rng uses A0
movem.l A0, $MOVEM_STORAGE
jsr $2582 ; call the game's rng, it leaves a random byte in D0
movem.l $MOVEM_STORAGE, A0
andi.b #$7, D0; chop the random byte down to 3 bits -> 0 through 7
btst D0, $DEFEATED_TEAMS
bne getCpuStage ; already beat this team? try again
rts