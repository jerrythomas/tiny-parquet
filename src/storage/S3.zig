const std = @import("std");

pub const S3 = struct {
    path: []const u8 = undefined,
    size: u64 = 0,
    access_key: []const u8 = undefined,
    secret_key: []const u8 = undefined,
    allocator: std.mem.Allocator = std.heap.page_allocator,

    pub fn init(url: []const u8, access_key: []const u8, secret_key: []const u8) !S3 {
        var fs = S3{};

        const file = try std.fs.cwd().openFile(url, .{});
        defer file.close();
        const stat = try file.stat();

        fs.path = url;
        fs.size = stat.size;
        fs.access_key = access_key;
        fs.secret_key = secret_key;

        return fs;
    }

    pub fn read(self: S3, bytes: usize, offset: i64) ![]u8 {
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
            return buffer[0..bytesRead];
        }
        return buffer;
    }
};
