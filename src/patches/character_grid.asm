;;;;; start character_grid static sprite data ;;;;;
dc.w 18 ; width in tiles
dc.w 6 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $aa8
dc.w $1200
dc.w $aba
dc.w $1a00
dc.w $acc
dc.w $1d00
dc.w $ade
dc.w $1d00
dc.w $af0
dc.w $2900
dc.w $b02
dc.w $2900

;; SCB3 vertical position|sticky|size
dc.w $d806

;; SCB4 horizontal position
dc.w $800

;;; column 1

;; SCB1 word pairs
dc.w $aa9
dc.w $1200
dc.w $abb
dc.w $1a00
dc.w $acd
dc.w $1d00
dc.w $adf
dc.w $1d00
dc.w $af1
dc.w $2900
dc.w $b03
dc.w $2900

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $1000

;;; column 2

;; SCB1 word pairs
dc.w $aaa
dc.w $1300
dc.w $abc
dc.w $1300
dc.w $ace
dc.w $1e00
dc.w $ae0
dc.w $2300
dc.w $af2
dc.w $2a00
dc.w $b04
dc.w $2800

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $1800

;;; column 3

;; SCB1 word pairs
dc.w $aab
dc.w $1300
dc.w $abd
dc.w $1300
dc.w $acf
dc.w $1e00
dc.w $ae1
dc.w $2300
dc.w $af3
dc.w $2800
dc.w $b05
dc.w $2a00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $2000

;;; column 4

;; SCB1 word pairs
dc.w $aac
dc.w $1400
dc.w $abe
dc.w $1400
dc.w $ad0
dc.w $1f00
dc.w $ae2
dc.w $1f00
dc.w $af4
dc.w $2b00
dc.w $b06
dc.w $2b00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $2800

;;; column 5

;; SCB1 word pairs
dc.w $aad
dc.w $1400
dc.w $abf
dc.w $1400
dc.w $ad1
dc.w $1f00
dc.w $ae3
dc.w $1f00
dc.w $af5
dc.w $2b00
dc.w $b07
dc.w $2400

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $3000

;;; column 6

;; SCB1 word pairs
dc.w $aae
dc.w $1200
dc.w $ac0
dc.w $1b00
dc.w $ad2
dc.w $1c00
dc.w $ae4
dc.w $1c00
dc.w $af6
dc.w $1400
dc.w $b08
dc.w $1400

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $3800

;;; column 7

;; SCB1 word pairs
dc.w $aaf
dc.w $1300
dc.w $ac1
dc.w $1b00
dc.w $ad3
dc.w $1c00
dc.w $ae5
dc.w $2400
dc.w $af7
dc.w $1400
dc.w $b09
dc.w $1400

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $4000

;;; column 8

;; SCB1 word pairs
dc.w $ab0
dc.w $1500
dc.w $ac2
dc.w $1500
dc.w $ad4
dc.w $1e00
dc.w $ae6
dc.w $1e00
dc.w $af8
dc.w $1200
dc.w $b0a
dc.w $1200

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $4800

;;; column 9

;; SCB1 word pairs
dc.w $ab1
dc.w $1500
dc.w $ac3
dc.w $1500
dc.w $ad5
dc.w $1e00
dc.w $ae7
dc.w $2200
dc.w $af9
dc.w $1200
dc.w $af9
dc.w $1200

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $5000

;;; column 10

;; SCB1 word pairs
dc.w $ab2
dc.w $1600
dc.w $ac4
dc.w $1600
dc.w $ad6
dc.w $2000
dc.w $ae8
dc.w $2500
dc.w $afa
dc.w $1600
dc.w $b0b
dc.w $1600

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $5800

;;; column 11

;; SCB1 word pairs
dc.w $ab3
dc.w $1600
dc.w $ac5
dc.w $1600
dc.w $ad7
dc.w $2000
dc.w $ae9
dc.w $1b00
dc.w $afb
dc.w $1600
dc.w $b0c
dc.w $1600

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $6000

;;; column 12

;; SCB1 word pairs
dc.w $ab4
dc.w $1700
dc.w $ac6
dc.w $1700
dc.w $ad8
dc.w $2100
dc.w $aea
dc.w $2100
dc.w $afc
dc.w $2c00
dc.w $b0d
dc.w $2e00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $6800

;;; column 13

;; SCB1 word pairs
dc.w $ab5
dc.w $1700
dc.w $ac7
dc.w $1700
dc.w $ad9
dc.w $2100
dc.w $aeb
dc.w $2600
dc.w $afd
dc.w $2c00
dc.w $b0e
dc.w $2e00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $7000

;;; column 14

;; SCB1 word pairs
dc.w $ab6
dc.w $1800
dc.w $ac8
dc.w $1800
dc.w $ada
dc.w $2000
dc.w $aec
dc.w $2700
dc.w $afe
dc.w $2c00
dc.w $b0f
dc.w $2f00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $7800

;;; column 15

;; SCB1 word pairs
dc.w $ab7
dc.w $1800
dc.w $ac9
dc.w $1c00
dc.w $adb
dc.w $2200
dc.w $aed
dc.w $2700
dc.w $aff
dc.w $2c00
dc.w $b10
dc.w $2c00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $8000

;;; column 16

;; SCB1 word pairs
dc.w $ab8
dc.w $1900
dc.w $aca
dc.w $1900
dc.w $adc
dc.w $2100
dc.w $aee
dc.w $2600
dc.w $b00
dc.w $2d00
dc.w $b11
dc.w $2d00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $8800

;;; column 17

;; SCB1 word pairs
dc.w $ab9
dc.w $1900
dc.w $acb
dc.w $1900
dc.w $add
dc.w $2100
dc.w $aef
dc.w $2800
dc.w $b01
dc.w $2d00
dc.w $b12
dc.w $2d00

;; SCB3 vertical position|sticky|size
dc.w $d846

;; SCB4 horizontal position
dc.w $9000

;; end tiles
