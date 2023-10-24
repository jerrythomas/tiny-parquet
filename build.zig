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

    const thrift_types_module = b.addModule("thrift.types", .{
        .source_file = .{ .path = "src/thrift/types/main.zig" },
    });
    const thrift_module = b.addModule("thrift", .{
        .source_file = .{ .path = "src/thrift/main.zig" },
        .dependencies = &.{
            .{ .name = "thrift.types", .module = thrift_types_module },
        },
    });

    const types_module = b.addModule("types", .{
        .source_file = .{ .path = "src/types/main.zig" },
    });
    const meta_module = b.addModule("meta", .{
        .source_file = .{ .path = "src/meta/main.zig" },
        .dependencies = &.{
            .{ .name = "thrift", .module = thrift_module },
            .{ .name = "types", .module = types_module },
        },
    });
    const io_module = b.addModule("io", .{
        .source_file = .{
            .path = "src/io/main.zig",
        },
    });
    lib.addModule("thrift.types", thrift_types_module);
    lib.addModule("thrift", thrift_module);
    lib.addModule("types", types_module);
    lib.addModule("io", io_module);
    lib.addModule("meta", meta_module);
    b.installArtifact(lib);

    const run_step = b.step("run", "Run the example code.");

    const runner = b.addExecutable(.{
        .name = "example",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    runner.addModule("thrift.types", thrift_types_module);
    runner.addModule("thrift", thrift_module);

    runner.addModule("types", types_module);
    runner.addModule("io", io_module);
    runner.addModule("meta", meta_module);

    const run_example = b.addRunArtifact(runner);
    run_step.dependOn(&run_example.step);

    const tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    tests.addModule("thrift.types", thrift_types_module);
    tests.addModule("thrift", thrift_module);

    tests.addModule("types", types_module);
    tests.addModule("io", io_module);
    tests.addModule("meta", meta_module);

    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_tests.step);
}
