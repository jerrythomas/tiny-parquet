const std = @import("std");

var default_allocator = std.heap.page_allocator;

pub const FileReader = struct {
    path: []const u8 = undefined,
    size: u64 = 0,
    allocator: *std.mem.Allocator = &default_allocator,

    pub fn init(url: []const u8) !FileReader {
        var fs = FileReader{};

        const file = try std.fs.cwd().openFile(url, .{});
        defer file.close();
        const stat = try file.stat();
        fs.path = url;
        fs.size = stat.size;

        return fs;
    }

    pub fn read(self: FileReader, bytes: usize, offset: i64) ![]u8 {
        if (self.size == 0) return error.InvalidOffset;

        var adjustedOffset: u64 = @as(u64, @abs(offset));
        if (offset < 0) {
            if (self.size < adjustedOffset) {
                return error.InvalidOffset;
            }
            adjustedOffset = self.size - adjustedOffset;
        }
        if (adjustedOffset >= self.size) return error.InvalidOffset;

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
