const std = @import("std");
const S3 = @import("storage").S3;

var default_allocator = std.heap.page_allocator;

const access_key = "access_key";
const secret_key = "secret_key";

test "S3: should initialize" {
    var file = "spec/fixtures/example.txt";
    const lfs = try S3.init(file, access_key, secret_key);
    try std.testing.expectEqualStrings(file, lfs.path);
    try std.testing.expectEqual(default_allocator, lfs.allocator);
    try std.testing.expectEqual(@as(?u64, 10), lfs.size);
}

test "S3: should read random bytes from a file" {
    var file = "spec/fixtures/example.txt";
    const lfs = try S3.init(file, access_key, secret_key);

    var data = try lfs.read(4, 0);
    try std.testing.expectEqualStrings("hell", data);
    data = try lfs.read(4, 2);
    try std.testing.expectEqualStrings("llo ", data);
    data = try lfs.read(4, -2);
    try std.testing.expectEqualStrings("g!", data);
    data = try lfs.read(4, -4);
    try std.testing.expectEqualStrings("zig!", data);
}

test "S3: should raise error" {
    var file = "spec/fixtures/example.txt";
    const lfs = try S3.init(file, access_key, secret_key);

    var result = lfs.read(4, 11);
    try std.testing.expectEqual(result, error.InvalidOffset);
    result = lfs.read(4, -11);
    try std.testing.expectEqual(result, error.InvalidOffset);
}

pub fn main() !void {
    _ = try std.testing.runAllTests();
    return null;
}
