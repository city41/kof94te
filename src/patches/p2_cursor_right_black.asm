;;;;; start p2_cursor_right static sprite data ;;;;;
dc.w 1 ; width in tiles
dc.w 2 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $ff68
dc.w $1810
dc.w $ff69
dc.w $1810

;; SCB3 vertical position|sticky|size
dc.w $ee02

;; SCB4 horizontal position
dc.w $9000

;; end tiles
