
;;;;;;;; Have the game use the chosen team ids instead of ones from a pre-formed team

;; need to use winning team list as game wants bytes, not words",
lea $WINNING_TEAM_LIST, A0
btst #0, $PLAY_MODE
beq setupPlayer2
move.b $P1_CHOSEN_CHAR0, (A0)
move.b $P1_CHOSEN_CHAR1, $1(A0)
move.b $P1_CHOSEN_CHAR2, $2(A0)
move.b #0, $108231
bra done
setupPlayer2:
move.b $P2_CHOSEN_CHAR2, (A0)
move.b $P2_CHOSEN_CHAR1, $1(A0)
move.b $P2_CHOSEN_CHAR0, $2(A0)
move.b #0, $108431
done:
;; set it up so the game pulls from our chosen team instead of a canned team
suba.l D0, A0

;; need to create the dynamic XY table based on the characters that will be displayed
lea $AFTER_SCREEN_POSITION_TABLE, A1 ; get our position table set up

;; team member 1, on the right side
clr.w D6
move.b (A0), D6 ; load the first team member id
add.w D6, D6    ; quadruple it for offsetting into the table
add.w D6, D6    ; quadruple it for offsetting into the table
lea $2CUTSCENE2_TABLES, A2
move.w (A2, D6.w), D7 ; jump into the table and grab the x word
move.w D7, (A1, D6.w) ; place the x word into our own dynamic table
addi.w #2, D6         ; move forward by two so we can get the y word
move.w (A2, D6.w), D7 ; jump into the table and grab the y word
move.w D7, (A1, D6.w) ; place the y word into our own dynamic table

;; team member 2, in the center
clr.w D6
move.b $1(A0), D6 ; load the second team member id
add.w D6, D6    ; quadruple it for offsetting into the table
add.w D6, D6    ; quadruple it for offsetting into the table
lea $2CUTSCENE2_TABLES, A2
adda.w #96, A2 ; jump forward to the center table, (24 characters, each with double word pair)
move.w (A2, D6.w), D7 ; jump into the table and grab the x word
move.w D7, (A1, D6.w) ; place the x word into our own dynamic table
addi.w #2, D6         ; move forward by two so we can get the y word
move.w (A2, D6.w), D7 ; jump into the table and grab the y word
move.w D7, (A1, D6.w) ; place the y word into our own dynamic table

;; team member 3, on the left side
clr.w D6
move.b $2(A0), D6 ; load the third team member id
add.w D6, D6    ; quadruple it for offsetting into the table
add.w D6, D6    ; quadruple it for offsetting into the table
lea $2CUTSCENE2_TABLES, A2
adda.w #192, A2 ; jump forward to the center table, (24 characters, each with double word pair, times two)
move.w (A2, D6.w), D7 ; jump into the table and grab the x word
move.w D7, (A1, D6.w) ; place the x word into our own dynamic table
addi.w #2, D6         ; move forward by two so we can get the y word
move.w (A2, D6.w), D7 ; jump into the table and grab the y word
move.w D7, (A1, D6.w) ; place the y word into our own dynamic table

rts