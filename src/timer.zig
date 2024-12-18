const riscv = @import("riscv.zig");
const uart = @import("uart.zig");

const CLINT_BASE: u32 = 0x2000000;
// pub fn CLINT_MSIP(hartid: u32) *u64 {
//     return @ptrFromInt(CLINT_BASE + 4 * (hartid));
// }

pub fn CLINT_MTIMECMP(hartid: u32) *u64 {
    return @ptrFromInt(CLINT_BASE + 0x4000 + 8 * (hartid));
}

const CLINT_MTIME: *u64 = @ptrFromInt(CLINT_BASE + 0xBFF8); // cycles since boot.

// // /* 10000000 ticks per-second */
const CLINT_TIMEBASE_FREQ: u64 = 10000000;
const TIMER_INTERVAL = CLINT_TIMEBASE_FREQ;

pub fn load(interval: u64) void {
    const id = riscv.r_mhartid();
    CLINT_MTIMECMP(id).* = CLINT_MTIME.* + interval;
}

pub fn init() void {
    load(TIMER_INTERVAL);

    riscv.w_mie(riscv.r_mie() | riscv.MIE_MTIE);
    riscv.w_mstatus(riscv.r_mstatus() | riscv.MSTATUS_MIE);
}

var _tick: u32 = 0;

pub fn handler() void {
    _tick += 1;
    uart.printf("tick: {d}\n", .{_tick});

    load(TIMER_INTERVAL);
}
