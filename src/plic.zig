const riscv = @import("riscv.zig");

pub const UART0_IRQ = 10;

// pub fn @ptrFromInt(v: u32) *u8 {
// return @ptrFromInt(v);
// }
//
const PLIC_BASE: u32 = 0x0c000000;

pub fn PLIC_PRIORITY(id: u32) *u32 {
    return @ptrFromInt(PLIC_BASE + (id) * 4);
}
pub fn PLIC_PENDING(id: u32) *u32 {
    return @ptrFromInt(PLIC_BASE + 0x1000 + ((id) / 32) * 4);
}
pub fn PLIC_MENABLE(hart: u32, id: u32) *u32 {
    return @ptrFromInt(PLIC_BASE + 0x2000 + (hart) * 0x80 + ((id) / 32) * 4);
}
pub fn PLIC_MTHRESHOLD(hart: u32) *u32 {
    return @ptrFromInt(PLIC_BASE + 0x200000 + (hart) * 0x1000);
}
pub fn PLIC_MCLAIM(hart: u32) *u32 {
    return @ptrFromInt(PLIC_BASE + 0x200004 + (hart) * 0x1000);
}
pub fn PLIC_MCOMPLETE(hart: u32) *u32 {
    return @ptrFromInt(PLIC_BASE + 0x200004 + (hart) * 0x1000);
}

pub fn init() void {
    const hart: u32 = riscv.r_tp();

    PLIC_PRIORITY(UART0_IRQ).* = 1;
    PLIC_MENABLE(hart, UART0_IRQ).* = 1 << (UART0_IRQ % 32);
    PLIC_MTHRESHOLD(hart).* = 0;

    riscv.w_mie(riscv.r_mie() | riscv.MIE_MEIE);
    riscv.w_mstatus(riscv.r_mstatus() | riscv.MSTATUS_MIE);
}

pub fn claim() u32 {
    const hart = riscv.r_tp();
    const irq = PLIC_MCLAIM(hart);
    return irq.*;
}

pub fn complete(irq: u32) void {
    const hart = riscv.r_tp();
    PLIC_MCOMPLETE(hart).* = irq;
}
