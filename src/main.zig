comptime {
    asm (
        \\       .text
        \\       .global _start
        \\_start:
        \\       li x5, 0
        \\       li x6, 5
        \\loop: 
        \\       addi x5, x5, 1
        \\       bne x5, x6, loop
        \\       j main 
    );
}

export fn main() void {
    while (true) {}
}
