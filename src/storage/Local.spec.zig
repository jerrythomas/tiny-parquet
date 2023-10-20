const std = @import("std");
const Local = @import("storage").Local;

var default_allocator = std.heap.page_allocator;

test "Local: should initialize" {
    var file = "spec/fixtures/example.txt";
    const lfs = try Local.init(file);
    try std.testing.expectEqualStrings(file, lfs.path);
    try std.testing.expectEqual(default_allocator, lfs.allocator);
    try std.testing.expectEqual(@as(?u64, 10), lfs.size);
}

test "Local: should read random bytes from a file" {
    var file = "spec/fixtures/example.txt";
    const lfs = try Local.init(file);

    var data = try lfs.read(4, 0);
    try std.testing.expectEqualStrings("hell", data);
    data = try lfs.read(4, 2);
    try std.testing.expectEqualStrings("llo ", data);
    data = try lfs.read(4, -2);
    try std.testing.expectEqualStrings("g!", data);
    data = try lfs.read(4, -4);
    try std.testing.expectEqualStrings("zig!", data);
}

test "Local: should raise error" {
    var file = "spec/fixtures/example.txt";
    const lfs = try Local.init(file);

    var result = lfs.read(4, 11);
    try std.testing.expectEqual(result, error.InvalidOffset);
    result = lfs.read(4, -11);
    try std.testing.expectEqual(result, error.InvalidOffset);
}

pub fn main() !void {
    _ = try std.testing.runAllTests();
    return null;
}
