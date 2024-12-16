comptime {
    asm (
        \\       .text
        \\       .global _start
        \\_start:
        \\       li x6, 1
        \\       li x7, 2 
        \\       add x5, x6, x7
        \\       j main
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
