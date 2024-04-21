;; the grey scb1 vramaddr|vramrw word pairs
;; the data from this was calculated in sromCromPreEmit.ts
;; the data is in team id order (so Brazil is first)
;; each team has 24 word pairs
;; each pair is [vramaddr]|[vramrw]
;; this is scb1 data that changes the tile and palette
;; for a team in the character grid
;; greyOutDefeatedTeams.asm largely just blindly writes
;; this data for any team that has been defeated, turning them grey
dc.w $58c0
dc.w $bad
dc.w $58c1
dc.w $3400
dc.w $58c2
dc.w $bdd
dc.w $58c3
dc.w $3400
dc.w $5900
dc.w $bae
dc.w $5901
dc.w $3400
dc.w $5902
dc.w $bde
dc.w $5903
dc.w $3400
dc.w $5940
dc.w $baf
dc.w $5941
dc.w $3500
dc.w $5942
dc.w $bdf
dc.w $5943
dc.w $3500
dc.w $5980
dc.w $bb0
dc.w $5981
dc.w $3500
dc.w $5982
dc.w $be0
dc.w $5983
dc.w $4600
dc.w $59c0
dc.w $bb1
dc.w $59c1
dc.w $3600
dc.w $59c2
dc.w $be1
dc.w $59c3
dc.w $4000
dc.w $5a00
dc.w $bb2
dc.w $5a01
dc.w $3300
dc.w $5a02
dc.w $be2
dc.w $5a03
dc.w $4600
dc.w $55c4
dc.w $bb3
dc.w $55c5
dc.w $3700
dc.w $55c6
dc.w $be3
dc.w $55c7
dc.w $3700
dc.w $5604
dc.w $bb4
dc.w $5605
dc.w $3700
dc.w $5606
dc.w $be4
dc.w $5607
dc.w $3700
dc.w $5644
dc.w $bb5
dc.w $5645
dc.w $3800
dc.w $5646
dc.w $be5
dc.w $5647
dc.w $4700
dc.w $5684
dc.w $bb6
dc.w $5685
dc.w $3800
dc.w $5686
dc.w $be6
dc.w $5687
dc.w $4700
dc.w $56c4
dc.w $bb7
dc.w $56c5
dc.w $3900
dc.w $56c6
dc.w $be7
dc.w $56c7
dc.w $3900
dc.w $5704
dc.w $bb8
dc.w $5705
dc.w $3900
dc.w $5706
dc.w $be8
dc.w $5707
dc.w $3900
dc.w $55c8
dc.w $bb9
dc.w $55c9
dc.w $3a00
dc.w $55ca
dc.w $be9
dc.w $55cb
dc.w $3a00
dc.w $5608
dc.w $bba
dc.w $5609
dc.w $3800
dc.w $560a
dc.w $bea
dc.w $560b
dc.w $3a00
dc.w $5648
dc.w $bbb
dc.w $5649
dc.w $3b00
dc.w $564a
dc.w $beb
dc.w $564b
dc.w $3b00
dc.w $5688
dc.w $bbc
dc.w $5689
dc.w $3b00
dc.w $568a
dc.w $bec
dc.w $568b
dc.w $4500
dc.w $56c8
dc.w $bbd
dc.w $56c9
dc.w $3c00
dc.w $56ca
dc.w $bed
dc.w $56cb
dc.w $3c00
dc.w $5708
dc.w $bbe
dc.w $5709
dc.w $3c00
dc.w $570a
dc.w $bee
dc.w $570b
dc.w $3c00
dc.w $5740
dc.w $bbf
dc.w $5741
dc.w $3200
dc.w $5742
dc.w $bef
dc.w $5743
dc.w $4800
dc.w $5780
dc.w $bc0
dc.w $5781
dc.w $3300
dc.w $5782
dc.w $bf0
dc.w $5783
dc.w $4800
dc.w $57c0
dc.w $bc1
dc.w $57c1
dc.w $3d00
dc.w $57c2
dc.w $bf1
dc.w $57c3
dc.w $3d00
dc.w $5800
dc.w $bc2
dc.w $5801
dc.w $3a00
dc.w $5802
dc.w $bf2
dc.w $5803
dc.w $3d00
dc.w $5840
dc.w $bc3
dc.w $5841
dc.w $3e00
dc.w $5842
dc.w $bf3
dc.w $5843
dc.w $3e00
dc.w $5880
dc.w $bc4
dc.w $5881
dc.w $3e00
dc.w $5882
dc.w $bf4
dc.w $5883
dc.w $3e00
dc.w $5744
dc.w $bc5
dc.w $5745
dc.w $3b00
dc.w $5746
dc.w $bf5
dc.w $5747
dc.w $3b00
dc.w $5784
dc.w $bc6
dc.w $5785
dc.w $3b00
dc.w $5786
dc.w $bf6
dc.w $5787
dc.w $4700
dc.w $57c4
dc.w $bc7
dc.w $57c5
dc.w $3600
dc.w $57c6
dc.w $bf7
dc.w $57c7
dc.w $4400
dc.w $5804
dc.w $bc8
dc.w $5805
dc.w $3600
dc.w $5806
dc.w $bf8
dc.w $5807
dc.w $4800
dc.w $5844
dc.w $bc9
dc.w $5845
dc.w $3f00
dc.w $5846
dc.w $bf9
dc.w $5847
dc.w $4900
dc.w $5884
dc.w $bca
dc.w $5885
dc.w $3c00
dc.w $5886
dc.w $bfa
dc.w $5887
dc.w $3400
dc.w $55c0
dc.w $bcb
dc.w $55c1
dc.w $3f00
dc.w $55c2
dc.w $bfb
dc.w $55c3
dc.w $4a00
dc.w $5600
dc.w $bcc
dc.w $5601
dc.w $4000
dc.w $5602
dc.w $bfc
dc.w $5603
dc.w $4a00
dc.w $5640
dc.w $bcd
dc.w $5641
dc.w $4100
dc.w $5642
dc.w $bfd
dc.w $5643
dc.w $4100
dc.w $5680
dc.w $bce
dc.w $5681
dc.w $4100
dc.w $5682
dc.w $bfe
dc.w $5683
dc.w $4100
dc.w $56c0
dc.w $bcf
dc.w $56c1
dc.w $4200
dc.w $56c2
dc.w $bff
dc.w $56c3
dc.w $4200
dc.w $5700
dc.w $bd0
dc.w $5701
dc.w $4200
dc.w $5702
dc.w $ff23
dc.w $5703
dc.w $4210
dc.w $58c8
dc.w $bd1
dc.w $58c9
dc.w $4100
dc.w $58ca
dc.w $ff24
dc.w $58cb
dc.w $4110
dc.w $5908
dc.w $bd2
dc.w $5909
dc.w $4100
dc.w $590a
dc.w $ff25
dc.w $590b
dc.w $4b10
dc.w $5948
dc.w $bd3
dc.w $5949
dc.w $3d00
dc.w $594a
dc.w $ff26
dc.w $594b
dc.w $4b10
dc.w $5988
dc.w $bd4
dc.w $5989
dc.w $3d00
dc.w $598a
dc.w $ff27
dc.w $598b
dc.w $3d10
dc.w $59c8
dc.w $bd5
dc.w $59c9
dc.w $4300
dc.w $59ca
dc.w $ff28
dc.w $59cb
dc.w $4c10
dc.w $5a08
dc.w $bd6
dc.w $5a09
dc.w $4300
dc.w $5a0a
dc.w $ff29
dc.w $5a0b
dc.w $4c10
dc.w $58c4
dc.w $bd7
dc.w $58c5
dc.w $3b00
dc.w $58c6
dc.w $ff2a
dc.w $58c7
dc.w $4310
dc.w $5904
dc.w $bd8
dc.w $5905
dc.w $4300
dc.w $5906
dc.w $ff2b
dc.w $5907
dc.w $4d10
dc.w $5944
dc.w $bd9
dc.w $5945
dc.w $4400
dc.w $5946
dc.w $ff2c
dc.w $5947
dc.w $4d10
dc.w $5984
dc.w $bda
dc.w $5985
dc.w $4400
dc.w $5986
dc.w $ff2d
dc.w $5987
dc.w $4e10
dc.w $59c4
dc.w $bdb
dc.w $59c5
dc.w $4500
dc.w $59c6
dc.w $ff2e
dc.w $59c7
dc.w $4510
dc.w $5a04
dc.w $bdc
dc.w $5a05
dc.w $4500
dc.w $5a06
dc.w $ff2f
dc.w $5a07
dc.w $4510
