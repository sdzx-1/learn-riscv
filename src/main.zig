comptime {
    asm (
        \\       .text
        \\       .global _start
        \\_start:
        \\       j main 
    );
}

export fn main() void {
    while (true) {}
}
