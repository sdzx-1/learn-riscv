const uart = @import("uart.zig");
const page = @import("page.zig");
const sched = @import("sched.zig");
const trap = @import("trap.zig");
const plic = @import("plic.zig");

export fn start_kernel() void {
    uart.init();
    uart.puts("Hello RVOS!\n");

    // page.init();

    trap.init();

    plic.init();

    sched.init();

    sched.os_main();

    sched.schedule();

    uart.puts("Would not go here!\n");

    while (true) {}
}
