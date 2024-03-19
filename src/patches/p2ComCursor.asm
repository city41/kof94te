;;;;; start p2 computer cursor sprite data ;;;;;
;;;;; this is for when p2 is the cpu, it says "COM" instead of "P2"

dc.w 3 ; width in tiles
dc.w 3 ; height in tiles

;;;;;;; column 0, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $0
dc.w $0
dc.w $df8a
dc.w $cd10
dc.w $df8b
dc.w $cd10

;; SCB3 vertical position | sticky | size
dc.w $a503

;; SCB4 horizontal position
dc.w $7c00


;;;;;;; column 1, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $df8c
dc.w $cd10
dc.w $0
dc.w $0
dc.w $df8d
dc.w $cd10

;; SCB3 vertical position | sticky | size
dc.w $40

;; SCB4 horizontal position
dc.w $be00


;;;;;;; column 2, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $df8e
dc.w $cd10
dc.w $df8f
dc.w $cd10
dc.w $0
dc.w $0

;; SCB3 vertical position | sticky | size
dc.w $40

;; SCB4 horizontal position
dc.w $be00

