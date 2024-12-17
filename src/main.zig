const uart = @import("uart.zig");
const page = @import("page.zig");

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
        \\
        \\# Set all bytes in the BSS section to zero.
        \\
        \\       la a0, _bss_start
        \\       la a1, _bss_end
        \\       bgeu a0, a1, 2f
        \\1:
        \\       sw zero, (a0)
        \\       addi a0, a0, 4
        \\       bltu a0, a1, 1b
        \\
        \\2:
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
    uart.init();
    uart.puts("Hello RVOS!\n");
    page.init();

    const p = page.alloc(2).?;
    uart.printf("p  = {any}\n", .{p});

    const p2 = page.alloc(7).?;
    uart.printf("p2 = {any}\n", .{p2});
    page.free(p2);

    const p3 = page.alloc(4).?;
    uart.printf("p3 = {any}\n", .{p3});

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
