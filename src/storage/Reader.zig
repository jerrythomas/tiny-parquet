const std = @import("std");
const Local = @import("Local.zig").Local;
const S3 = @import("S3.zig").S3;

pub const Reader = union(enum) {
    local: Local,
    s3: S3,

    pub fn fromPath(url: []const u8) !Reader {
        return Reader{ .local = try Local.init(url) };
    }
    pub fn fromUrlAndKeys(url: []const u8, access_key: []const u8, secret_key: []const u8) !Reader {
        var fs: Reader = undefined;
        if (std.mem.startsWith(u8, url, "s3://")) {
            fs = Reader{ .s3 = try S3.init(url[5..], access_key, secret_key) };
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

    pub fn allocator(self: *Reader) *std.mem.Allocator {
        switch (self.*) {
            inline else => |*case| return case.allocator,
        }
    }
};
