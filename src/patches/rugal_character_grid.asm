;;;;; start rugal_character_grid static sprite data ;;;;;
dc.w 2 ; width in tiles
dc.w 2 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $b13
dc.w $3000
dc.w $b15
dc.w $3100

;; SCB3 vertical position|sticky|size
dc.w $ba82

;; SCB4 horizontal position
dc.w $4800

;;; column 1

;; SCB1 word pairs
dc.w $b14
dc.w $3000
dc.w $b16
dc.w $3100

;; SCB3 vertical position|sticky|size
dc.w $bac2

;; SCB4 horizontal position
dc.w $5000

;; end tiles
