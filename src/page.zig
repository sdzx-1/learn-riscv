const std = @import("std");
const uart = @import("uart.zig");
const printf = uart.printf;

extern const TEXT_START: [*]const u8;
extern const TEXT_END: [*]const u8;

extern const DATA_START: [*]const u8;
extern const DATA_END: [*]const u8;

extern const RODATA_START: [*]const u8;
extern const RODATA_END: [*]const u8;

extern const BSS_START: [*]const u8;
extern const BSS_END: [*]const u8;

extern const HEAP_START: [*]u8;
extern const HEAP_SIZE: usize;

const PAGE_SIZE: usize = 4096;
const LENGTH_RAM = 128 * 1024 * 1024;

var _alloc_start: [*]u8 = @ptrFromInt(1);
var _alloc_end: [*]u8 = @ptrFromInt(1);

const Page = packed struct {
    taken: bool,
    last: bool,
    _: u6,

    pub fn clear(p: *Page) void {
        const v: *u8 = @ptrCast(p);
        v.* = 0;
    }

    pub fn is_free(p: *const Page) bool {
        return !(p.taken);
    }

    pub fn is_last(p: *const Page) bool {
        return p.last;
    }
};

// /*
//  *    ______________________________HEAP_SIZE_______________________________
//  *   /   ___num_reserved_pages___   ______________num_pages______________   \
//  *  /   /                        \ /                                     \   \
//  *  |---|<--Page-->|<--Page-->|...|<--Page-->|<--Page-->|......|<--Page-->|---|
//  *  A   A                         A                                       A   A
//  *  |   |                         |                                       |   |
//  *  |   |                         |                                       |   _memory_end
//  *  |   |                         |                                       |
//  *  |   _heap_start_aligned       _alloc_start                            _alloc_end
//  *  HEAP_START(BSS_END)
//  *
//  *  Note: _alloc_end may equal to _memory_end.
//  */
pub fn init() void {
    const _heap_start_aligned = std.mem.alignPointer(HEAP_START, PAGE_SIZE).?;
    const num_reserved_pages = LENGTH_RAM / (PAGE_SIZE * PAGE_SIZE);
    const _num_pages = (HEAP_SIZE - (@intFromPtr(_heap_start_aligned) - @intFromPtr(HEAP_START))) / PAGE_SIZE - num_reserved_pages;

    const pages: [*]Page = @ptrCast(HEAP_START);
    for (0.._num_pages) |i| {
        pages[i].clear();
    }

    _alloc_start = _heap_start_aligned + num_reserved_pages * PAGE_SIZE;
    _alloc_end = _alloc_start + (PAGE_SIZE * _num_pages);

    uart.puts("print memory info:\n");
    printf("_heap_start_aligned: {any}\n", .{_heap_start_aligned});
    printf("num_reserved_pages:  {any}\n", .{num_reserved_pages});
    printf("_num_pages:          {any}\n", .{_num_pages});
    printf("HEAP_SIZE:           OX{X}\n", .{HEAP_SIZE});
    printf("_alloc_start:        {any}\n", .{_alloc_start});
    printf("_alloc_end:          {any}\n", .{_alloc_end});
    printf("total pages:         {d}\n", .{HEAP_SIZE / PAGE_SIZE});
    printf("TEXT:   {any} -> {any}\n", .{ TEXT_START, TEXT_END });
    printf("RODATA: {any} -> {any}\n", .{ RODATA_START, RODATA_END });
    printf("DATA:   {any} -> {any}\n", .{ DATA_START, DATA_END });
    printf("BSS:    {any} -> {any}\n", .{ BSS_START, BSS_END });
}
