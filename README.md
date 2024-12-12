## build
```shell
zig build -Dtarget=riscv32-freestanding-gnuilp32 -Doptimize=ReleaseSmall
```
## run qemu
```shell
qemu-system-riscv32 -nographic -smp 1 -machine virt -bios none -kernel zig-out/bin/kernel -s
```
