# Language

The byte at 108836 is set by the game early at startup and indicates the region/language the game is running in.

| value | description        |
| ----- | ------------------ |
| 0     | Japanese/JA        |
| 1     | English/USA        |
| 2     | English/Euro       |
| 3     | Spanish/any region |

Japanese is only available if the region is Japanese

English/Spanish are available in US/Euro regions, controlled by a soft dip.

You can also set it to Spanish on a Japanese region system using the soft dip
