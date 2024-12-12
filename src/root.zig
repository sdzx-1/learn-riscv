const uart = @import("uart.zig");

export fn start_kernel() void {
    uart.uart_init();
    uart.uart_puts("Hello, RVOS!\n");

    while (true) {}
}
