const std = @import("std");
const testing = std.testing;
const FileSystemErrors = @import("errors").FileSystemErrors;

const FileInfo = struct {
    path: []const u8 = undefined,
    size: u64 = 0,
};

const EmbeddedAdapter = struct {
    inspect: fn (filepath: []const u8) FileInfo,
    read: fn (
        info: *FileInfo,
        bytes: u64,
        offset: i64,
    ) []u8,
};

const StorageAdapter = struct {
    adapter: ?EmbeddedAdapter,
    info: ?FileInfo = null,

    pub fn inspect(self: *StorageAdapter, filepath: []const u8) !void {
        if (self.adapter == null) {
            return error.InvalidAdapter;
        }
        self.info = self.adapter.inspect(filepath);
    }
    pub fn read(self: *StorageAdapter, bytes: u64, offset: i64) ![]u8 {
        if (self.adapter == null) {
            return error.InvalidAdapter;
        }
        if (self.info == null) {
            return error.InvalidFileInfo;
        }
        return self.adapter.read(self.info, bytes, offset);
    }
};

const FileStorageAdapter = struct {
    pub fn init() StorageAdapter {
        return StorageAdapter{ .adapter = EmbeddedAdapter{
            .inspect = inspect,
            .read = read,
        } };
    }
    pub fn inspect(filepath: []const u8) FileInfo {
        return FileInfo{ .path = filepath, .size = 0 };
    }
    pub fn read(
        info: *FileInfo,
        bytes: u64,
        offset: i64,
    ) []u8 {
        _ = offset;
        _ = bytes;
        _ = info;
        return "info";
    }
};

fn testReader(filepath: []const u8) void {
    if (std.fs.cwd().openFile(filepath, .{})) |file| {
        defer file.close();
        // return "success";
    } else |err| {
        _ = err;
        return error.FileOpenError;
        // std.debug.print("error: {!}\n", .{err});
    }
}

pub fn main() !void {
    // var filepath = "foo.txt";
    // try testReader(filepath);
    var adapter = FileStorageAdapter.init();
    adapter.inspect("foo.txt");
    var res = adapter.read(0, 0);
    std.debug.print("res: {!}\n", .{res});
}
