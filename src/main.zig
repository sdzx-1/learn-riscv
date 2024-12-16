comptime {
    asm (
        \\       .text
        \\       .global _start
        \\_start:
        \\       la sp, stack_end
        \\       call main 
        \\
        \\stack_start:
        \\       .rept 100
        \\       .word 0
        \\       .endr
        \\stack_end:
        \\       .end
    );
}

export fn main() void {
    while (true) {}
}
