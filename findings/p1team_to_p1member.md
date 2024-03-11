# P1 TEAM to P1MEMBER

`P1  TEAM` writes the team members here

P1 TEAM (626:write) 108234 : f
P1 TEAM (626:write) 108236 : 10
P1 TEAM (626:write) 108236 : 11

Probably after pressing A to choose a team

Pretty sure P1MEMBER does not touch character sprites, as the game assumes the character sprites loaded in `P1  TEAM` still apply in `P1MEMBER`, and well, that makes sense. So in other words, having `P1  TEAM` instead write 0x6, 0x10, 0x11 won't suddently show Kyo replacing Terry during order select
