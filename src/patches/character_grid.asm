;;;;; start character_grid static sprite data ;;;;;
dc.w 18 ; width in tiles
dc.w 6 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $ae8
dc.w $1200
dc.w $afa
dc.w $1a00
dc.w $b0c
dc.w $1d00
dc.w $b1e
dc.w $1d00
dc.w $b30
dc.w $2900
dc.w $b3d
dc.w $2900

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $800

;;; column 1

;; SCB1 word pairs
dc.w $ae9
dc.w $1200
dc.w $afb
dc.w $1a00
dc.w $b0d
dc.w $1d00
dc.w $b1f
dc.w $1d00
dc.w $b31
dc.w $2900
dc.w $b3e
dc.w $2900

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $1000

;;; column 2

;; SCB1 word pairs
dc.w $aea
dc.w $1300
dc.w $afc
dc.w $1300
dc.w $b0e
dc.w $1e00
dc.w $b20
dc.w $2300
dc.w $b32
dc.w $2a00
dc.w $b3f
dc.w $2800

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $1800

;;; column 3

;; SCB1 word pairs
dc.w $aeb
dc.w $1300
dc.w $afd
dc.w $1300
dc.w $b0f
dc.w $1e00
dc.w $b21
dc.w $2300
dc.w $b33
dc.w $2800
dc.w $b40
dc.w $2a00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $2000

;;; column 4

;; SCB1 word pairs
dc.w $aec
dc.w $1400
dc.w $afe
dc.w $1400
dc.w $b10
dc.w $1f00
dc.w $b22
dc.w $1f00
dc.w $b34
dc.w $2b00
dc.w $b41
dc.w $2b00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $2800

;;; column 5

;; SCB1 word pairs
dc.w $aed
dc.w $1400
dc.w $aff
dc.w $1400
dc.w $b11
dc.w $1f00
dc.w $b23
dc.w $1f00
dc.w $b35
dc.w $2b00
dc.w $b42
dc.w $2400

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $3000

;;; column 6

;; SCB1 word pairs
dc.w $aee
dc.w $1200
dc.w $b00
dc.w $1b00
dc.w $b12
dc.w $1c00
dc.w $b24
dc.w $1c00
dc.w $b36
dc.w $1200
dc.w $b36
dc.w $1200

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $3800

;;; column 7

;; SCB1 word pairs
dc.w $aef
dc.w $1300
dc.w $b01
dc.w $1b00
dc.w $b13
dc.w $1c00
dc.w $b25
dc.w $2400
dc.w $b36
dc.w $1200
dc.w $b36
dc.w $1200

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $4000

;;; column 8

;; SCB1 word pairs
dc.w $af0
dc.w $1500
dc.w $b02
dc.w $1500
dc.w $b14
dc.w $1e00
dc.w $b26
dc.w $1e00
dc.w $b36
dc.w $1200
dc.w $b36
dc.w $1200

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $4800

;;; column 9

;; SCB1 word pairs
dc.w $af1
dc.w $1500
dc.w $b03
dc.w $1500
dc.w $b15
dc.w $1e00
dc.w $b27
dc.w $2200
dc.w $b36
dc.w $1200
dc.w $b36
dc.w $1200

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $5000

;;; column 10

;; SCB1 word pairs
dc.w $af2
dc.w $1600
dc.w $b04
dc.w $1600
dc.w $b16
dc.w $2000
dc.w $b28
dc.w $2500
dc.w $b36
dc.w $1200
dc.w $b36
dc.w $1200

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $5800

;;; column 11

;; SCB1 word pairs
dc.w $af3
dc.w $1600
dc.w $b05
dc.w $1600
dc.w $b17
dc.w $2000
dc.w $b29
dc.w $1b00
dc.w $b36
dc.w $1200
dc.w $b36
dc.w $1200

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $6000

;;; column 12

;; SCB1 word pairs
dc.w $af4
dc.w $1700
dc.w $b06
dc.w $1700
dc.w $b18
dc.w $2100
dc.w $b2a
dc.w $2100
dc.w $b37
dc.w $2c00
dc.w $b43
dc.w $2e00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $6800

;;; column 13

;; SCB1 word pairs
dc.w $af5
dc.w $1700
dc.w $b07
dc.w $1700
dc.w $b19
dc.w $2100
dc.w $b2b
dc.w $2600
dc.w $b38
dc.w $2c00
dc.w $b44
dc.w $2e00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $7000

;;; column 14

;; SCB1 word pairs
dc.w $af6
dc.w $1800
dc.w $b08
dc.w $1800
dc.w $b1a
dc.w $2000
dc.w $b2c
dc.w $2700
dc.w $b39
dc.w $2c00
dc.w $b45
dc.w $2f00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $7800

;;; column 15

;; SCB1 word pairs
dc.w $af7
dc.w $1800
dc.w $b09
dc.w $1c00
dc.w $b1b
dc.w $2200
dc.w $b2d
dc.w $2700
dc.w $b3a
dc.w $2c00
dc.w $b46
dc.w $2c00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $8000

;;; column 16

;; SCB1 word pairs
dc.w $af8
dc.w $1900
dc.w $b0a
dc.w $1900
dc.w $b1c
dc.w $2100
dc.w $b2e
dc.w $2600
dc.w $b3b
dc.w $2d00
dc.w $b47
dc.w $2d00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $8800

;;; column 17

;; SCB1 word pairs
dc.w $af9
dc.w $1900
dc.w $b0b
dc.w $1900
dc.w $b1d
dc.w $2100
dc.w $b2f
dc.w $2800
dc.w $b3c
dc.w $2d00
dc.w $b48
dc.w $2d00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $9000

;; end tiles
