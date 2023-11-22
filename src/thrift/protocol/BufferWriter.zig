const std = @import("std");

var default_allocator = std.heap.page_allocator;

pub const BinaryProtocolWriter = struct {
    buffer: std.ArrayList(u8),
    allocator: *std.mem.Allocator = &default_allocator,

    pub fn init(allocator: ?*std.mem.Allocator) !BinaryProtocolWriter {
        var derived_allocator = allocator orelse &default_allocator;

        return BinaryProtocolWriter{
            .allocator = derived_allocator,
            .buffer = std.ArrayList(u8).init(derived_allocator.*),
        };
    }

    pub fn deinit(self: *BinaryProtocolWriter) void {
        self.buffer.deinit();
    }

    pub fn writeIndicator(self: *BinaryProtocolWriter, isPresent: bool) !void {
        _ = try self.buffer.append(@as(u8, if (isPresent) 1 else 0));
    }

    pub fn writeNumber(self: *BinaryProtocolWriter, comptime T: type, value: T) !void {
        _ = try self.buffer.appendSlice(std.mem.asBytes(&value));
    }
    pub fn writeDouble(self: *BinaryProtocolWriter, value: f64) !void {
        _ = try self.writeNumber(f64, value);
    }
    pub fn writeOptionalNumber(self: *BinaryProtocolWriter, comptime T: type, value: ?T) !void {
        _ = try self.writeIndicator(value != null);

        if (value != null) {
            _ = try self.writeNumber(T, value.?);
        }
    }

    pub fn writeString(self: *BinaryProtocolWriter, value: []const u8) !void {
        _ = try self.writeNumber(u32, @as(u32, @intCast(value.len)));
        _ = try self.buffer.appendSlice(value);
    }

    pub fn writeOptionalString(self: *BinaryProtocolWriter, value: ?[]const u8) !void {
        _ = try self.writeIndicator(value != null);

        if (value != null) {
            _ = try self.writeString(value.?);
        }
    }

    pub fn finalize(self: *BinaryProtocolWriter) ![]const u8 {
        return try self.buffer.toOwnedSlice();
    }
};

test "BinaryProtocolWriter: Should write a number" {
    var allocator = std.heap.page_allocator;
    var writer = try BinaryProtocolWriter.init(&allocator);
    defer writer.deinit();

    _ = try writer.writeNumber(i32, 10);

    var value = try writer.finalize();
    defer allocator.free(value);

    const expected = [_]u8{ 10, 0, 0, 0 };
    try std.testing.expect(std.mem.eql(u8, value, expected[0..]));
}

test "BinaryProtocolWriter: Should write an optional number" {
    var allocator = std.heap.page_allocator;
    var writer = try BinaryProtocolWriter.init(&allocator);
    defer writer.deinit();

    _ = try writer.writeOptionalNumber(i32, 11);

    var value = try writer.finalize();
    defer allocator.free(value);

    const expected = [_]u8{ 1, 11, 0, 0, 0 };
    try std.testing.expect(std.mem.eql(u8, value, expected[0..]));
}

test "BinaryProtocolWriter: Should write an optional number as null" {
    var allocator = std.heap.page_allocator;
    var writer = try BinaryProtocolWriter.init(&allocator);
    defer writer.deinit();

    _ = try writer.writeOptionalNumber(i32, null);

    var value = try writer.finalize();
    defer allocator.free(value);

    const expected = [_]u8{0};
    try std.testing.expect(std.mem.eql(u8, value, expected[0..]));
}

test "BinaryProtocolWriter: Should write a string" {
    var allocator = std.heap.page_allocator;
    var writer = try BinaryProtocolWriter.init(&allocator);
    defer writer.deinit();

    _ = try writer.writeString("Hello, Zig!");

    var value = try writer.finalize();
    defer allocator.free(value);

    const expected = [_]u8{ 11, 0, 0, 0, 'H', 'e', 'l', 'l', 'o', ',', ' ', 'Z', 'i', 'g', '!' };
    try std.testing.expect(std.mem.eql(u8, value, expected[0..]));
}

test "BinaryProtocolWriter: Should write an optional string" {
    var allocator = std.heap.page_allocator;
    var writer = try BinaryProtocolWriter.init(&allocator);
    defer writer.deinit();

    _ = try writer.writeOptionalString("Hello, Zig!");

    var value = try writer.finalize();
    defer allocator.free(value);

    const expected = [_]u8{ 1, 11, 0, 0, 0, 'H', 'e', 'l', 'l', 'o', ',', ' ', 'Z', 'i', 'g', '!' };
    try std.testing.expect(std.mem.eql(u8, value, expected[0..]));
}

test "BinaryProtocolWriter: Should write an optional null string" {
    var allocator = std.heap.page_allocator;
    var writer = try BinaryProtocolWriter.init(&allocator);
    defer writer.deinit();
    _ = try writer.writeOptionalString(null);

    var value = try writer.finalize();
    defer allocator.free(value);
    const expected = [_]u8{0};
    try std.testing.expect(std.mem.eql(u8, value, expected[0..]));
}
