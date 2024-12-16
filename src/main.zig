comptime {
    asm (
        \\       .text
        \\       .global _start
        \\_start:
        \\       li x5, 0x80
        \\       addi x5, x0, 0x80
        \\       
        \\       li x6, 0x12345001
        \\        
        \\       lui x6, 0x12345
        \\       addi x6, x6, 0x001
        \\
        \\       li x7, 0x12345FFF
        \\       lui x7, 0x12346
        \\       addi x7, x7, -1
        \\
        \\loop:
        \\       j loop 
        \\      .end
    );
}

export fn main() void {
    while (true) {}
}
