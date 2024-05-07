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

dc.l $545c8; Heidern
dc.l $6313a; Ralf
dc.l $6324a; Clark
dc.l $636d6; Athena
dc.l $6362c; Kensou
dc.l $63546; Chin
dc.l $54a18; Kyo
dc.l $63764; Benimaru
dc.l $54a56; Daimon -- not found yet, setting to NL so it remains empty
dc.l $54dd0; Heavy D
dc.l $63cae; Lucky
dc.l $63bb4; Brian
dc.l $63e56; Kim
dc.l $63f7c; Chang
dc.l $63eba; Choi
dc.l $64218; Terry
dc.l $6412c; Andy
dc.l $642bc; Joe
dc.l $645fe; Ryo
dc.l $64552; Robert
dc.l $6440c; Takuma
dc.l $64784; Yuri
dc.l $646e6; Mai
dc.l $6499e; King