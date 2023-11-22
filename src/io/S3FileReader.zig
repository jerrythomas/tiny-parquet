const std = @import("std");

pub const S3FileReader = struct {
    path: []const u8 = undefined,
    size: u64 = 0,
    access_key: []const u8 = undefined,
    secret_key: []const u8 = undefined,
    allocator: std.mem.Allocator = std.heap.page_allocator,

    pub fn init(url: []const u8, access_key: []const u8, secret_key: []const u8, allocator: ?std.mem.Allocator) !S3FileReader {
        var fs = S3FileReader{
            .allocator = allocator orelse std.heap.page_allocator,
        };

        const file = try std.fs.cwd().openFile(url, .{});
        defer file.close();
        const stat = try file.stat();

        fs.path = url;
        fs.size = stat.size;
        fs.access_key = access_key;
        fs.secret_key = secret_key;

        return fs;
    }

    pub fn read(self: S3FileReader, bytes: usize, offset: i64) ![]u8 {
        if (self.size == 0) {
            return error.InvalidFile;
        }
        var adjustedOffset: u64 = @as(u64, @abs(offset));
        if (offset < 0) {
            if (self.size < adjustedOffset) {
                return error.InvalidOffset;
            }
            adjustedOffset = self.size - adjustedOffset;
        }
        if (adjustedOffset >= self.size) {
            return error.InvalidOffset;
        }

        var buffer = try self.allocator.alloc(u8, bytes);
        errdefer self.allocator.free(buffer); // free buffer on error

        const file = try std.fs.cwd().openFile(self.path, .{});
        defer file.close();

        try file.seekTo(adjustedOffset);
        var bytesRead = try file.readAll(buffer);

        if (bytesRead < bytes) {
            return try self.allocator.realloc(buffer, bytesRead);
        }
        return buffer;
    }
};

test "S3FileReader: should initialize with default allocator" {
    var file = "spec/fixtures/example.txt";
    const lfs = try S3FileReader.init(file, "access_key", "secret_key", null);
    try std.testing.expectEqualStrings(file, lfs.path);
    try std.testing.expectEqual(std.heap.page_allocator, lfs.allocator);
    try std.testing.expectEqual(@as(?u64, 10), lfs.size);
}

test "S3FileReader: should read random bytes from a file" {
    var file = "spec/fixtures/example.txt";
    const lfs = try S3FileReader.init(file, "access_key", "secret_key", std.testing.allocator);

    try std.testing.expectEqual(std.testing.allocator, lfs.allocator);

    var data = try lfs.read(4, 0);
    try std.testing.expectEqualStrings("hell", data);
    std.testing.allocator.free(data);

    data = try lfs.read(4, 2);
    try std.testing.expectEqualStrings("llo ", data);
    std.testing.allocator.free(data);
    // data = try lfs.read(4, -2);
    // try std.testing.expectEqualStrings("g!", data);
    data = try lfs.read(4, -4);
    try std.testing.expectEqualStrings("zig!", data);
    std.testing.allocator.free(data);
}

test "S3FileReader: should handle reads larger than file size" {
    var file = "spec/fixtures/example.txt";
    const lfs = try S3FileReader.init(file, "access_key", "secret_key", std.testing.allocator);

    var data = try lfs.read(100, 0);
    try std.testing.expectEqualStrings("hello zig!", data);
    std.testing.allocator.free(data);
}

test "S3FileReader: should raise error" {
    var file = "spec/fixtures/example.txt";
    const lfs = try S3FileReader.init(file, "access_key", "secret_key", std.testing.allocator);

    var result = lfs.read(4, 11);
    try std.testing.expectEqual(result, error.InvalidOffset);
    result = lfs.read(4, -11);
    try std.testing.expectEqual(result, error.InvalidOffset);
}
