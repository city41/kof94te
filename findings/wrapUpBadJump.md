375BE jsr (A0) and A0 = 4eb82582

375ba

it's because D0 is 8, and it goes past the little list at 375f0

with 5, we get 6 8's, and a hang

## with 4, we get 6 8's, and a hang

d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0008, a0: 375E4
a0: 37646
d0: F0008, a0: 375E4
a0: 37646
d0: F0008, a0: 375E4
a0: 37646
d0: F0008, a0: 375E4
a0: 37646
d0: F0008, a0: 375E4
a0: 37646
d0: F0008, a0: 375F0
a0: 4EB82582

this is because

0375AE: btst #$6, ($7e6,A5)
0375B4: beq $375ba
0375B6: lea ($38,PC) ; ($375f0), A0
0375BA: movea.l (A0,D0.w), A0

it normally skips the lea at 375b6, but didn't because 1087e6 is not what it expects

## with 3, we get 5 8's, and no hang

d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0004, a0: 375E4
a0: 3761A
d0: F0008, a0: 375E4
a0: 37646
d0: F0008, a0: 375E4
a0: 37646
d0: F0008, a0: 375E4
a0: 37646
d0: F0008, a0: 375E4
a0: 37646
d0: F0008, a0: 375E4
a0: 37646

## 1087a6

### with countdown set to 3

> wp 1087e6,1,w,, { printf "%x: %x at %x",wpaddr,wpdata,pc; g }
> Watchpoint 1 set
> go
> 1087E6: 0 at C05550
> 1087E6: 0 at 26C8
> 1087E6: 0 at 324C2
> 1087E6: 0 at 26C8
> 1087E6: 0 at 324C2
> 1087E6: 0 at 3271E
> 1087E6: 3 at 37010
> 1087E6: 2 at 3783E
> 1087E6: 6 at 37844
> 1087E6: 46 at 3767E
> 1087E6: 44 at 3783E
> 1087E6: 4C at 37844
> 1087E6: 4F at 37EBC

### with countdown set to 4

> wp 1087e6,1,w,, { printf "%x: %x at %x",wpaddr,wpdata,pc; g }
> Watchpoint 1 set
> go
> 1087E6: 0 at C05550
> 1087E6: 0 at 26C8
> 1087E6: 0 at 324C2
> 1087E6: 0 at 26C8
> 1087E6: 0 at 324C2
> 1087E6: 0 at 3271E
> 1087E6: 3 at 37010
> 1087E6: 2 at 3783E
> 1087E6: 6 at 37844
> 1087E6: 46 at 3767E

### with no countdown, just purposeful hang

MAME debugger version 0.242 (unknown)
Currently targeting kof94 (The King of Fighters '94 (NGM-055 ~ NGH-055))

> wp 1087e6,1,w,, { printf "%x: %x at %x",wpaddr,wpdata,pc; g }
> Watchpoint 1 set
> go
> 1087E6: 0 at C05550
> 1087E6: 0 at 26C8
> 1087E6: 0 at 324C2
> 1087E6: 0 at 26C8
> 1087E6: 0 at 324C2
> 1087E6: 0 at 3271E
> 1087E6: 3 at 37010
> 1087E6: 2 at 3783E
> 1087E6: 6 at 37844
> 1087E6: 46 at 3767E
