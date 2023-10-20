const std = @import("std");
const Reader = @import("storage").Reader;

var default_allocator = std.heap.page_allocator;
const access_key = "access_key";
const secret_key = "secret_key";

test "Reader: should initialize local file system" {
    var file = "spec/fixtures/example.txt";
    var fs = try Reader.fromPath(file);
    try std.testing.expectEqualStrings(file, fs.local.path);
    try std.testing.expectEqual(default_allocator, fs.local.allocator);
    try std.testing.expectEqual(@as(?u64, 10), fs.local.size);
}

test "Reader: should initialize s3 file system" {
    var file = "s3://spec/fixtures/example.txt";
    var fs = try Reader.fromUrlAndKeys(file, access_key, secret_key);
    try std.testing.expectEqualStrings(file[5..], fs.s3.path);
    try std.testing.expectEqualStrings(access_key, fs.s3.access_key);
    try std.testing.expectEqualStrings(secret_key, fs.s3.secret_key);
    try std.testing.expectEqual(default_allocator, fs.s3.allocator);
    try std.testing.expectEqual(@as(?u64, 10), fs.s3.size);
}

test "Reader: should read random bytes from a local file" {
    var file = "spec/fixtures/example.txt";
    var fs = try Reader.fromPath(file);

    var data = try fs.read(4, 0);
    try std.testing.expectEqualStrings("hell", data);
    data = try fs.read(4, 2);
    try std.testing.expectEqualStrings("llo ", data);
    data = try fs.read(4, -2);
    try std.testing.expectEqualStrings("g!", data);
    data = try fs.read(4, -4);
    try std.testing.expectEqualStrings("zig!", data);
}

pub fn main() !void {
    _ = try std.testing.runAllTests();
    return null;
}
