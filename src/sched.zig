const uart = @import("uart.zig");

const context = extern struct {
    ra: u32,
    sp: u32,
    gp: u32,
    tp: u32,
    t0: u32,
    t1: u32,
    t2: u32,
    s0: u32,
    s1: u32,
    a0: u32,
    a1: u32,
    a2: u32,
    a3: u32,
    a4: u32,
    a5: u32,
    a6: u32,
    a7: u32,
    s2: u32,
    s3: u32,
    s4: u32,
    s5: u32,
    s6: u32,
    s7: u32,
    s8: u32,
    s9: u32,
    s10: u32,
    s11: u32,
    t3: u32,
    t4: u32,
    t5: u32,
    t6: u32,
};

extern fn switch_to(next: *context) void;

const STACK_SIZE = 1024;

var task_stack: [STACK_SIZE]u8 align(16) = undefined;
var ctx_task: context = undefined;

fn w_mscratch(x: u32) void {
    asm volatile ("csrw mscratch, %[val]"
        :
        : [val] "r" (x),
    );
}

pub fn init() void {
    w_mscratch(0);
    ctx_task.sp = @intFromPtr(&task_stack);
    ctx_task.ra = @intFromPtr(&user_task0);
}

pub fn schedule() void {
    switch_to(&ctx_task);
}

fn task_delay(cot: usize) void {
    var count = cot * 50000;
    while (count == 0) {
        count -= 1;
    }
}

fn user_task0() void {
    uart.puts("Task 0: Created!\n");
    while (true) {
        uart.puts("Task 0: Running...\n");
        task_delay(1000);
    }
}
