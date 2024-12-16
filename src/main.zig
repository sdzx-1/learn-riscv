comptime {
    asm (
        \\       .text
        \\       .global _start
        \\_start:
        \\       li x6, 3
        \\       li x7, 2 
        \\       sub x5, x6, x7
        \\
        \\loop:
        \\       j loop 
        \\      .end
    );
}

export fn main() void {
    while (true) {}
}

// opcode 7
// OP  [6:5] [4:2] [1:0]
// ADD 01    100   11

// R-type Register 3   rs2 sr2 rd
// I-type Immediate
// S-type Store
// B-type Branch
// U-type Upper
// J-type Jump

//          x9   x10       x11                 ADD
// 0000000 01001 01010 000 01011   0110011
// ADD x11, x10, x9
