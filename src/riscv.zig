pub fn r_tp() u32 {
    var x: u32 = undefined;
    asm volatile ("mv %[res], tp"
        : [res] "=r" (x),
    );
    return x;
}

pub fn r_mhartid() u32 {
    var x: u32 = undefined;
    asm volatile ("csrr %[res], mhartid"
        : [res] "=r" (x),
    );
    return x;
}

const MSTATUS_MPP: u32 = (3 << 11);
const MSTATUS_SPP: u32 = (1 << 8);
const MSTATUS_MPIE: u32 = (1 << 7);
const MSTATUS_SPIE: u32 = (1 << 5);
const MSTATUS_UPIE: u32 = (1 << 4);
const MSTATUS_MIE: u32 = (1 << 3);
const MSTATUS_SIE: u32 = (1 << 1);
const MSTATUS_UIE: u32 = (1 << 0);

pub fn r_mstatus() u32 {
    var x: u32 = undefined;
    asm volatile ("csrr %[res], mstatus"
        : [res] "=r" (x),
    );
    return x;
}

pub fn w_mstatus(x: u32) void {
    asm volatile ("csrw mstatus, %[val]"
        :
        : [val] "r" (x),
    );
}

pub fn w_mepc(x: u32) void {
    asm volatile ("csrw mepc, %[val]"
        :
        : [val] "r" (x),
    );
}

pub fn r_mepc() u32 {
    var x: u32 = undefined;
    asm volatile ("csrr %[res], mepc"
        : [res] "=r" (x),
    );
    return x;
}

pub fn w_mscratch(x: u32) void {
    asm volatile ("csrw mscratch, %[val]"
        :
        : [val] "r" (x),
    );
}

pub fn w_mtvec(x: u32) void {
    asm volatile ("csrw mtvec, %[val]"
        :
        : [val] "r" (x),
    );
}

const MIE_MEIE: u32 = (1 << 11); // external
const MIE_MTIE: u32 = (1 << 7); // timer
const MIE_MSIE: u32 = (1 << 3); // software

pub fn r_mie() u32 {
    var x: u32 = undefined;
    asm volatile ("csrr %[res], mie"
        : [res] "=r" (x),
    );
    return x;
}

pub fn w_mie(x: u32) void {
    asm volatile ("csrw mie, %[val]"
        :
        : [val] "r" (x),
    );
}

pub const MCAUSE_MASK_INTERRUPT: u32 = 0x80000000;
pub const MCAUSE_MASK_ECODE: u32 = 0x7FFFFFFF;

pub fn r_mcause() u32 {
    var x: u32 = undefined;
    asm volatile ("csrr %[res], mcause"
        : [res] "=r" (x),
    );
    return x;
}
