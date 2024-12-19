const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .riscv32,
            .os_tag = .freestanding,
            .abi = .gnuilp32,
            .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 },
            .cpu_features_add = std.Target.riscv.featureSet(&.{
                // rv32g
                std.Target.riscv.Feature.m,
                std.Target.riscv.Feature.a,
                std.Target.riscv.Feature.f,
                std.Target.riscv.Feature.d,
            }),
        },
    });
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "rvos.elf",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.addAssemblyFile(b.path("src/asm/start.S"));
    exe.addAssemblyFile(b.path("src/asm/mem.S"));
    exe.addAssemblyFile(b.path("src/asm/entry.S"));
    exe.setLinkerScript(b.path("os.ld"));

    const bin = b.addObjCopy(
        exe.getEmittedBin(),
        .{
            .format = .bin,
            // .only_section = ".text",
        },
    );
    bin.step.dependOn(&exe.step);
    const copy_bin = b.addInstallBinFile(bin.getOutput(), "rvos.bin");
    b.default_step.dependOn(&copy_bin.step);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const waf = b.addWriteFiles();
    _ = waf.addCopyFile(exe.getEmittedAsm(), "main.asm");
    waf.step.dependOn(&exe.step);
    b.getInstallStep().dependOn(&waf.step);
}
