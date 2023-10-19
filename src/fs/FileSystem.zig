const std = @import("std");
const LocalFileSystem = @import("LocalFileSystem.zig").LocalFileSystem;
const S3FileSystem = @import("S3FileSystem.zig").S3FileSystem;

pub const FileSystem = union(enum) {
    local: LocalFileSystem,
    s3: S3FileSystem,

    pub fn fromPath(url: []const u8) !FileSystem {
        return FileSystem{ .local = try LocalFileSystem.init(url) };
    }
    pub fn fromUrlAndKeys(url: []const u8, access_key: []const u8, secret_key: []const u8) !FileSystem {
        var fs: FileSystem = undefined;
        if (std.mem.startsWith(u8, url, "s3://")) {
            fs = FileSystem{ .s3 = try S3FileSystem.init(url[5..], access_key, secret_key) };
        } else {
            return error.UnsupportedFileSystem;
        }
        return fs;
    }

    pub fn read(self: *FileSystem, bytes: usize, offset: i64) ![]u8 {
        switch (self.*) {
            inline else => |*case| return try case.read(bytes, offset),
        }
    }
};
