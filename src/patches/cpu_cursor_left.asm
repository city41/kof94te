;;;;; start cpu_cursor_left static sprite data ;;;;;
dc.w 1 ; width in tiles
dc.w 3 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $ad0
dc.w $1704
dc.w $ad4
dc.w $1704
dc.w $ad8
dc.w $1704

;; SCB3 vertical position|sticky|size
dc.w $7003

;; SCB4 horizontal position
dc.w $0

;; end tiles
