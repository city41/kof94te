;;;;; start p2 computer cursor sprite data ;;;;;
;;;;; this is for when p2 is the cpu, it says "COM" instead of "P2"

dc.w 7 ; width in tiles
dc.w 3 ; height in tiles

;;;;;;; column 0, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $0
dc.w $0
dc.w $dc9e
dc.w $cd10
dc.w $dc9f
dc.w $cd10

;; SCB3 vertical position | sticky | size
dc.w $a503

;; SCB4 horizontal position
dc.w $7c00


;;;;;;; column 1, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $dca0
dc.w $cd10
dc.w $0
dc.w $0
dc.w $dca1
dc.w $cd10

;; SCB3 vertical position | sticky | size
dc.w $40

;; SCB4 horizontal position
dc.w $be00


;;;;;;; column 2, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $dca2
dc.w $cd10
dc.w $dc9e
dc.w $cd10
dc.w $dc9f
dc.w $cd10

;; SCB3 vertical position | sticky | size
dc.w $40

;; SCB4 horizontal position
dc.w $be00

;;;;;;; column 3, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $dca0
dc.w $cd10
dc.w $0
dc.w $0
dc.w $dca1
dc.w $cd10

;; SCB3 vertical position | sticky | size
dc.w $40

;; SCB4 horizontal position
dc.w $be00

;;;;;;; column 4, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $dca2
dc.w $cd10
dc.w $dca3
dc.w $cd10
dc.w $dc9f
dc.w $cd10

;; SCB3 vertical position | sticky | size
dc.w $40

;; SCB4 horizontal position
dc.w $be00

;;;;;;; column 5, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $dca0
dc.w $cd10
dc.w $0
dc.w $0
dc.w $dca1
dc.w $cd10

;; SCB3 vertical position | sticky | size
dc.w $40

;; SCB4 horizontal position
dc.w $be00

;;;;;;; column 6, 3 tiles high ;;;;;;;
;; SCB1 word pairs
dc.w $dca2
dc.w $cd10
dc.w $dca3
dc.w $cd10
dc.w $0
dc.w $0

;; SCB3 vertical position | sticky | size
dc.w $40

;; SCB4 horizontal position
dc.w $be00

