;;;;; start cpu_cursor_right static sprite data ;;;;;
dc.w 1 ; width in tiles
dc.w 3 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $adc
dc.w $1604
dc.w $ae0
dc.w $1604
dc.w $ae4
dc.w $1604

;; SCB3 vertical position|sticky|size
dc.w $7003

;; SCB4 horizontal position
dc.w $0

;; end tiles
