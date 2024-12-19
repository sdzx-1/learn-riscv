const r = @import("riscv.zig");

pub fn spin_lock() u32 {
    r.w_mstatus(r.r_mstatus() & ~(r.MSTATUS_MIE));
    return 0;
}

pub fn spin_unlock() u32 {
    r.w_mstatus(r.r_mstatus() | r.MSTATUS_MIE);
    return 0;
}
