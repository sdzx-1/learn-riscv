const riscv = @import("riscv.zig");
const uart = @import("uart.zig");
const plic = @import("plic.zig");
const timer = @import("timer.zig");
const sched = @import("sched.zig");

extern fn trap_vector() void;

pub fn init() void {
    riscv.w_mtvec(@intFromPtr(&trap_vector));
}

pub fn external_interrupt_handler() void {
    const irq = plic.claim();

    if (irq == plic.UART0_IRQ) {
        uart.isr();
    } else if (irq > 0) {
        uart.printf("unexpect interrupt irq = {d}\n", .{irq});
    }

    if (irq > 0) {
        plic.complete(irq);
    }
}

export fn trap_handler(epc: u32, cause: u32) callconv(.c) u32 {
    var return_pc: u32 = epc;
    _ = &return_pc;
    const cause_code = cause & riscv.MCAUSE_MASK_ECODE;

    if ((cause & riscv.MCAUSE_MASK_INTERRUPT) > 0) {
        switch (cause_code) {
            3 => {
                uart.puts("software interruption!\n");
                timer.CLINT_MSIP(riscv.r_mhartid()).* = 0;
                sched.schedule();
            },
            7 => {
                uart.puts("timer interruption!\n");
                timer.handler();
            },
            11 => {
                uart.puts("external interruption!\n");
                external_interrupt_handler();
            },
            else => uart.printf(
                "Unknown async exception! Code = {d}\n",
                .{cause_code},
            ),
        }
    } else {
        uart.printf("Sync exceptions! Code = {d}\n", .{cause_code});
        while (true) {}
        // return_pc += 4;
    }

    return return_pc;
}

pub fn t_test() void {
    const ptr: *u8 = @ptrFromInt(10);
    ptr.* = 1;

    uart.puts("Yeah! I'm return back from trap!\n");
}
