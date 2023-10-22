const std = @import("std");
const io = @import("io");

var default_allocator = std.heap.page_allocator;

test "FileReader: should initialize" {
    var file = "spec/fixtures/example.txt";
    const lfs = try io.FileReader.init(file);
    try std.testing.expectEqualStrings(file, lfs.path);
    try std.testing.expectEqual(default_allocator, lfs.allocator.*);
    try std.testing.expectEqual(@as(?u64, 10), lfs.size);
}

test "FileReader: should read random bytes from a file" {
    var file = "spec/fixtures/example.txt";
    const lfs = try io.FileReader.init(file);

    var data = try lfs.read(4, 0);
    try std.testing.expectEqualStrings("hell", data);
    data = try lfs.read(4, 2);
    try std.testing.expectEqualStrings("llo ", data);
    data = try lfs.read(4, -2);
    try std.testing.expectEqualStrings("g!", data);
    data = try lfs.read(4, -4);
    try std.testing.expectEqualStrings("zig!", data);
}

test "FileReader: should raise error" {
    var file = "spec/fixtures/example.txt";
    const lfs = try io.FileReader.init(file);

    var result = lfs.read(4, 11);
    try std.testing.expectEqual(result, error.InvalidOffset);
    result = lfs.read(4, -11);
    try std.testing.expectEqual(result, error.InvalidOffset);
}
