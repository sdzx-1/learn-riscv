const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "learn",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const csept = b.addAssembly(.{
        .name = "test",
        .source_file = b.path("src/asm/start.S"),
        .optimize = optimize,
        .target = target,
    });
    csept.linkLibrary(lib);
    // b.installArtifact(csept);

    // lib.step.dependOn(&csept.step);
    // csept.linkLibrary(lib);
    b.installArtifact(lib);

    //
    const waf = b.addWriteFiles();
    waf.addCopyFileToSource(lib.getEmittedAsm(), "root.asm");
    waf.step.dependOn(&lib.step);
    b.getInstallStep().dependOn(&waf.step);
}
