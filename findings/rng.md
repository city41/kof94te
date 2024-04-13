# RNG

the routine at 2582 is possibly the rng

002582 add.w $3c0006.l, D0
002588 lsr.w   #3, D0   
00258A add.w   (-$7f78,A5), D0
00258E add.w   (-$7f7a,A5), D0
002592 addq.w  #1, (-$7f78,A5)
002596 lea     $c04200.l, A0 
00259C andi.l  #$ff, D0
0025A2 move.b (A0,D0.w), D0
0025A6 rts
