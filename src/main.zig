comptime {
    asm (
        \\       .text
        \\       .global _start
        \\_start:
        \\        la x5, _start
        \\        jr x5
        \\
        \\loop:
        \\       j loop 
        \\      .end
    );
}

export fn main() void {
    while (true) {}
}
