;;; crom string
;;; source
; # 54 bytes of space
;  ¡MUCHO!n
;  ¡ERAN RICOS!e

;;; crom result
dc.w $0 ;  
dc.w $49e0 ; ¡
dc.w $4999 ; M
dc.w $49a1 ; U
dc.w $498f ; C
dc.w $4994 ; H
dc.w $499b ; O
dc.w $77 ; !
dc.w $d ; 

dc.w $0 ;  
dc.w $49e0 ; ¡
dc.w $4991 ; E
dc.w $499e ; R
dc.w $498d ; A
dc.w $499a ; N
dc.w $0 ;  
dc.w $499e ; R
dc.w $4995 ; I
dc.w $498f ; C
dc.w $499b ; O
dc.w $499f ; S
dc.w $77 ; !
dc.w $ffff ; e
