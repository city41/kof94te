# Italian Flag Trace

Digging through oneframe.txt.resolve.txt to figure out how the Italian flag ends up on the screen

## routine 4860

This routine ultimatley puts the Italian Flag entity pointer into 102528.

A4 is one parameter, it is often 102500 but that alone does not lead to the flag. As the flag only gets loaded in team select.

### address registers

A0: loaded with 7bf48, hardcoded
A4: input parameter
A5: output parameter?
rest: unused

Where does A4 get loaded?

- 32b36: movea.l $102500, A4 | movea.l D7, A4
  - but D7 is loaded from A4....
