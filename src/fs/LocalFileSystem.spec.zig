const std = @import("std");
const LocalFileSystem = @import("LocalFileSystem.zig").LocalFileSystem;

var default_allocator = std.heap.page_allocator;

test "LocalFileSystem: should inspect a file" {
    var file_path = "spec/fixtures/example.txt";
    var lfs = LocalFileSystem{};
    _ = try lfs.inspect(file_path);

    try std.testing.expectEqualStrings(file_path, lfs.Path);
    try std.testing.expectEqual(default_allocator, lfs.allocator);
    try std.testing.expectEqual(@as(?u64, 10), lfs.Size);
}

test "LocalFileSystem: should read random bytes from a file" {
    var file_path = "spec/fixtures/example.txt";
    var lfs = LocalFileSystem{};
    _ = try lfs.inspect(file_path);

    var data = try lfs.read(4, 0);
    try std.testing.expectEqualStrings("hell", data);
    data = try lfs.read(4, 2);
    try std.testing.expectEqualStrings("llo ", data);
    data = try lfs.read(4, -2);
    try std.testing.expectEqualStrings("g!", data);
    data = try lfs.read(4, -4);
    try std.testing.expectEqualStrings("zig!", data);
}

test "LocalFileSystem: should raise error" {
    var file_path = "spec/fixtures/example.txt";
    var lfs = LocalFileSystem{};
    _ = try lfs.inspect(file_path);

    var result = lfs.read(4, 11);
    try std.testing.expectEqual(result, error.InvalidOffset);
    result = lfs.read(4, -11);
    try std.testing.expectEqual(result, error.InvalidOffset);
}

pub fn main() !void {
    _ = try std.testing.runAllTests();
    return null;
}
