;; this is not a standard static image
;; this is for injecting Rugal into the character grid sprites

;; this data forms word pairs that are <vram-address><vram-data>
;; so that the asm can just shoved in without thinking about it

dc.w $56cc
dc.w $b13
dc.w $56cd
dc.w $3800
dc.w $56ce
dc.w $b15
dc.w $56cf
dc.w $3800
dc.w $570c
dc.w $b14
dc.w $570d
dc.w $3800
dc.w $570e
dc.w $b16
dc.w $570f
dc.w $3800

