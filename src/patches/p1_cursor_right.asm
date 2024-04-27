;;;;; start p1_cursor_right static sprite data ;;;;;
dc.w 1 ; width in tiles
dc.w 3 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $ab0
dc.w $1204
dc.w $ab4
dc.w $1504
dc.w $ab8
dc.w $1504

;; SCB3 vertical position|sticky|size
dc.w $dc03

;; SCB4 horizontal position
dc.w $1100

;; end tiles
