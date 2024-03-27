;;;;; start p2_cursor static sprite data ;;;;;
dc.w 2 ; width in tiles
dc.w 3 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $aac
dc.w $1204
dc.w $ac8
dc.w $2404
dc.w $ad0
dc.w $2404

;; SCB3 vertical position|sticky|size
dc.w $3

;; SCB4 horizontal position
dc.w $0

;;; column 1

;; SCB1 word pairs
dc.w $ac4
dc.w $2404
dc.w $acc
dc.w $2404
dc.w $aac
dc.w $1204

;; SCB3 vertical position|sticky|size
dc.w $43

;; SCB4 horizontal position
dc.w $0

;; end tiles
