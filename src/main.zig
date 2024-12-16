comptime {
    asm (
        \\       .text
        \\       .global _start
        \\_start:
        \\       j main 
    );
}

var a: i32 = 1;
var b: i32 = 2;

pub fn sum() void {
    a = a + b;
}

export fn main() void {
    sum();
    while (true) {}
}
