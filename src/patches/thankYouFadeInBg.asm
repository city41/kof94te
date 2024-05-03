;thankYouFadeInBg
;fills in from the left and right for a simple fade in effect
; left starting address: 7084
; right starting address: 7464

;; throttle how fast this happens
addi.b #1, $CHAR_SELECT_COUNTER
cmpi.b #4, $CHAR_SELECT_COUNTER
ble done
move.b #0, $CHAR_SELECT_COUNTER

lea $2THANK_YOU_MESSAGE_TABLE, A0

;; get the column starting addresses based on how many columns we have rendered
move.w $THANK_YOU_FADEIN_BG_COUNT, D0
mulu.w #32, D0
move.w #$7084, D1
add.w D0, D1 ; left column
move.w #$7464, D2
sub.w D0, D2 ; right column

;; now render these two columns, either as black or as the message
;; depending on if we have crossed the halfway point or not
move.w #25, D3
renderTwoTiles:
move.w D1, $3C0000

cmpi.w #15, $THANK_YOU_FADEIN_BG_COUNT
ble useBlackLeft
;; load the message tile here
move.w #$7000, D4
move.w D1, D5
sub.w D4, D5 ; now D5 is a good offset into the table
clr.w D4
move.b (A0, D5), D4 ; load the message tile into D4

move.w D4, $3C0002 ; and then into vram
bra doneSettingLeftTile
useBlackLeft:
move.w #$20, $3C0002
doneSettingLeftTile:

move.w D2, $3C0000
cmpi.w #15, $THANK_YOU_FADEIN_BG_COUNT
ble useBlackRight
;; load the message tile here
move.w #$7000, D4
move.w D2, D5
sub.w D4, D5 ; now D5 is a good offset into the table
clr.w D4
move.b (A0, D5), D4 ; load the message tile into D4

move.w D4, $3C0002 ; and then into vram
bra doneSettingRightTile
useBlackRight:
move.w #$20, $3C0002
doneSettingRightTile:

move.w #$20, $3C0002

addi.w #1, D1
addi.w #1, D2

dbra D3, renderTwoTiles


;; then move in one column, and render this column checkerboard
;; or white, depending on if halfway point has been reached or not
addi.w #1, $THANK_YOU_FADEIN_BG_COUNT
move.w $THANK_YOU_FADEIN_BG_COUNT, D0

mulu.w #32, D0
move.w #$7084, D1
add.w D0, D1 ; left column
move.w #$7464, D2
sub.w D0, D2 ; right column

move.w #25, D3
checkerBoardRenderTwoTiles:
move.w D1, $3C0000
cmpi.w #15, $THANK_YOU_FADEIN_BG_COUNT
ble useCheckerboardLeft
;; use a grey square
move.w #$f03, $3C0002
bra doneSettingCheckerboardLeft

useCheckerboardLeft:
move.w #$f80, $3C0002
doneSettingCheckerboardLeft:

move.w D2, $3C0000
cmpi.w #15, $THANK_YOU_FADEIN_BG_COUNT
ble useCheckerboardRight
;; use a grey square
move.w #$f03, $3C0002
bra doneSettingCheckerboardRight

useCheckerboardRight:
move.w #$f80, $3C0002
doneSettingCheckerboardRight:

addi.w #1, D1
addi.w #1, D2

dbra D3, checkerBoardRenderTwoTiles

done:
rts
