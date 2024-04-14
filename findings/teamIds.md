# Team IDs

The game uses these IDs for teams. Sometimes it uses the team leader to indicate a team too.

It sometimes uses these values either as distinct bytes or as bits in a single byte.

| bit | byte value | team    |
| --- | ---------- | ------- |
| 0   | 1          | Brazil  |
| 1   | 2          | China   |
| 2   | 4          | Japan   |
| 3   | 8          | USA     |
| 4   | 10         | Korea   |
| 5   | 20         | Italy   |
| 6   | 40         | Mexico  |
| 7   | 80         | England |
| 8   |            | Rugal   |

"byte value" means that when these are used in bits, that is what the byte looks like. When used as bits they are stored in the same byte, so value 3 (bits 0 and 1) means "Brazil and China"
