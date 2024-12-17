pub fn r_tp() u32 {
    var x: u32 = undefined;
    asm volatile ("mv %[res], tp"
        : [res] "=r" (x),
    );
    return x;
}
