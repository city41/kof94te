; charIdToContinueSfxOffset
; -------------------------
; this table maps from charId to a word. That word is how far into the sfx table at $44c2a
; that the corresponding character's continue sound effect is. This is the sound effect
; that gets played when you decide to continue, usually a team lead yelling out something.
;
; In the vanilla game, there are only 8 continue sound effects. They are also not always the team lead,
; for example Mai yells out when you continue with team England.

; characters that have a straight literal were taken from the original game
; characters that have an expression, it is (<location in sfx table> - <start of sfx table>) / 2
; that is because the game takes whatever this value is and doubles it before using it as an offset
; each character's sound effect was figured out in characterContinueSfx.md

dc.w $177     ;  0: Heidern
dc.w ($51c54 - $51924) / 2     ;  1: Ralf
dc.w ($51c3c - $51924) / 2     ;  2: Clark
dc.w $1F4     ;  3: Athena
dc.w ($51cce - $51924) / 2     ;  4: Sie
dc.w ($51cea - $51924) / 2     ;  5: Chin
dc.w $124     ;  6: Kyo
dc.w ($51b92 - $51924) / 2     ;  7: Beni
dc.w ($51bbc - $51924) / 2     ;  8: Goro
dc.w $1B9     ;  9: Heavy
dc.w ($51c8e - $51924) / 2     ;  a: Lucky
dc.w ($51c72 - $51924) / 2     ;  b: Brian
dc.w $16B     ;  c: Kim
dc.w ($51bea - $51924) / 2     ;  d: Chang
dc.w ($51bd2 - $51924) / 2     ;  e: Choi
dc.w $8E      ;  f: Terry
dc.w ($51a50 - $51924) / 2     ; 10: Andy
dc.w ($51a7a - $51924) / 2    ; 11: Joe
dc.w $56      ; 12: Ryo
dc.w ($519f8 - $51924) / 2    ; 13: Robert
dc.w ($51a18 - $51924) / 2     ; 14: Takuma
dc.w ($51abe - $51924) / 2    ; 15: Yuri
dc.w $BF      ; 16: Mai
dc.w ($51ade - $51924) / 2    ; 17: King