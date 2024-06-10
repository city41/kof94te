;;;;; start p1_cursor_left_black static sprite data ;;;;;
dc.w 1 ; width in tiles
dc.w 2 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $bdd
dc.w $1400
dc.w $bde
dc.w $1400

;; SCB3 vertical position|sticky|size
dc.w $ee02

;; SCB4 horizontal position
dc.w $800

;; end tiles
