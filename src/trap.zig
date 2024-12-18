const riscv = @import("riscv.zig");
const uart = @import("uart.zig");

extern fn trap_vector() void;

pub fn init() void {
    riscv.w_mtvec(@intFromPtr(&trap_vector));
}

export fn trap_handler(epc: u32, cause: u32) callconv(.c) u32 {
    var return_pc: u32 = epc;
    _ = &return_pc;
    const cause_code = cause & riscv.MCAUSE_MASK_ECODE;

    if ((cause & riscv.MCAUSE_MASK_INTERRUPT) > 0) {
        uart.puts("Interrupt happened!");
    } else {
        uart.printf("Sync exceptions! Code = {d}\n", .{cause_code});
        // @panic("OOPS! What can I do!\n");
        return_pc += 4;
    }

    return return_pc;
}

pub fn t_test() void {
    const ptr: *u8 = @ptrFromInt(10);
    ptr.* = 1;

    uart.puts("Yeah! I'm return back from trap!\n");
}
