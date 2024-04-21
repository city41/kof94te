;;;;; start rugal_character_grid static sprite data ;;;;;
dc.w 2 ; width in tiles
dc.w 2 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $b51
dc.w $3000
dc.w $b53
dc.w $3100

;; SCB3 vertical position|sticky|size
dc.w $b002

;; SCB4 horizontal position
dc.w $4800

;;; column 1

;; SCB1 word pairs
dc.w $b52
dc.w $3000
dc.w $b54
dc.w $3100

;; SCB3 vertical position|sticky|size
dc.w $b042

;; SCB4 horizontal position
dc.w $5000

;; end tiles
