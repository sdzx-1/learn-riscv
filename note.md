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
-----------
AUIPC RD, IMM
auipc x5, 0x12345   x5 = 0x12345 << 12 + pc

LA (Load Address)
la x5, foo
----------
AND 
OR
XOR
ANDI
ORI
XORI

NOT   NOT RD, RS      XORI RD, RS, -1
-----------
Shifting Instructions

SLL   Shift Left Logical
SRL   Shift Right Logical
SLLI  Shift Left Logical Immediate
SRLI  Shift Right Logical Immediate

SRA   Shift Right Arithmetic
SRAI
-------------
Load and Store Instructions

LB

lb x5, 40(x6)

LBU

lb x5, 40(x6)

LH

LHU

LW

SB
SH
SW
----------------
Conditional Branch Instructions
BEQ
BNE
BLT
BLTU
BGE
BGEU
-------------
BLE
BLEU
BGT
BGTU
------------
BEQ
BNE
BLT
BLTU
BGE
BGEU
----------
JAL (Jump And Link)
jal x1, label

JALR (Jump And Link Register)

J
JAL x0, OFFSET
JR
JALR x0, 0(RS)
--------------------
x0               zero
x1               ra
x2               sp
x5 ~ x7          t0 ~ t2
x28 ~ x31        t3 ~ t6
x8, x9           s0, s1
x18 ~ x27        s2 ~ s11
x10, x11         a0, a1
x12 ~ x17        a2 ~ a7
-----------------------
jal offset -- jal x1, offset
jalr rs    -- jalr x1, 0(rs)
j offset   -- jal x0, offset
jr rs      -- jalr x0, 0(rs)
call offset -- 
tail offset
ret 
-----------------------
CSRRW (Atomic Read/Wirte CSR)

csrw csr, rs

CSRRS (Atomic Read and Set Bits in CSR)

csrr rd, csr

mhartid
-------------------
mtvec (Machine Trap-Vector Base-Address)

30              2
BASE(WARL)  MODE(WARL)

MODE
Direct   00
Vectored 01
-----------------------
mepc (Machine Exception Program Counter)

mret
mcause (Machine Cause)
1               31
Interrupt       Exception Code(WLRL)

1 Interrupt
0 Exception
mtval(Machine Trap Value)

mstatus(Machine Status)

xIE - MIE - 3 Interrupt Enable
xPIE - MPIE - 7 Before Interrupt Enable val
xPP - MPP - 12,11 Before Intrrupt, M - 11, S - 01, U - 00

-----------------------------
interrupt

software
time
externel

mie (Machine Interrupt Enable) -- write

mip (Machine Interrupt Pending) -- read

-----------------------------
externel

PLIC (Platform-Level Interrupt Controller)

Interrupt Source 

Priority     BASE + (interrupt-id) * 4
7  0, 1 - 7

UARTO_IRQ = 10

Pending      BASE + Ox1000 + (interrupt-id) / 32   2

Enable       BASE + 0x2000 + hart * 0x80           2

Threshold    BASE + 0x200000 + hart * 0x1000

Claim/Complete  BASE + 0x200004 + hart * 0x1000
-------------------------------
Core Local Interruptor

CLINT

mtime  (rtc real time counter)  BASE + 0xbff8
mtimecmp (timer compare register)   BASE + 0x4000 + hart * 8

MSIP  BASE + 4 * hart