;;;;; start character_grid static sprite data ;;;;;
dc.w 18 ; width in tiles
dc.w 6 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $ff23
dc.w $8e10
dc.w $ff35
dc.w $9610
dc.w $ff47
dc.w $9810
dc.w $ff59
dc.w $9810
dc.w $ff6b
dc.w $a410
dc.w $ff78
dc.w $a410

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $800

;;; column 1

;; SCB1 word pairs
dc.w $ff24
dc.w $8e10
dc.w $ff36
dc.w $9610
dc.w $ff48
dc.w $9810
dc.w $ff5a
dc.w $9810
dc.w $ff6c
dc.w $a410
dc.w $ff79
dc.w $a410

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $1000

;;; column 2

;; SCB1 word pairs
dc.w $ff25
dc.w $8f10
dc.w $ff37
dc.w $8f10
dc.w $ff49
dc.w $9910
dc.w $ff5b
dc.w $9f10
dc.w $ff6d
dc.w $a510
dc.w $ff7a
dc.w $a510

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $1800

;;; column 3

;; SCB1 word pairs
dc.w $ff26
dc.w $8f10
dc.w $ff38
dc.w $8f10
dc.w $ff4a
dc.w $9910
dc.w $ff5c
dc.w $9f10
dc.w $ff6e
dc.w $a510
dc.w $ff7b
dc.w $a510

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $2000

;;; column 4

;; SCB1 word pairs
dc.w $ff27
dc.w $9010
dc.w $ff39
dc.w $9010
dc.w $ff4b
dc.w $9a10
dc.w $ff5d
dc.w $9a10
dc.w $ff6f
dc.w $a610
dc.w $ff7c
dc.w $a610

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $2800

;;; column 5

;; SCB1 word pairs
dc.w $ff28
dc.w $9010
dc.w $ff3a
dc.w $9010
dc.w $ff4c
dc.w $9a10
dc.w $ff5e
dc.w $9a10
dc.w $ff70
dc.w $a610
dc.w $ff7d
dc.w $a410

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $3000

;;; column 6

;; SCB1 word pairs
dc.w $ff29
dc.w $8e10
dc.w $ff3b
dc.w $9710
dc.w $ff4d
dc.w $9910
dc.w $ff5f
dc.w $9d10
dc.w $ff71
dc.w $8e10
dc.w $ff71
dc.w $8e10

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $3800

;;; column 7

;; SCB1 word pairs
dc.w $ff2a
dc.w $8f10
dc.w $ff3c
dc.w $9710
dc.w $ff4e
dc.w $9910
dc.w $ff60
dc.w $a010
dc.w $ff71
dc.w $8e10
dc.w $ff71
dc.w $8e10

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $4000

;;; column 8

;; SCB1 word pairs
dc.w $ff2b
dc.w $9110
dc.w $ff3d
dc.w $9110
dc.w $ff4f
dc.w $9b10
dc.w $ff61
dc.w $9b10
dc.w $ff71
dc.w $8e10
dc.w $ff71
dc.w $8e10

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $4800

;;; column 9

;; SCB1 word pairs
dc.w $ff2c
dc.w $9110
dc.w $ff3e
dc.w $9110
dc.w $ff50
dc.w $9b10
dc.w $ff62
dc.w $9b10
dc.w $ff71
dc.w $8e10
dc.w $ff71
dc.w $8e10

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $5000

;;; column 10

;; SCB1 word pairs
dc.w $ff2d
dc.w $9210
dc.w $ff3f
dc.w $9210
dc.w $ff51
dc.w $9b10
dc.w $ff63
dc.w $a110
dc.w $ff71
dc.w $8e10
dc.w $ff71
dc.w $8e10

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $5800

;;; column 11

;; SCB1 word pairs
dc.w $ff2e
dc.w $9210
dc.w $ff40
dc.w $9210
dc.w $ff52
dc.w $9b10
dc.w $ff64
dc.w $9710
dc.w $ff71
dc.w $8e10
dc.w $ff71
dc.w $8e10

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $6000

;;; column 12

;; SCB1 word pairs
dc.w $ff2f
dc.w $9310
dc.w $ff41
dc.w $9310
dc.w $ff53
dc.w $9c10
dc.w $ff65
dc.w $9e10
dc.w $ff72
dc.w $a710
dc.w $ff7e
dc.w $a710

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $6800

;;; column 13

;; SCB1 word pairs
dc.w $ff30
dc.w $9310
dc.w $ff42
dc.w $9310
dc.w $ff54
dc.w $9c10
dc.w $ff66
dc.w $a210
dc.w $ff73
dc.w $a710
dc.w $ff7f
dc.w $a910

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $7000

;;; column 14

;; SCB1 word pairs
dc.w $ff31
dc.w $9410
dc.w $ff43
dc.w $9410
dc.w $ff55
dc.w $9c10
dc.w $ff67
dc.w $a310
dc.w $ff74
dc.w $a010
dc.w $ff80
dc.w $aa10

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $7800

;;; column 15

;; SCB1 word pairs
dc.w $ff32
dc.w $9410
dc.w $ff44
dc.w $9410
dc.w $ff56
dc.w $9d10
dc.w $ff68
dc.w $a310
dc.w $ff75
dc.w $a710
dc.w $ff81
dc.w $a810

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $8000

;;; column 16

;; SCB1 word pairs
dc.w $ff33
dc.w $9510
dc.w $ff45
dc.w $9510
dc.w $ff57
dc.w $9e10
dc.w $ff69
dc.w $9e10
dc.w $ff76
dc.w $a810
dc.w $ff82
dc.w $ab10

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $8800

;;; column 17

;; SCB1 word pairs
dc.w $ff34
dc.w $9510
dc.w $ff46
dc.w $9510
dc.w $ff58
dc.w $9910
dc.w $ff6a
dc.w $a210
dc.w $ff77
dc.w $a810
dc.w $ff83
dc.w $ab10

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $9000

;; end tiles
