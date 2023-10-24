const std = @import("std");
const FileReader = @import("FileReader.zig").FileReader;
const S3FileReader = @import("S3FileReader.zig").S3FileReader;
var default_allocator = std.heap.page_allocator;

pub const Reader = union(enum) {
    local: FileReader,
    s3: S3FileReader,

    pub fn fromPath(url: []const u8, alloc: ?std.mem.Allocator) !Reader {
        return Reader{ .local = try FileReader.init(url, alloc) };
    }
    pub fn fromUrlAndKeys(url: []const u8, access_key: []const u8, secret_key: []const u8, alloc: ?std.mem.Allocator) !Reader {
        var fs: Reader = undefined;
        if (std.mem.startsWith(u8, url, "s3://")) {
            fs = Reader{ .s3 = try S3FileReader.init(url[5..], access_key, secret_key, alloc) };
        } else {
            return error.UnsupportedStorage;
        }
        return fs;
    }

    pub fn read(self: *Reader, bytes: usize, offset: i64) ![]u8 {
        switch (self.*) {
            inline else => |*case| return try case.read(bytes, offset),
        }
    }

    pub fn allocator(self: *Reader) std.mem.Allocator {
        switch (self.*) {
            inline else => |*case| return case.allocator,
        }
    }
};

test "Reader: should initialize local file system" {
    var file = "spec/fixtures/example.txt";
    var fs = try Reader.fromPath(file, null);

    try std.testing.expectEqual(std.heap.page_allocator, fs.allocator());
    try std.testing.expectEqualStrings(file, fs.local.path);
    try std.testing.expectEqual(@as(?u64, 10), fs.local.size);
}

test "Reader: should initialize s3 file system" {
    var file = "s3://spec/fixtures/example.txt";
    var fs = try Reader.fromUrlAndKeys(file, "access_key", "secret_key", null);

    try std.testing.expectEqual(std.heap.page_allocator, fs.allocator());
    try std.testing.expectEqualStrings(file[5..], fs.s3.path);
    try std.testing.expectEqualStrings("access_key", fs.s3.access_key);
    try std.testing.expectEqualStrings("secret_key", fs.s3.secret_key);
    try std.testing.expectEqual(@as(?u64, 10), fs.s3.size);
}

test "Reader: should read random bytes from a local file" {
    var file = "spec/fixtures/example.txt";
    var fs = try Reader.fromPath(file, std.testing.allocator);

    var data = try fs.read(4, 0);
    try std.testing.expectEqualStrings("hell", data);
    std.testing.allocator.free(data);

    data = try fs.read(4, 2);
    try std.testing.expectEqualStrings("llo ", data);
    std.testing.allocator.free(data);

    data = try fs.read(4, -2);
    try std.testing.expectEqualStrings("g!", data);
    std.testing.allocator.free(data);

    data = try fs.read(4, -4);
    try std.testing.expectEqualStrings("zig!", data);
    std.testing.allocator.free(data);
}
