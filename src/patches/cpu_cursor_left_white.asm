;;;;; start cpu_cursor_left_white static sprite data ;;;;;
dc.w 1 ; width in tiles
dc.w 3 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $ff41
dc.w $1710
dc.w $ff42
dc.w $1710
dc.w $ff43
dc.w $1710

;; SCB3 vertical position|sticky|size
dc.w $7003

;; SCB4 horizontal position
dc.w $0

;; end tiles
