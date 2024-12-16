opcode 7
OP  [6:5] [4:2] [1:0]
ADD 01    100   11

R-type Register 3   rs2 sr2 rd
I-type Immediate
S-type Store
B-type Branch
U-type Upper
J-type Jump

         x9   x10       x11                 ADD
0000000 01001 01010 000 01011   0110011
ADD x11, x10, x9
---------------
NEG RD, RS    -- SUB RD, x0, RS
MV  RD, RS    -- ADDI RD, RS, 0
NOP           -- ADDI x0, x0, 0
------------
LUI (Load Upper Immediate) 
lui x5, 0x12345
------------
LI (Load Immediate)