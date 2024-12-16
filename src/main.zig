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

var va: i32 = 1;
var vb: i32 = 2;

export fn main() void {
    va = sum(va, vb);
    while (true) {}
}

export fn sum(a: i32, b: i32) i32 {
    var c: i32 = 0;
    asm volatile ("add %[sum], %[add1], %[add2]"
        : [sum] "=r" (c),
        : [add1] "r" (a),
          [add2] "r" (b),
    );
    return c;
}
