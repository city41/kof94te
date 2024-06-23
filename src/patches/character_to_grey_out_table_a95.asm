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
dc.w $bae
dc.w $57c1
dc.w $4600
dc.w $57c2
dc.w $bde
dc.w $57c3
dc.w $4600
dc.w $5800
dc.w $baf
dc.w $5801
dc.w $4600
dc.w $5802
dc.w $bdf
dc.w $5803
dc.w $4600
dc.w $5840
dc.w $bb0
dc.w $5841
dc.w $4700
dc.w $5842
dc.w $be0
dc.w $5843
dc.w $4700
dc.w $5880
dc.w $bb1
dc.w $5881
dc.w $4700
dc.w $5882
dc.w $be1
dc.w $5883
dc.w $5800
dc.w $58c0
dc.w $bb2
dc.w $58c1
dc.w $4800
dc.w $58c2
dc.w $be2
dc.w $58c3
dc.w $5200
dc.w $5900
dc.w $bb3
dc.w $5901
dc.w $4200
dc.w $5902
dc.w $be3
dc.w $5903
dc.w $5800
dc.w $54c4
dc.w $bb4
dc.w $54c5
dc.w $4900
dc.w $54c6
dc.w $be4
dc.w $54c7
dc.w $4900
dc.w $5504
dc.w $bb5
dc.w $5505
dc.w $4900
dc.w $5506
dc.w $be5
dc.w $5507
dc.w $4900
dc.w $5544
dc.w $bb6
dc.w $5545
dc.w $4a00
dc.w $5546
dc.w $be6
dc.w $5547
dc.w $5900
dc.w $5584
dc.w $bb7
dc.w $5585
dc.w $4a00
dc.w $5586
dc.w $be7
dc.w $5587
dc.w $5900
dc.w $55c4
dc.w $bb8
dc.w $55c5
dc.w $4b00
dc.w $55c6
dc.w $be8
dc.w $55c7
dc.w $4b00
dc.w $5604
dc.w $bb9
dc.w $5605
dc.w $4b00
dc.w $5606
dc.w $be9
dc.w $5607
dc.w $4b00
dc.w $54c8
dc.w $bba
dc.w $54c9
dc.w $4c00
dc.w $54ca
dc.w $bea
dc.w $54cb
dc.w $4c00
dc.w $5508
dc.w $bbb
dc.w $5509
dc.w $4a00
dc.w $550a
dc.w $beb
dc.w $550b
dc.w $4c00
dc.w $5548
dc.w $bbc
dc.w $5549
dc.w $4d00
dc.w $554a
dc.w $bec
dc.w $554b
dc.w $4d00
dc.w $5588
dc.w $bbd
dc.w $5589
dc.w $4d00
dc.w $558a
dc.w $bed
dc.w $558b
dc.w $5700
dc.w $55c8
dc.w $bbe
dc.w $55c9
dc.w $4e00
dc.w $55ca
dc.w $bee
dc.w $55cb
dc.w $4e00
dc.w $5608
dc.w $bbf
dc.w $5609
dc.w $4e00
dc.w $560a
dc.w $bef
dc.w $560b
dc.w $4e00
dc.w $5640
dc.w $bc0
dc.w $5641
dc.w $4000
dc.w $5642
dc.w $bf0
dc.w $5643
dc.w $5a00
dc.w $5680
dc.w $bc1
dc.w $5681
dc.w $4300
dc.w $5682
dc.w $bf1
dc.w $5683
dc.w $5a00
dc.w $56c0
dc.w $bc2
dc.w $56c1
dc.w $4f00
dc.w $56c2
dc.w $bf2
dc.w $56c3
dc.w $4f00
dc.w $5700
dc.w $bc3
dc.w $5701
dc.w $4c00
dc.w $5702
dc.w $bf3
dc.w $5703
dc.w $4f00
dc.w $5740
dc.w $bc4
dc.w $5741
dc.w $5000
dc.w $5742
dc.w $bf4
dc.w $5743
dc.w $5000
dc.w $5780
dc.w $bc5
dc.w $5781
dc.w $5000
dc.w $5782
dc.w $bf5
dc.w $5783
dc.w $5000
dc.w $5644
dc.w $bc6
dc.w $5645
dc.w $4d00
dc.w $5646
dc.w $bf6
dc.w $5647
dc.w $4d00
dc.w $5684
dc.w $bc7
dc.w $5685
dc.w $4d00
dc.w $5686
dc.w $bf7
dc.w $5687
dc.w $5900
dc.w $56c4
dc.w $bc8
dc.w $56c5
dc.w $4800
dc.w $56c6
dc.w $bf8
dc.w $56c7
dc.w $5600
dc.w $5704
dc.w $bc9
dc.w $5705
dc.w $4800
dc.w $5706
dc.w $bf9
dc.w $5707
dc.w $5a00
dc.w $5744
dc.w $bca
dc.w $5745
dc.w $5100
dc.w $5746
dc.w $bfa
dc.w $5747
dc.w $5b00
dc.w $5784
dc.w $bcb
dc.w $5785
dc.w $4e00
dc.w $5786
dc.w $bfb
dc.w $5787
dc.w $4600
dc.w $54c0
dc.w $bcc
dc.w $54c1
dc.w $5100
dc.w $54c2
dc.w $bfc
dc.w $54c3
dc.w $5c00
dc.w $5500
dc.w $bcd
dc.w $5501
dc.w $5200
dc.w $5502
dc.w $bfd
dc.w $5503
dc.w $5c00
dc.w $5540
dc.w $bce
dc.w $5541
dc.w $5300
dc.w $5542
dc.w $bfe
dc.w $5543
dc.w $5300
dc.w $5580
dc.w $bcf
dc.w $5581
dc.w $5300
dc.w $5582
dc.w $bff
dc.w $5583
dc.w $5300
dc.w $55c0
dc.w $bd0
dc.w $55c1
dc.w $5400
dc.w $55c2
dc.w $ff23
dc.w $55c3
dc.w $5410
dc.w $5600
dc.w $bd1
dc.w $5601
dc.w $5400
dc.w $5602
dc.w $ff24
dc.w $5603
dc.w $5410
dc.w $57c8
dc.w $bd2
dc.w $57c9
dc.w $5300
dc.w $57ca
dc.w $ff25
dc.w $57cb
dc.w $5310
dc.w $5808
dc.w $bd3
dc.w $5809
dc.w $5300
dc.w $580a
dc.w $ff26
dc.w $580b
dc.w $5d10
dc.w $5848
dc.w $bd4
dc.w $5849
dc.w $4f00
dc.w $584a
dc.w $ff27
dc.w $584b
dc.w $5d10
dc.w $5888
dc.w $bd5
dc.w $5889
dc.w $4f00
dc.w $588a
dc.w $ff28
dc.w $588b
dc.w $4f10
dc.w $58c8
dc.w $bd6
dc.w $58c9
dc.w $5500
dc.w $58ca
dc.w $ff29
dc.w $58cb
dc.w $5e10
dc.w $5908
dc.w $bd7
dc.w $5909
dc.w $5500
dc.w $590a
dc.w $ff2a
dc.w $590b
dc.w $5e10
dc.w $57c4
dc.w $bd8
dc.w $57c5
dc.w $4d00
dc.w $57c6
dc.w $ff2b
dc.w $57c7
dc.w $5510
dc.w $5804
dc.w $bd9
dc.w $5805
dc.w $5500
dc.w $5806
dc.w $ff2c
dc.w $5807
dc.w $5f10
dc.w $5844
dc.w $bda
dc.w $5845
dc.w $5600
dc.w $5846
dc.w $ff2d
dc.w $5847
dc.w $5f10
dc.w $5884
dc.w $bdb
dc.w $5885
dc.w $5600
dc.w $5886
dc.w $ff2e
dc.w $5887
dc.w $6010
dc.w $58c4
dc.w $bdc
dc.w $58c5
dc.w $5700
dc.w $58c6
dc.w $ff2f
dc.w $58c7
dc.w $5710
dc.w $5904
dc.w $bdd
dc.w $5905
dc.w $5700
dc.w $5906
dc.w $ff30
dc.w $5907
dc.w $5710
