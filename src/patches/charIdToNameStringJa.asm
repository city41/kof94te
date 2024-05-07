;; charIdToNameStringJa.asm
;; ------------------------
;; This is a table from character id to name as a crom string
;; this is used to form the dynamic dialog of cutscene 2.
;;
;; each long points to a place in ROM where that chacter's name
;; is encoded in the crom tile IDs used for cutscene dialog.
;; each name ends with a new line character, so that can be used
;; to account for each name being a different length
;;
;; used in cutscene2Dialog.asm
;;
;; in this table the names are in Japanese

dc.l $57c4c ; Heidern
dc.l $652c6 ; Ralf
dc.l $65442 ; Clark
dc.l $55db0 ; Athena
dc.l $55d60 ; Kensou
dc.l $55dfe ; Chin
dc.l $5626a ; Kyo
dc.l $56378 ; Benimaru
dc.l $562d8 ; Daimon
dc.l $5678e ; Heavy D
dc.l $56818 ; Lucky
dc.l $5689a ; Brian
dc.l $5696c ; Kim
dc.l $56b56 ; Chang
dc.l $56abc ; Choi
dc.l $56dda ; Terry
dc.l $57060 ; Andy
dc.l $56fa4 ; Joe
dc.l $5746c ; Ryo
dc.l $575ba ; Robert
dc.l $574be ; Takuma
dc.l $577ec ; Yuri
dc.l $5777e ; Mai
dc.l $5799e ; King