const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{ .default_target = .{
        .cpu_arch = .riscv32,
        .os_tag = .freestanding,
        .abi = .gnuilp32,
    } });
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .Debug,
    });

    const exe = b.addExecutable(.{
        .name = "rvos",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.setLinkerScript(b.path("os.ld"));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const waf = b.addWriteFiles();
    _ = waf.addCopyFile(exe.getEmittedAsm(), "kernel.asm");
    waf.step.dependOn(&exe.step);
    b.getInstallStep().dependOn(&waf.step);
}
