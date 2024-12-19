# build
```shell
zig build -Doptimize=ReleaseSmall
```

# run 
```shell
➜  rvos git:(master) ✗ qemu-system-riscv32 -nographic -smp 1 -machine virt -bios none -kernel zig-out/bin/rvos.bin 
```

# link
《从头写一个RISC-V OS》课程配套的资源 [rvos](https://github.com/plctlab/riscv-operating-system-mooc.git)

完成章节： 00 ~ 08

目前由于未知bug原因，只能用ReleaseSmall编译的代码能正常运行！！

