;; writeDialog
;; writes the dialog at the given address into the given address
;; stops when it hits the end dialog word ($ffff), but does not write it
;;
;; parameters
;; A0: where to write the string
;; A1: where to write from
;; uses
;; D0
writeChar:
move.w (A1)+, D0        ; load one crom character
cmpi.w #$ffff, D0       ; is this the end of dialog char?
beq done; it is, we have written the entire dialog
move.w D0, (A0)+        ; it is not the end of dialog, so copy the char over
bra writeChar         ; and keep going

done:
rts