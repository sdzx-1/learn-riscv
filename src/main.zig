const uart = @import("uart.zig");
const page = @import("page.zig");
const sched = @import("sched.zig");

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

    sched.init();

    sched.os_main();

    sched.schedule();

    uart.puts("Would not go here!\n");

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
