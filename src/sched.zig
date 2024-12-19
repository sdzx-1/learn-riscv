const uart = @import("uart.zig");
const trap = @import("trap.zig");
const riscv = @import("riscv.zig");
const timer = @import("timer.zig");
const lock = @import("lock.zig");
const std = @import("std");

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
    epc: u32,
};

extern fn switch_to(next: *context) callconv(.C) void;

const MAX_TASKS = 10;
const STACK_SIZE = 1024;
var task_stacks: [MAX_TASKS][STACK_SIZE]u8 align(16) = undefined;
var ctx_tasks: [MAX_TASKS]context = undefined;
var _top: usize = 0;
var _current: usize = 0;

fn w_mscratch(x: u32) void {
    asm volatile ("csrw mscratch, %[val]"
        :
        : [val] "r" (x),
    );
}

pub fn init() void {
    w_mscratch(0);
    riscv.w_mie(riscv.r_mie() | riscv.MIE_MSIE);
}

pub fn schedule() void {
    const next: *context = &ctx_tasks[_current];
    _current = (_current + 1) % _top;
    switch_to(next);
}

pub fn task_create(start_routin: *const fn () void) bool {
    if (_top < MAX_TASKS) {
        ctx_tasks[_top].sp = @intFromPtr(&task_stacks[_top]);
        ctx_tasks[_top].epc = @intFromPtr(start_routin);
        _top += 1;
        return true;
    } else {
        return false;
    }
}

pub fn task_yield() void {
    const id = riscv.r_mhartid();
    timer.CLINT_MSIP(id).* = 1;
}

fn task_delay(cot: usize) void {
    _ = cot;
    // var count = cot * 50000;
    // while (count != 0) {
    //     count -= 1;
    // }
    asm volatile ("wfi");
}

const DELAY = 1000;

pub fn user_task0() void {
    uart.puts("Task 0: Created!\n");

    task_yield();
    uart.puts("Task 0: I'm back!\n");
    while (true) {
        uart.puts("Task 0: Running...\n");
        task_delay(DELAY);
    }
}

pub fn user_task1() void {
    uart.puts("Task 1: Created!\n");
    while (true) {
        uart.puts("Task 1: Running...\n");
        task_delay(DELAY);
    }
}

pub fn os_main() void {
    _ = task_create(user_task0);
    _ = task_create(user_task1);
}
