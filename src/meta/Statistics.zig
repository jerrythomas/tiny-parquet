const std = @import("std");

var default_allocator = std.heap.page_allocator;

pub const Statistics = struct {
    max: ?[]u8 = null,
    min: ?[]u8 = null,
    null_count: ?i64 = 0,
    distinct_count: ?i64 = 0,
    max_value: ?[]u8 = null,
    min_value: ?[]u8 = null,

    pub fn init() Statistics {
        return Statistics{};
    }

    pub fn fromBuffer(self: *Statistics, buffer: []u8) !void {
        const max_len = 10; // Assuming max length of 10 for binary fields
        if (buffer.len < max_len * 4 + 16) {
            std.debug.print("Buffer is too small to read statistics {}", .{buffer.len});
            // return std.mem.Error.OutOfMemory;
        }

        self.max = buffer[0..max_len];
        self.min = buffer[max_len .. max_len * 2];
        self.max_value = buffer[max_len * 2 .. max_len * 3];
        self.min_value = buffer[max_len * 3 .. max_len * 4];

        const int_slice = std.mem.bytesAsSlice(i64, buffer[max_len * 4 ..]);
        self.null_count = int_slice[0];
        self.distinct_count = int_slice[1];
    }

    pub fn toBuffer(self: *Statistics, mem_allocater: ?*std.mem.Allocator) ![]u8 {
        const allocator = mem_allocater orelse &default_allocator;

        var buffer = try allocator.alloc(u8, 4 * 10 + 16); // 4 binary fields of max length 10, and 2 i64 fields
        std.mem.copy(u8, buffer[0..10], self.max orelse "          ");
        std.mem.copy(u8, buffer[10..20], self.min orelse "          ");
        std.mem.copy(u8, buffer[20..30], self.max_value orelse "          ");
        std.mem.copy(u8, buffer[30..40], self.min_value orelse "          ");

        const null_count = self.null_count orelse 0;
        const distinct_count = self.distinct_count orelse 0;
        std.mem.writeIntLittle(i64, buffer[40..48], null_count);
        std.mem.writeIntLittle(i64, buffer[48..56], distinct_count);

        return buffer;
    }
};
