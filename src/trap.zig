const riscv = @import("riscv.zig");
const uart = @import("uart.zig");

extern fn trap_vector() void;

pub fn init() void {
    riscv.w_mtvec(@intFromPtr(&trap_vector));
}

export fn trap_handler(epc: u32, cause: u32) callconv(.c) u32 {
    var return_pc: u32 = epc;
    _ = &return_pc;
    _ = cause;
    // cause_code = cause & riscv.MCAUSE_MASK_ECODE;
    uart.puts("trap happened");
    while (true) {}

    return return_pc;
}
