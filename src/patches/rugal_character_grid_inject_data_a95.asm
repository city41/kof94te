;; this is not a standard static image
;; this is for injecting Rugal into the character grid sprites

;; this data forms word pairs that are <vram-address><vram-data>
;; so that the asm can just shoved in without thinking about it

dc.w $53ce
dc.w $b13
dc.w $53cf
dc.w $3000
dc.w $53d0
dc.w $b15
dc.w $53d1
dc.w $3100
dc.w $540e
dc.w $b14
dc.w $540f
dc.w $3000
dc.w $5410
dc.w $b16
dc.w $5411
dc.w $3100

