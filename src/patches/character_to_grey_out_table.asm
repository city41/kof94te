;; the grey scb1 vramaddr|vramrw word pairs
;; the data from this was calculated in sromCromPreEmit.ts
;; the data is in character id order (so Heidern is first)
;; each character has 8 word pairs
;; each pair is [vramaddr]|[vramrw]
;; this is scb1 data that changes the tile and palette
;; for a character in the character grid
;; greyOutDefeatedCharacters.asm largely just blindly writes
;; this data for any character that has been defeated, turning them grey
dc.w $57c0
dc.w $bdb
dc.w $57c1
dc.w $6800
dc.w $57c2
dc.w $ff2e
dc.w $57c3
dc.w $6810
dc.w $5800
dc.w $bdc
dc.w $5801
dc.w $6800
dc.w $5802
dc.w $ff2f
dc.w $5803
dc.w $6810
dc.w $5840
dc.w $bdd
dc.w $5841
dc.w $6900
dc.w $5842
dc.w $ff30
dc.w $5843
dc.w $7c10
dc.w $5880
dc.w $bde
dc.w $5881
dc.w $6900
dc.w $5882
dc.w $ff31
dc.w $5883
dc.w $7d10
dc.w $58c0
dc.w $bdf
dc.w $58c1
dc.w $6a00
dc.w $58c2
dc.w $ff32
dc.w $58c3
dc.w $7e10
dc.w $5900
dc.w $be0
dc.w $5901
dc.w $6a00
dc.w $5902
dc.w $ff33
dc.w $5903
dc.w $7e10
dc.w $54c4
dc.w $be1
dc.w $54c5
dc.w $6b00
dc.w $54c6
dc.w $ff34
dc.w $54c7
dc.w $6b10
dc.w $5504
dc.w $be2
dc.w $5505
dc.w $6b00
dc.w $5506
dc.w $ff35
dc.w $5507
dc.w $6b10
dc.w $5544
dc.w $be3
dc.w $5545
dc.w $6600
dc.w $5546
dc.w $ff36
dc.w $5547
dc.w $7f10
dc.w $5584
dc.w $be4
dc.w $5585
dc.w $6600
dc.w $5586
dc.w $ff37
dc.w $5587
dc.w $7f10
dc.w $55c4
dc.w $be5
dc.w $55c5
dc.w $6c00
dc.w $55c6
dc.w $ff38
dc.w $55c7
dc.w $6c10
dc.w $5604
dc.w $be6
dc.w $5605
dc.w $6c00
dc.w $5606
dc.w $ff39
dc.w $5607
dc.w $6c10
dc.w $54c8
dc.w $be7
dc.w $54c9
dc.w $6700
dc.w $54ca
dc.w $ff3a
dc.w $54cb
dc.w $8010
dc.w $5508
dc.w $be8
dc.w $5509
dc.w $6400
dc.w $550a
dc.w $ff3b
dc.w $550b
dc.w $8010
dc.w $5548
dc.w $be9
dc.w $5549
dc.w $6d00
dc.w $554a
dc.w $ff3c
dc.w $554b
dc.w $8110
dc.w $5588
dc.w $bea
dc.w $5589
dc.w $6d00
dc.w $558a
dc.w $ff3d
dc.w $558b
dc.w $8110
dc.w $55c8
dc.w $beb
dc.w $55c9
dc.w $6e00
dc.w $55ca
dc.w $ff3e
dc.w $55cb
dc.w $6d10
dc.w $5608
dc.w $bec
dc.w $5609
dc.w $6d00
dc.w $560a
dc.w $ff3f
dc.w $560b
dc.w $6d10
dc.w $5640
dc.w $bed
dc.w $5641
dc.w $6800
dc.w $5642
dc.w $ff40
dc.w $5643
dc.w $6f10
dc.w $5680
dc.w $bee
dc.w $5681
dc.w $6f00
dc.w $5682
dc.w $ff41
dc.w $5683
dc.w $8210
dc.w $56c0
dc.w $bef
dc.w $56c1
dc.w $7000
dc.w $56c2
dc.w $ff42
dc.w $56c3
dc.w $7010
dc.w $5700
dc.w $bf0
dc.w $5701
dc.w $7000
dc.w $5702
dc.w $ff43
dc.w $5703
dc.w $7010
dc.w $5740
dc.w $bf1
dc.w $5741
dc.w $7100
dc.w $5742
dc.w $ff44
dc.w $5743
dc.w $8310
dc.w $5780
dc.w $bf2
dc.w $5781
dc.w $6f00
dc.w $5782
dc.w $ff45
dc.w $5783
dc.w $8310
dc.w $5644
dc.w $bf3
dc.w $5645
dc.w $7100
dc.w $5646
dc.w $ff46
dc.w $5647
dc.w $8410
dc.w $5684
dc.w $bf4
dc.w $5685
dc.w $7100
dc.w $5686
dc.w $ff47
dc.w $5687
dc.w $8410
dc.w $56c4
dc.w $bf5
dc.w $56c5
dc.w $7200
dc.w $56c6
dc.w $ff48
dc.w $56c7
dc.w $6e10
dc.w $5704
dc.w $bf6
dc.w $5705
dc.w $6e00
dc.w $5706
dc.w $ff49
dc.w $5707
dc.w $8510
dc.w $5744
dc.w $bf7
dc.w $5745
dc.w $7300
dc.w $5746
dc.w $ff4a
dc.w $5747
dc.w $7310
dc.w $5784
dc.w $bf8
dc.w $5785
dc.w $7200
dc.w $5786
dc.w $ff4b
dc.w $5787
dc.w $7310
dc.w $54c0
dc.w $bf9
dc.w $54c1
dc.w $7400
dc.w $54c2
dc.w $ff4c
dc.w $54c3
dc.w $8610
dc.w $5500
dc.w $bfa
dc.w $5501
dc.w $7400
dc.w $5502
dc.w $ff4d
dc.w $5503
dc.w $8610
dc.w $5540
dc.w $bfb
dc.w $5541
dc.w $7500
dc.w $5542
dc.w $ff4e
dc.w $5543
dc.w $7510
dc.w $5580
dc.w $bfc
dc.w $5581
dc.w $7500
dc.w $5582
dc.w $ff4f
dc.w $5583
dc.w $7510
dc.w $55c0
dc.w $bfd
dc.w $55c1
dc.w $7600
dc.w $55c2
dc.w $ff50
dc.w $55c3
dc.w $7610
dc.w $5600
dc.w $bfe
dc.w $5601
dc.w $7600
dc.w $5602
dc.w $ff51
dc.w $5603
dc.w $7610
dc.w $57c8
dc.w $bff
dc.w $57c9
dc.w $7700
dc.w $57ca
dc.w $ff52
dc.w $57cb
dc.w $7710
dc.w $5808
dc.w $ff23
dc.w $5809
dc.w $7710
dc.w $580a
dc.w $ff53
dc.w $580b
dc.w $7710
dc.w $5848
dc.w $ff24
dc.w $5849
dc.w $7410
dc.w $584a
dc.w $ff54
dc.w $584b
dc.w $8110
dc.w $5888
dc.w $ff25
dc.w $5889
dc.w $7810
dc.w $588a
dc.w $ff55
dc.w $588b
dc.w $8710
dc.w $58c8
dc.w $ff26
dc.w $58c9
dc.w $7810
dc.w $58ca
dc.w $ff56
dc.w $58cb
dc.w $8810
dc.w $5908
dc.w $ff27
dc.w $5909
dc.w $7810
dc.w $590a
dc.w $ff57
dc.w $590b
dc.w $8810
dc.w $57c4
dc.w $ff28
dc.w $57c5
dc.w $7910
dc.w $57c6
dc.w $ff58
dc.w $57c7
dc.w $8910
dc.w $5804
dc.w $ff29
dc.w $5805
dc.w $7910
dc.w $5806
dc.w $ff59
dc.w $5807
dc.w $8910
dc.w $5844
dc.w $ff2a
dc.w $5845
dc.w $7610
dc.w $5846
dc.w $ff5a
dc.w $5847
dc.w $8a10
dc.w $5884
dc.w $ff2b
dc.w $5885
dc.w $7a10
dc.w $5886
dc.w $ff5b
dc.w $5887
dc.w $8b10
dc.w $58c4
dc.w $ff2c
dc.w $58c5
dc.w $7b10
dc.w $58c6
dc.w $ff5c
dc.w $58c7
dc.w $8c10
dc.w $5904
dc.w $ff2d
dc.w $5905
dc.w $7b10
dc.w $5906
dc.w $ff5d
dc.w $5907
dc.w $8c10
