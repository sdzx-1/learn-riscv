const u = @import("uart.zig");

comptime {
    asm (
        \\       .equ STACK_SIZE, 1024
        \\       .global _start
        \\       .text
        \\
        \\_start:
        \\       csrr t0, mhartid
        \\       mv tp, t0      # ???
        \\       bnez t0, park
        \\       slli t0, t0, 10
        \\       la sp, stacks + STACK_SIZE 
        \\       add sp, sp, t0
        \\       j start_kernel
        \\
        \\park: 
        \\       wfi
        \\       j park
        \\
        \\
        \\.balign 16
        \\stacks: 
        \\    .skip STACK_SIZE * 8 
        \\    .end
    );
}

export fn start_kernel() void {
    u.uart_init();
    u.uart_puts("Hello RVOS");
    while (true) {}
}

// export fn sum(a: i32, b: i32) i32 {
//     var c: i32 = 0;
//     asm volatile ("add %[sum], %[add1], %[add2]"
//         : [sum] "=r" (c),
//         : [add1] "r" (a),
//           [add2] "r" (b),
//     );
//     return c;
// }
