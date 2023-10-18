const std = @import("std");
const FileSystemErrors = @import("errors.zig").FileSystemErrors;

pub const LocalFileSystem = struct {
    allocator: std.mem.Allocator = std.heap.page_allocator,
    Path: []const u8 = "",
    Size: ?u64 = null,

    pub fn init(self: *LocalFileSystem, mem_allocator: ?*std.mem.Allocator) void {
        self.Path = try std.fs.cwd().pathToBuffer(".");
        self.allocator = mem_allocator or std.heap.page_allocator;
    }

    pub fn inspect(self: *LocalFileSystem, path: []const u8) FileSystemErrors!void {
        self.Path = path;

        const file = try std.fs.cwd().openFile(self.Path, .{});
        defer file.close();
        const stat = try file.stat();
        self.Size = stat.size;
    }

    pub fn read(self: *LocalFileSystem, bytes: usize, offset: i64) FileSystemErrors![]u8 {
        var adjustedOffset: u64 = @as(u64, @abs(offset));
        if (offset < 0) {
            if (self.Size.? < adjustedOffset) {
                return error.InvalidOffset;
            }
            adjustedOffset = self.Size.? - adjustedOffset;
        }
        if (adjustedOffset >= self.Size.?) {
            return error.InvalidOffset;
        }

        var buffer = try self.allocator.alloc(u8, bytes);
        errdefer self.allocator.free(buffer); // free buffer on error

        const file = try std.fs.cwd().openFile(self.Path, .{});
        defer file.close();

        try file.seekTo(adjustedOffset);
        var bytesRead = try file.readAll(buffer);

        if (bytesRead < bytes) {
            return buffer[0..bytesRead];
        }
        return buffer;
    }
};
