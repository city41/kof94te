;;;;; start character_grid static sprite data ;;;;;
dc.w 18 ; width in tiles
dc.w 6 ; height in tiles

;; start sprite tiles
;;; column 0

;; SCB1 word pairs
dc.w $196
dc.w $e100
dc.w $1a8
dc.w $e900
dc.w $1ba
dc.w $eb00
dc.w $1cc
dc.w $eb00
dc.w $1de
dc.w $f700
dc.w $1ea
dc.w $f700

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $800

;;; column 1

;; SCB1 word pairs
dc.w $197
dc.w $e100
dc.w $1a9
dc.w $e900
dc.w $1bb
dc.w $eb00
dc.w $1cd
dc.w $eb00
dc.w $1df
dc.w $f700
dc.w $1eb
dc.w $f700

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $1000

;;; column 2

;; SCB1 word pairs
dc.w $198
dc.w $e200
dc.w $1aa
dc.w $e200
dc.w $1bc
dc.w $ec00
dc.w $1ce
dc.w $f200
dc.w $1e0
dc.w $f800
dc.w $1ec
dc.w $f800

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $1800

;;; column 3

;; SCB1 word pairs
dc.w $199
dc.w $e200
dc.w $1ab
dc.w $e200
dc.w $1bd
dc.w $ec00
dc.w $1cf
dc.w $f200
dc.w $1e1
dc.w $f800
dc.w $1ed
dc.w $f800

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $2000

;;; column 4

;; SCB1 word pairs
dc.w $19a
dc.w $e300
dc.w $1ac
dc.w $e300
dc.w $1be
dc.w $ed00
dc.w $1d0
dc.w $ed00
dc.w $1e2
dc.w $f900
dc.w $1ee
dc.w $f900

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $2800

;;; column 5

;; SCB1 word pairs
dc.w $19b
dc.w $e300
dc.w $1ad
dc.w $e300
dc.w $1bf
dc.w $ed00
dc.w $1d1
dc.w $ed00
dc.w $1e3
dc.w $f900
dc.w $1ef
dc.w $f700

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $3000

;;; column 6

;; SCB1 word pairs
dc.w $19c
dc.w $e100
dc.w $1ae
dc.w $ea00
dc.w $1c0
dc.w $ec00
dc.w $1d2
dc.w $f000
dc.w $52
dc.w $c200
dc.w $52
dc.w $c200

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $3800

;;; column 7

;; SCB1 word pairs
dc.w $19d
dc.w $e200
dc.w $1af
dc.w $ea00
dc.w $1c1
dc.w $ec00
dc.w $1d3
dc.w $f300
dc.w $52
dc.w $c200
dc.w $52
dc.w $c200

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $4000

;;; column 8

;; SCB1 word pairs
dc.w $19e
dc.w $e400
dc.w $1b0
dc.w $e400
dc.w $1c2
dc.w $ee00
dc.w $1d4
dc.w $ee00
dc.w $52
dc.w $c200
dc.w $52
dc.w $c200

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $4800

;;; column 9

;; SCB1 word pairs
dc.w $19f
dc.w $e400
dc.w $1b1
dc.w $e400
dc.w $1c3
dc.w $ee00
dc.w $1d5
dc.w $ee00
dc.w $52
dc.w $c200
dc.w $52
dc.w $c200

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $5000

;;; column 10

;; SCB1 word pairs
dc.w $1a0
dc.w $e500
dc.w $1b2
dc.w $e500
dc.w $1c4
dc.w $ee00
dc.w $1d6
dc.w $f400
dc.w $52
dc.w $c200
dc.w $52
dc.w $c200

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $5800

;;; column 11

;; SCB1 word pairs
dc.w $1a1
dc.w $e500
dc.w $1b3
dc.w $e500
dc.w $1c5
dc.w $ee00
dc.w $1d7
dc.w $ea00
dc.w $52
dc.w $c200
dc.w $52
dc.w $c200

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $6000

;;; column 12

;; SCB1 word pairs
dc.w $1a2
dc.w $e600
dc.w $1b4
dc.w $e600
dc.w $1c6
dc.w $ef00
dc.w $1d8
dc.w $f100
dc.w $1e4
dc.w $fa00
dc.w $1f0
dc.w $fa00

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $6800

;;; column 13

;; SCB1 word pairs
dc.w $1a3
dc.w $e600
dc.w $1b5
dc.w $e600
dc.w $1c7
dc.w $ef00
dc.w $1d9
dc.w $f500
dc.w $1e5
dc.w $fa00
dc.w $1f1
dc.w $fc00

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $7000

;;; column 14

;; SCB1 word pairs
dc.w $1a4
dc.w $e700
dc.w $1b6
dc.w $e700
dc.w $1c8
dc.w $ef00
dc.w $1da
dc.w $f600
dc.w $1e6
dc.w $f300
dc.w $1f2
dc.w $fd00

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $7800

;;; column 15

;; SCB1 word pairs
dc.w $1a5
dc.w $e700
dc.w $1b7
dc.w $e700
dc.w $1c9
dc.w $f000
dc.w $1db
dc.w $f600
dc.w $1e7
dc.w $fa00
dc.w $1f3
dc.w $fb00

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $8000

;;; column 16

;; SCB1 word pairs
dc.w $1a6
dc.w $e800
dc.w $1b8
dc.w $e800
dc.w $1ca
dc.w $f100
dc.w $1dc
dc.w $f100
dc.w $1e8
dc.w $fb00
dc.w $1f4
dc.w $fe00

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $8800

;;; column 17

;; SCB1 word pairs
dc.w $1a7
dc.w $e800
dc.w $1b9
dc.w $e800
dc.w $1cb
dc.w $ec00
dc.w $1dd
dc.w $f500
dc.w $1e9
dc.w $fb00
dc.w $1f5
dc.w $fe00

;; SCB3 vertical position|sticky|size
dc.w $d906

;; SCB4 horizontal position
dc.w $9000

;; end tiles
