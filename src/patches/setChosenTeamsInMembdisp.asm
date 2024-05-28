;; setChosenTeamsInMembdisp
;;
;; called after character select is done and the game is moving onto order select
;; here we take the player's (and cpu's) choices and placed them into the membdisp
;; memory structures so that order select can work with them

;;; dont set member disp if in char select, it can cause
;;; sprite corruption with Changs, and it is not needed to boot
move.b $IN_CHAR_SELECT_FLAG, D7
bne done

move.l A4, D7
cmpi.l #$102900, D7
bne p1_skipChar0
move.b $P1_CHOSEN_CHAR0, D6
move.b D6, $71(A4)
bra done
p1_skipChar0:
cmpi.l #$102B00, D7
bne p1_skipChar1
move.b $P1_CHOSEN_CHAR1, D6
move.b D6, $71(A4)
bra done
p1_skipChar1:
cmpi.l #$102D00, D7
bne p1_skipChar2
move.b $P1_CHOSEN_CHAR2, D6
move.b D6, $71(A4)
bra done
p1_skipChar2:

;; p2 side
cmpi.l #$102F00, D7
bne p2_skipChar0
move.b $P2_CHOSEN_CHAR2, D6
move.b D6, $71(A4)
bra done
p2_skipChar0:
cmpi.l #$103100, D7
bne p2_skipChar1
move.b $P2_CHOSEN_CHAR1, D6
move.b D6, $71(A4)
bra done
p2_skipChar1:
cmpi.l #$103300, D7
bne done
move.b $P2_CHOSEN_CHAR0, D6
move.b D6, $71(A4)
bra done

done:
rts
