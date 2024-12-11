const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{ .default_target = .{
        .cpu_arch = .riscv32,
        .os_tag = .freestanding,
        .abi = .gnuilp32,
    } });

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "kernel",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .strip = false,
    });
    // exe.add(b.path("src/asm"));
    exe.setLinkerScript(b.path(("src/asm//os.ld")));
    exe.addAssemblyFile(b.path("src/asm/start.S"));

    b.installArtifact(exe);

    //
    const waf = b.addWriteFiles();
    waf.addCopyFileToSource(exe.getEmittedAsm(), "root.asm");
    waf.step.dependOn(&exe.step);
    b.getInstallStep().dependOn(&waf.step);
}
