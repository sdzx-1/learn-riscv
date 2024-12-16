comptime {
    asm (
        \\       .text
        \\       .global _start
        \\_start:
        \\       j main 
    );
}

extern var k: i32;

export fn main() void {
    var i: i32 = 0;
    while (i < 5) {
        i += 1;
        k += i;
    }
}
