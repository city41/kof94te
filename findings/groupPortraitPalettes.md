# Group Portrait Palettes

The group portrait first shows up all corrupt, then about a second later fixes itself. Hopefully can skip the corrupt phase

## Corrupt phase

palette $22 at 400440 is writen to at 3364c, which is just a general palette writing routine.

A0 1098e6
A1 400440

1098E6: 0022 0000 0000 0000 0000 0000 0000 0000 ."..............
1098F6: 0000 0000 0000 0000 0000 0000 0000 0000 ................

032B92: move.l ($4178,A5), D0
032B96: move.l ($4174,A5), ($4178,A5)
032B9C: move.l D0, ($4174,A5)
032BA0: move.l D0, ($417c,A5)
032BA4: lea $108000.l, A5
032BAA: move.b D0, $300001.l
032BB0: move.w #$4, $3c000c.l
032BB8: btst #$1, ($38b8,A5)
032BBE: bne $32bca
032BC2: move.w ($38ba,A5), $401ffe.l
032BCA: tst.b ($784,A5)
032BCE: bne $32bea
032BD0: addq.l #1, (-$7f7c,A5)
032BD4: bsr $33614
033614: tst.b ($38b8,A5)
033618: bpl $33632
033632: andi.b #$7f, ($38b8,A5)
033638: lea ($18a6,A5), A0
03363C: move.w (A0), D0
03363E: bmi $3365e
033642: jsr $2bc7e0.l
2BC7E0: cmpi.b #$1, $10f8e5.l
2BC7E8: bne $2bc800
2BC800: lea $400000.l, A1
2BC806: rts
033648: lsl.w #5, D0
03364A: adda.w D0, A1
03364C: move.l (A0)+, (A1)+
03364E: move.l (A0)+, (A1)+
033650: move.l (A0)+, (A1)+
033652: move.l (A0)+, (A1)+
033654: move.l (A0)+, (A1)+
033656: move.l (A0)+, (A1)+
033658: move.l (A0)+, (A1)+
03365A: move.l (A0)+, (A1)+
03365C: bra $3363c
03363C: move.w (A0), D0
03363E: bmi $3365e
033642: jsr $2bc7e0.l
2BC7E0: cmpi.b #$1, $10f8e5.l
2BC7E8: bne $2bc800
2BC800: lea $400000.l, A1
2BC806: rts
033648: lsl.w #5, D0
03364A: adda.w D0, A1
03364C: move.l (A0)+, (A1)+
03364E: move.l (A0)+, (A1)+
033650: move.l (A0)+, (A1)+
033652: move.l (A0)+, (A1)+
033654: move.l (A0)+, (A1)+
033656: move.l (A0)+, (A1)+
033658: move.l (A0)+, (A1)+
03365A: move.l (A0)+, (A1)+
03365C: bra $3363c
03363C: move.w (A0), D0
03363E: bmi $3365e
033642: jsr $2bc7e0.l
2BC7E0: cmpi.b #$1, $10f8e5.l
2BC7E8: bne $2bc800
2BC800: lea $400000.l, A1
2BC806: rts
033648: lsl.w #5, D0
03364A: adda.w D0, A1
03364C: move.l (A0)+, (A1)+

## Correct phase

A0 109906
A1 400440

109906: 0022 7FFF 4FEA 0FB7 3D73 3941 6410 1CDC ."..O...=s9Ad...
109916: 58AA 7578 1355 1022 4442 5331 1220 0000 X.ux.U."DBS1. ..

03363C: move.w (A0), D0
03363E: bmi $3365e
033642: jsr $2bc7e0.l
2BC7E0: cmpi.b #$1, $10f8e5.l
2BC7E8: bne $2bc800
2BC800: lea $400000.l, A1
2BC806: rts
033648: lsl.w #5, D0
03364A: adda.w D0, A1
03364C: move.l (A0)+, (A1)+
03364E: move.l (A0)+, (A1)+
033650: move.l (A0)+, (A1)+
033652: move.l (A0)+, (A1)+
033654: move.l (A0)+, (A1)+
033656: move.l (A0)+, (A1)+
033658: move.l (A0)+, (A1)+
03365A: move.l (A0)+, (A1)+
03365C: bra $3363c
03363C: move.w (A0), D0
03363E: bmi $3365e
033642: jsr $2bc7e0.l
2BC7E0: cmpi.b #$1, $10f8e5.l
2BC7E8: bne $2bc800
2BC800: lea $400000.l, A1
2BC806: rts
033648: lsl.w #5, D0
03364A: adda.w D0, A1
03364C: move.l (A0)+, (A1)+
03364E: move.l (A0)+, (A1)+
033650: move.l (A0)+, (A1)+
033652: move.l (A0)+, (A1)+
033654: move.l (A0)+, (A1)+
033656: move.l (A0)+, (A1)+
033658: move.l (A0)+, (A1)+
03365A: move.l (A0)+, (A1)+
03365C: bra $3363c
03363C: move.w (A0), D0
03363E: bmi $3365e
033642: jsr $2bc7e0.l
2BC7E0: cmpi.b #$1, $10f8e5.l
2BC7E8: bne $2bc800
2BC800: lea $400000.l, A1
2BC806: rts
033648: lsl.w #5, D0
03364A: adda.w D0, A1
03364C: move.l (A0)+, (A1)+
03364E: move.l (A0)+, (A1)+
033650: move.l (A0)+, (A1)+
033652: move.l (A0)+, (A1)+
033654: move.l (A0)+, (A1)+
033656: move.l (A0)+, (A1)+
033658: move.l (A0)+, (A1)+
03365A: move.l (A0)+, (A1)+
03365C: bra $3363c
03363C: move.w (A0), D0
03363E: bmi $3365e
033642: jsr $2bc7e0.l
2BC7E0: cmpi.b #$1, $10f8e5.l
2BC7E8: bne $2bc800
2BC800: lea $400000.l, A1
2BC806: rts
033648: lsl.w #5, D0
03364A: adda.w D0, A1
03364C: move.l (A0)+, (A1)+

## vanilla 584 writes

the hack does the same writes

4452C at 4452C actually at 44524
4458E at 4458E actually at 44586
// then fades away
// these writes are after it is done fading
// and showing the attract mode
3256C at 32574
388FE at 325C0
38936 at 38906
38A8C at 38A8C

Using wildJumps to go straight to 443fc (start credits) does not cause a corrupted group.
