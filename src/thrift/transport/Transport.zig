const std = @import("std");
const Endian = std.builtin.Endian;

pub const Transport = struct {
    buffer: []u8 = undefined,
    seek_offset: usize = 0,
    read_start: usize = 0,
    read_end: usize = 0,
    write_offset: u32 = 0,
    fetch_size: usize = 0,
    max_buffer_size: u32 = 4096,
    chunk_size: u32 = 1024,
    total_size: usize = 0,
    buffer_size: usize = 0,
    endian: Endian = Endian.Little,

    ptr: *anyopaque,
    impl: *const Interface,
    allocator: std.mem.Allocator = std.heap.page_allocator,

    pub const Interface = struct {
        open: *const fn (*anyopaque, []const u8) anyerror!usize,
        close: *const fn (*anyopaque) void,
        read: *const fn (*anyopaque, usize, usize) anyerror![]u8,
    };

    pub fn from(ctx: *anyopaque, comptime T: type) Transport {
        const self: *T = @ptrCast(@alignCast(ctx));
        return Transport{
            .allocator = self.*.allocator,
            .ptr = self,
            .impl = &.{
                .open = T.open,
                .close = T.close,
                .read = T.read,
            },
        };
    }

    pub fn open(self: *Transport, url: []const u8) !void {
        if (self.buffer_size > 0) self.close();

        self.total_size = try self.impl.open(self.ptr, url);
        self.read_end = 0;
        self.read_start = 0;
    }
    pub fn close(self: *Transport) void {
        self.impl.close(self.ptr);

        if (self.buffer_size > 0) self.allocator.free(self.buffer);

        self.* = undefined;
        self.buffer_size = 0;
        self.read_end = 0;
        self.read_start = 0;
    }

    pub fn read(self: *Transport, offset: i32, size: u32) !void {
        if (offset < 0) {
            self.seek_offset = self.total_size - @abs(offset);
        } else {
            self.seek_offset = @abs(offset);
        }
        self.fetch_size = size;
        self.read_start = 0;

        if (self.chunk_size > self.max_buffer_size) {
            self.chunk_size = self.max_buffer_size;
        }

        if (self.seek_offset + self.fetch_size > self.total_size) {
            return error.FetchSizeOutOfBounds;
        }

        if (self.read_end > self.read_start) self.allocator.free(self.buffer);
        self.buffer = try self.allocator.alloc(u8, self.chunk_size);
        self.buffer_size = self.chunk_size;

        try self.readNext();
    }

    pub fn readNext(self: *Transport) !void {
        var fetch_offset = self.seek_offset + self.read_start;
        var used_size = self.read_end - self.read_start;

        if (used_size + self.chunk_size > self.max_buffer_size) {
            return error.SizeLimitExceeded;
        }

        if (self.read_start > 0) {
            std.mem.copy(u8, self.buffer, self.buffer[self.read_start..]);
            self.seek_offset += self.read_start;
            self.read_start = 0;
            self.read_end = used_size;
        }

        var read_size = self.fetch_size;
        if (self.fetch_size > self.chunk_size) read_size = self.chunk_size;

        var data = try self.impl.read(self.ptr, fetch_offset, read_size);
        defer self.allocator.free(data);
        std.debug.print("\nreadNext -> data: {s}\n", .{data});

        if (data.len + used_size > self.buffer.len) {
            self.buffer = try self.allocator.realloc(self.buffer, self.buffer.len - used_size + data.len);
            self.buffer_size = self.buffer.len;
        }
        std.mem.copy(u8, self.buffer[used_size..], data);
        // std.debug.print("readNext: {s}\n", .{self.buffer});
        self.seek_offset += data.len;
        self.fetch_size -= data.len;
        self.read_end += data.len;
    }

    fn checkReadBytesAvailable(self: *Transport, length: usize) !void {
        if (self.read_start + length > self.buffer.len) {
            if (self.fetch_size > 0) {
                try self.readNext();
            } else {
                return error.NotEnoughBytesAvailable;
            }
        }
    }

    pub fn readBytes(self: *Transport, length: usize) ![]u8 {
        try checkReadBytesAvailable(self, length);
        std.debug.print("\nReading -> start {},length {}", .{ self.read_start, length });
        var bytes = self.buffer[self.read_start .. self.read_start + length];
        std.debug.print("\nreadBytes -> bytes: {s}\n", .{bytes});
        self.read_start += length;
        return bytes;
    }

    pub fn readNumber(self: *Transport, comptime T: type) !T {
        var bytes = try self.readBytes(@sizeOf(T));
        return std.mem.readInt(T, &bytes[0], self.endian);
    }

    pub fn readDouble(self: *Transport) !f64 {
        return @as(f64, @bitCast(try self.readNumber(u64)));
    }
};
