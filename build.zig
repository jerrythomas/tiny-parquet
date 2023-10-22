const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "tinypq",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // const enum_module = b.addModule("enum", .{
    //     .source_file = .{ .path = "src/enum/main.zig" },
    // });
    const types_module = b.addModule("types", .{
        .source_file = .{ .path = "src/types/main.zig" },
    });
    const meta_module = b.addModule("meta", .{
        .source_file = .{ .path = "src/meta/main.zig" },
        .dependencies = &.{
            // .{ .name = "enum", .module = enum_module },
            .{ .name = "types", .module = types_module },
        },
    });
    const io_module = b.addModule("io", .{
        .source_file = .{
            .path = "src/io/main.zig",
        },
        // .dependencies = &.{
        //     .{ .name = "enum", .module = enum_module },
        // },
    });
    lib.addModule("types", types_module);
    lib.addModule("io", io_module);
    lib.addModule("meta", meta_module);
    b.installArtifact(lib);

    const run_step = b.step("run", "Run the example code.");

    const example = b.addExecutable(.{
        .name = "example",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    example.addModule("types", types_module);
    example.addModule("io", io_module);
    example.addModule("meta", meta_module);

    const run_example = b.addRunArtifact(example);
    run_step.dependOn(&run_example.step);

    const tests = b.addTest(.{
        .root_source_file = .{ .path = "spec/main.spec.zig" },
        .target = target,
        .optimize = optimize,
    });

    tests.addModule("types", types_module);
    tests.addModule("io", io_module);
    tests.addModule("meta", meta_module);

    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_tests.step);
}
