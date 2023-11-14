const std = @import("std");

pub const FileReader = struct {
    path: []const u8 = undefined,
    size: usize = 0,
    allocator: std.mem.Allocator = std.heap.page_allocator,
    file: std.fs.File = undefined,

    pub fn open(ctx: *anyopaque, url: []const u8) !usize {
        const self: *FileReader = @ptrCast(@alignCast(ctx));
        self.file = try std.fs.cwd().openFile(url, .{});

        const stat = try self.file.stat();
        self.path = url;
        self.size = stat.size;

        return self.size;
    }
    pub fn close(ctx: *anyopaque) void {
        const self: *FileReader = @ptrCast(@alignCast(ctx));
        self.file.close();
        self.* = undefined;
    }

    pub fn read(ctx: *anyopaque, offset: usize, bytes: usize) ![]u8 {
        const self: *FileReader = @ptrCast(@alignCast(ctx));
        if (offset >= self.size) return error.InvalidOffset;

        var buffer = try self.allocator.alloc(u8, bytes);
        errdefer self.allocator.free(buffer);

        try self.file.seekTo(offset);
        var bytesRead = try self.file.readAll(buffer);

        if (bytesRead < bytes) {
            return try self.allocator.realloc(buffer, bytesRead);
        }

        return buffer;
    }
};

test "FileReader: should initialize with default allocator" {
    const lfs = FileReader{};
    try std.testing.expectEqual(std.heap.page_allocator, lfs.allocator);
}

test "FileReader: should read random bytes from a file" {
    var file = "spec/fixtures/example.txt";
    var lfs = FileReader{ .allocator = std.testing.allocator };

    _ = try FileReader.open(&lfs, file);
    defer FileReader.close(&lfs);

    var data = try FileReader.read(&lfs, 0, 4);
    try std.testing.expectEqualStrings("hell", data);
    std.testing.allocator.free(data);

    data = try FileReader.read(&lfs, 2, 4);
    try std.testing.expectEqualStrings("llo ", data);
    std.testing.allocator.free(data);
}

test "FileReader: should handle reads larger than file size" {
    var file = "spec/fixtures/example.txt";
    var lfs = FileReader{ .allocator = std.testing.allocator };

    _ = try FileReader.open(&lfs, file);
    defer FileReader.close(&lfs);

    var data = try FileReader.read(&lfs, 0, 100);
    defer std.testing.allocator.free(data);
    try std.testing.expectEqualStrings("hello zig!", data);
}

test "FileReader: should raise error" {
    var file = "spec/fixtures/example.txt";
    var lfs = FileReader{ .allocator = std.testing.allocator };

    _ = try FileReader.open(&lfs, file);
    defer FileReader.close(&lfs);

    var result = FileReader.read(&lfs, 11, 4);
    try std.testing.expectEqual(result, error.InvalidOffset);
}
