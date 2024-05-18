;; setOriginalTeamId
;;
;; given a chosen team of characters, determines 
;; if they make up one of the 8 original teams.
;; If so, that teamId is written to PX_ORIGINAL_TEAM_ID
;; If not, $ff is written to PX_ORIGINAL_TEAM_ID
;;
;; parameters
;; A0: base pointer for p1 or p2 data
movem.l D0-D3/A2, $MOVEM_STORAGE
movea.l $PX_STARTING_CHOSE_CHAR_ADDRESS_OFFSET(A0), A2

; pull the team's character ids into registers
clr.l D0
move.b (A2), D0
move.b $2(A2), D1
move.b $4(A2), D2

cmp.b D0, D1
bge check2
bsr swapD0D1
check2:
cmp.b D0, D2
bge check3
bsr swapD0D2
check3:
cmp.b D1, D2
bge sorted
bsr swapD1D2
sorted:

;; is character 1 a team leader
cmpi.b #$0, D0 ; Heidern
beq char1IsLeader
cmpi.b #$3, D0 ; Athena
beq char1IsLeader
cmpi.b #$6, D0 ; Kyo
beq char1IsLeader
cmpi.b #$9, D0 ; Heavy
beq char1IsLeader
cmpi.b #$c, D0 ; Kim
beq char1IsLeader
cmpi.b #$f, D0 ; Terry
beq char1IsLeader
cmpi.b #$12, D0 ; Ryo
beq char1IsLeader
cmpi.b #$15, D0 ; Yuri
beq char1IsLeader
bra notAnOriginalTeam


char1IsLeader:
;; is character 2's ID just one more than character 1's?
move.b D1, D3
sub.b D0, D1 
cmpi.b #1, D1
bne notAnOriginalTeam
move.b D3, D1

;; is character 3's ID just one more than character 2's?
sub.b D1, D2
cmpi.b #1, D2
bne notAnOriginalTeam

;; this is an original team, write the team ID out
;; from team leader id to team id is just division by 3
divu.w #3, D0
move.b D0, $PX_ORIGINAL_TEAM_ID_OFFSET(A0)
bra done

notAnOriginalTeam:
move.b #$ff, $PX_ORIGINAL_TEAM_ID_OFFSET(A0)


done:
movem.l $MOVEM_STORAGE, D0-D3/A2
rts



;;; SUBROUTINES


swapD0D1:
move.b D0, D3
move.b D1, D0
move.b D3, D1
rts

swapD0D2:
move.b D0, D3
move.b D2, D0
move.b D3, D2
rts

swapD1D2:
move.b D1, D3
move.b D2, D1
move.b D3, D2
rts







