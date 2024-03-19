;;;;; start p1 cursor sprite data ;;;;;
;;;;; this for when p1 is a human, it says "P1"
;;;;; this version has a black border

dc.w 3 ; width in tiles
dc.w 3 ; height in tiles

;;;;;;; column 0, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $dd52
dc.w $cd10
dc.w $dd53
dc.w $cd10
dc.w $0
dc.w $0

;; SCB3 vertical position | sticky | size
dc.w $a503

;; SCB4 horizontal position
dc.w $c00


;;;;;;; column 1, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $dd54
dc.w $cd10
dc.w $0
dc.w $0
dc.w $dd55
dc.w $cd10

;; SCB3 vertical position | sticky | size
dc.w $40

;; SCB4 horizontal position
dc.w $be00


;;;;;;; column 2, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $0
dc.w $0
dc.w $dd56
dc.w $cd10
dc.w $dd57
dc.w $cd10

;; SCB3 vertical position | sticky | size
dc.w $40

;; SCB4 horizontal position
dc.w $be00
