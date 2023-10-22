const std = @import("std");
const FileReader = @import("FileReader.zig").FileReader;
const S3FileReader = @import("S3FileReader.zig").S3FileReader;

pub const Reader = union(enum) {
    local: FileReader,
    s3: S3FileReader,

    pub fn fromPath(url: []const u8) !Reader {
        return Reader{ .local = try FileReader.init(url) };
    }
    pub fn fromUrlAndKeys(url: []const u8, access_key: []const u8, secret_key: []const u8) !Reader {
        var fs: Reader = undefined;
        if (std.mem.startsWith(u8, url, "s3://")) {
            fs = Reader{ .s3 = try S3FileReader.init(url[5..], access_key, secret_key) };
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
