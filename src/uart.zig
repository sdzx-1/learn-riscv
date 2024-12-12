//#define UART0 0x10000000L
const UART0: u32 = 0x1000_0000;

fn UART_REG(reg: u32) u32 {
    return UART0 + reg;
}

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
const RHR: u32 = 0; // Receive Holding Register (read mode)
const THR: u32 = 0; // Transmit Holding Register (write mode)
const DLL: u32 = 0; // LSB of Divisor Latch (write mode)
const IER: u32 = 1; // Interrupt Enable Register (write mode)
const DLM: u32 = 1; // MSB of Divisor Latch (write mode)
const FCR: u32 = 2; // FIFO Control Register (write mode)
const ISR: u32 = 2; // Interrupt Status Register (read mode)
const LCR: u32 = 3; // Line Control Register
const MCR: u32 = 4; // Modem Control Register
const LSR: u32 = 5; // Line Status Register
const MSR: u32 = 6; // Modem Status Register
const SPR: u32 = 7; // ScratchPad Register

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

// #define uart_read_reg(reg) (*(UART_REG(reg)))
pub fn uart_read_reg(reg: u32) u8 {
    const i = UART_REG(reg);
    const ptr: *u8 = @ptrFromInt(i);
    return ptr.*;
}

// #define uart_write_reg(reg, v) (*(UART_REG(reg)) = (v))
pub fn uart_write_reg(reg: u32, v: u8) void {
    const i = UART_REG(reg);
    const ptr: *u8 = @ptrFromInt(i);
    ptr.* = v;
}

pub fn uart_init() void {

    // 	/* disable interrupts. */
    uart_write_reg(IER, 0x00);

    // 	/*
    // 	 * Setting baud rate. Just a demo here if we care about the divisor,
    // 	 * but for our purpose [QEMU-virt], this doesn't really do anything.
    // 	 *
    // 	 * Notice that the divisor register DLL (divisor latch least) and DLM (divisor
    // 	 * latch most) have the same base address as the receiver/transmitter and the
    // 	 * interrupt enable register. To change what the base address points to, we
    // 	 * open the "divisor latch" by writing 1 into the Divisor Latch Access Bit
    // 	 * (DLAB), which is bit index 7 of the Line Control Register (LCR).
    // 	 *
    // 	 * Regarding the baud rate value, see [1] "BAUD RATE GENERATOR PROGRAMMING TABLE".
    // 	 * We use 38.4K when 1.8432 MHZ crystal, so the corresponding value is 3.
    // 	 * And due to the divisor register is two bytes (16 bits), so we need to
    // 	 * split the value of 3(0x0003) into two bytes, DLL stores the low byte,
    // 	 * DLM stores the high byte.
    // 	 */
    const lcr = uart_read_reg(LCR);
    uart_write_reg(LCR, lcr | (1 << 7));
    uart_write_reg(DLL, 0x03);
    uart_write_reg(DLM, 0x00);

    // 	/*
    // 	 * Continue setting the asynchronous data communication format.
    // 	 * - number of the word length: 8 bits
    // 	 * - number of stop bits：1 bit when word length is 8 bits
    // 	 * - no parity
    // 	 * - no break control
    // 	 * - disabled baud latch
    // 	 */
    // 	lcr = 0;
    uart_write_reg(LCR, 0 | (3 << 0));
}
pub fn uart_putc(ch: u8) void {
    while ((uart_read_reg(LSR) & LSR_TX_IDLE) == 0) {}
    uart_write_reg(THR, ch);
}

pub fn uart_puts(st: []const u8) void {
    for (st) |v| {
        uart_putc(v);
    }
}
