;;; swapMemoryRange
;;;
;;; Given two equally sized regions in memory, swaps them
;;;
;;; parameters
;;; A0: pointer to start of first range
;;; a1: pointer to start of second range
;;; D0.w: number of bytes in the range
;;;
;;; uses: D1, D2

subi.w #1, D0 ; sub the size by one to use dbra

swapByte:
move.b (A0, D0.w), D1
move.b (A1, D0.w), D2
move.b D1, (A1, D0.w)
move.b D2, (A0, D0.w)
dbra D0, swapByte

rts
