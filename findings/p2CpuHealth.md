# P2 CPU Health

After running MAME cheat,

| address | start | current |
| ------- | ----- | ------- |
| 108421  | CF    | 0E      |
| 108423  | CF    | 0E      |
| 10844d  | CF    | 0E      |
| 10882E  | 60    | 21      |

108424 is the dizzy meter. Forcing it to zero with Lua causes the CPU to be in constant dizzy

108422 is the life bar, but I think just it's visual state. Setting it to zero empties it, but the character still seems to have full health

108420 is the health. Setting it to zero with Lua does not instantly kill the character at match start. You still need to hit them. So the game just doesn't check for zero until a hit has landed. If the CPU beats player 1, the result is a double KO
