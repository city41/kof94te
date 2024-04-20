;;;;; start p1_cursor static sprite data ;;;;;
dc.w 2 ; width in tiles
dc.w 3 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $aa8
dc.w $1304
dc.w $ab0
dc.w $1304
dc.w $ab8
dc.w $1204

;; SCB3 vertical position|sticky|size
dc.w $1c03

;; SCB4 horizontal position
dc.w $800

;;; column 1

;; SCB1 word pairs
dc.w $aac
dc.w $1204
dc.w $ab4
dc.w $1304
dc.w $abc
dc.w $1304

;; SCB3 vertical position|sticky|size
dc.w $1c43

;; SCB4 horizontal position
dc.w $1000

;; end tiles
