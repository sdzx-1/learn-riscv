const std = @import("std");
const uptr: *UART = @ptrFromInt(0x1000_0000);

const UART = packed struct {

    // Receive Holding Register (read mode)
    // Transmit Holding Register (write mode)
    // LSB of Divisor Latch (write mode)
    RHR__THR__DLL: u8,

    // Interrupt Enable Register (write mode)
    // MSB of Divisor Latch (write mode)
    IER__DLM: u8,

    // FIFO Control Register (write mode)
    // Interrupt Status Register (read mode)
    FCR__ISR: u8,

    // Line Control Register
    LCR: u8,
    // Modem Control Register
    MCR: u8,
    // Line Status Register
    LSR: u8,
    // Modem Status Register
    MSR: u8,
    // ScratchPad Register
    SPR: u8,
};

// /*
//  * Reference
//  * [1]: TECHNICAL DATA ON 16550, http://byterunner.com/16550.html
//  */

// /*
//  * UART control registers map. see [1] "PROGRAMMING TABLE"
//  * note some are reused by multiple functions
//  * 0 (write mode): THR/DLL
//  * 1 (write mode): IER/DLM
//  */

// /*
//  * POWER UP DEFAULTS
//  * IER = 0: TX/RX holding register interrupts are both disabled
//  * ISR = 1: no interrupt penting
//  * LCR = 0
//  * MCR = 0
//  * LSR = 60 HEX
//  * MSR = BITS 0-3 = 0, BITS 4-7 = inputs
//  * FCR = 0
//  * TX = High
//  * OP1 = High
//  * OP2 = High
//  * RTS = High
//  * DTR = High
//  * RXRDY = High
//  * TXRDY = Low
//  * INT = Low
//  */

// /*
//  * LINE STATUS REGISTER (LSR)
//  * LSR BIT 0:
//  * 0 = no data in receive holding register or FIFO.
//  * 1 = data has been receive and saved in the receive holding register or FIFO.
//  * ......
//  * LSR BIT 5:
//  * 0 = transmit holding register is full. 16550 will not accept any data for transmission.
//  * 1 = transmitter hold register (or FIFO) is empty. CPU can load the next character.
//  * ......
//  */
const LSR_RX_READY: u8 = (1 << 0);
const LSR_TX_IDLE: u8 = (1 << 5);

pub fn uart_init() void {

    // /* disable interrupts. */
    uptr.IER__DLM = 0x00;

    // v*
    //  * Setting baud rate. Just a demo here if we care about the divisor,
    //  * but for our purpose [QEMU-virt], this doesn't really do anything.
    //  *
    //  * Notice that the divisor register DLL (divisor latch least) and DLM (divisor
    //  * latch most) have the same base address as the receiver/transmitter and the
    //  * interrupt enable register. To change what the base address points to, we
    //  * open the "divisor latch" by writing 1 into the Divisor Latch Access Bit
    //  * (DLAB), which is bit index 7 of the Line Control Register (LCR).
    //  *
    //  * Regarding the baud rate value, see [1] "BAUD RATE GENERATOR PROGRAMMING TABLE".
    //  * We use 38.4K when 1.8432 MHZ crystal, so the corresponding value is 3.
    //  * And due to the divisor register is two bytes (16 bits), so we need to
    //  * split the value of 3(0x0003) into two bytes, DLL stores the low byte,
    //  * DLM stores the high byte.
    //  *
    uptr.LCR = uptr.LCR | (1 << 7);
    uptr.RHR__THR__DLL = 0x03;
    uptr.IER__DLM = 0x00;

    // /*
    //  * Continue setting the asynchronous data communication format.
    //  * - number of the word length: 8 bits
    //  * - number of stop bits：1 bit when word length is 8 bits
    //  * - no parity
    //  * - no break control
    //  * - disabled baud latch
    //  */
    uptr.LCR = 0 | (3 << 0);
}
pub fn uart_putc(ch: u8) void {
    while ((uptr.LSR & LSR_TX_IDLE) == 0) {}
    uptr.RHR__THR__DLL = ch;
}

pub fn uart_puts(st: []const u8) void {
    for (st) |v| {
        uart_putc(v);
    }
}

pub fn printf(comptime fmst: []const u8, val: anytype) void {
    var buf: [500]u8 = undefined;
    _ = &buf;
    const res = std.fmt.bufPrint(&buf, fmst, val) catch "error!";
    uart_puts(res);
}
