const std = @import("std");
// const Config = @import("Config.zig").Config;
const LocalFileSystem = @import("LocalFileSystem.zig").LocalFileSystem;

pub const FileSystem = union(enum) {
    local: LocalFileSystem,

    pub fn init(self: *FileSystem, allocator: ?*std.mem.allocator) void {
        return self.local.init(allocator);
        // switch (self) {
        //     inline else => |*case| case.init(allocator),
        // }
    }
    pub fn inspect(self: *FileSystem, path: []const u8) !void {
        return self.local.inspect(path);
        // switch (self) {
        // inline else => |case| @TypeOf(case).inspect(path),
        // }
    }
    pub fn read(self: *FileSystem, bytes: i64, offset: i64) ![]u8 {
        return self.local.read(bytes, offset);
        // switch (self) {
        //      inline else => |*case| case.read(bytes, offset),
        // }
    }
};
