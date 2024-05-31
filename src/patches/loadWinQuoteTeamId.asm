;; loadWinQuoteTeamId
;;
;; Normally the game bases the win quote on 
;; - the winning character Id (say Terry)
;; - the losing team id (say Mexico)
;;
;; so for example, Terry always says the same thing to Mexico (LET'S DO IT AGAIN SOMETIME!)
;;
;; in the hack, the losing team ID is almost always nonsense, so this hook has the game
;; load a losing team ID based on the character that lost the fight, example Kim -> Korea

;; nothing to restore on the clobber
;; need to leave the loaded team ID in D1

movem.l D2/A2, $MOVEM_STORAGE

clr.w D2
cmpi.b #$80, $108238 ; did player one lose?
bne player2Lost
;; player one lost
move.b $108171, D2 ; load the losing character's id
bra doneLoadingLosingCharId

player2Lost:
move.b $108371, D2 ; load the losing character's id

doneLoadingLosingCharId:
lea $2CHARID_TO_TEAMID, A2
adda.w D2, A2  ; index into the table
moveq #0, D1
move.b (A2), D1 ; load the losing character's team id into D1, where the game expects it


movem.l $MOVEM_STORAGE, D2/A2
rts