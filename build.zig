const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "tiny-pq",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // Add the enum module to a Compile step, so that Zig code can actually @import("enum")
    const enum_module = b.addModule("enum", .{
        .source_file = .{ .path = "src/enum/main.zig" },
    });
    // Add the fs module to a Compile step, so that Zig code can actually @import("fs")
    const fs_module = b.addModule("fs", .{
        .source_file = .{
            .path = "src/fs/main.zig",
        },
        .dependencies = &.{
            .{ .name = "enum", .module = enum_module },
        },
    });
    lib.addModule("enum", enum_module);
    lib.addModule("fs", fs_module);
    b.installArtifact(lib);

    const run_step = b.step("run", "Run the example code.");

    const example = b.addExecutable(.{
        .name = "example",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    example.addModule("enum", enum_module);

    const run_example = b.addRunArtifact(example);
    run_step.dependOn(&run_example.step);

    const tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    tests.addModule("enum", enum_module);
    tests.addModule("fs", fs_module);

    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_tests.step);
}
