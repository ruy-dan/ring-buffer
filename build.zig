const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.addModule("ring-buffer", .{
        .root_source_file = b.path("ring_buffer.zig"),
        .target = target,
        .optimize = optimize,
    });

    const unit_tests = b.addTest(.{
        .root_source_file = b.path("test.zig"),
        .target = target,
        .optimize = optimize,
    });
    unit_tests.root_module.addImport("ring-buffer", module);
    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
