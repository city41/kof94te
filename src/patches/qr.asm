;;;;; start qr static sprite data ;;;;;
dc.w 2 ; width in tiles
dc.w 2 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $ff4a
dc.w $1310
dc.w $ff4c
dc.w $1310

;; SCB3 vertical position|sticky|size
dc.w $9f02

;; SCB4 horizontal position
dc.w $4800

;;; column 1

;; SCB1 word pairs
dc.w $ff4b
dc.w $1310
dc.w $ff4d
dc.w $1310

;; SCB3 vertical position|sticky|size
dc.w $9f42

;; SCB4 horizontal position
dc.w $5000

;; end tiles
