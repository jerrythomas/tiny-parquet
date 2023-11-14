const std = @import("std");
const builtin = @import("builtin");
const expect = std.testing.expect;
const Endian = std.builtin.Endian;
const native_endian = builtin.cpu.arch.endian();

pub const BinaryEncoder = struct {
    allocator: std.mem.Allocator,
    endian: Endian = Endian.little,
    data: std.ArrayList(u8),

    pub fn init(allocator: std.mem.Allocator) BinaryEncoder {
        return BinaryEncoder{ .allocator = allocator, .data = std.ArrayList(u8).init(allocator) };
    }

    pub fn appendNumber(self: *BinaryEncoder, comptime T: type, value: T) !void {
        var bytes: [@sizeOf(T)]u8 = undefined;

        std.mem.copy(u8, &bytes, std.mem.asBytes(&value));
        if (self.endian != native_endian) {
            std.mem.reverse(u8, &bytes);
        }
        try self.appendBytes(&bytes);
    }

    pub fn appendString(self: *BinaryEncoder, value: []const u8) !void {
        var bytes = try self.allocator.alloc(u8, value.len);
        defer self.allocator.free(bytes);

        std.mem.copy(u8, bytes, value);
        try self.appendBytes(bytes);
    }

    pub fn appendBytes(self: *BinaryEncoder, bytes: []u8) !void {
        for (bytes) |byte| {
            try self.data.append(byte);
        }
    }

    pub fn asBytes(self: *BinaryEncoder) ![]u8 {
        return self.data.toOwnedSlice();
    }
};

test "BinaryEncoder: should encode f16" {
    var encoder = BinaryEncoder.init(std.testing.allocator);
    try encoder.appendNumber(f16, -1.5);

    var bytes = try encoder.asBytes();
    try expect(bytes[0] == 0x00);
    try expect(bytes[1] == 0xbe);

    std.testing.allocator.free(bytes);
    try encoder.appendNumber(f16, 1.5);
    bytes = try encoder.asBytes();
    try expect(bytes[0] == 0x00);
    try expect(bytes[1] == 0x3e);

    std.testing.allocator.free(bytes);
}

test "BinaryEncoder: should encode f32" {
    var encoder = BinaryEncoder.init(std.testing.allocator);
    try encoder.appendNumber(f32, -100.5);
    var bytes = try encoder.asBytes();

    try expect(bytes[0] == 0x00);
    try expect(bytes[1] == 0x00);
    try expect(bytes[2] == 0xc9);
    try expect(bytes[3] == 0xc2);

    std.testing.allocator.free(bytes);
    try encoder.appendNumber(f32, 100.5);
    bytes = try encoder.asBytes();

    try expect(bytes[0] == 0x00);
    try expect(bytes[0] == 0x00);
    try expect(bytes[2] == 0xc9);
    try expect(bytes[3] == 0x42);

    std.testing.allocator.free(bytes);
}

test "BinaryEncoder: should encode f64" {
    var encoder = BinaryEncoder.init(std.testing.allocator);
    try encoder.appendNumber(f64, -100.5);
    var bytes = try encoder.asBytes();

    try expect(bytes[0] == 0x00);
    try expect(bytes[1] == 0x00);
    try expect(bytes[2] == 0x00);
    try expect(bytes[3] == 0x00);
    try expect(bytes[4] == 0x00);
    try expect(bytes[5] == 0x20);
    try expect(bytes[6] == 0x59);
    try expect(bytes[7] == 0xc0);

    std.testing.allocator.free(bytes);
    try encoder.appendNumber(f64, 100.5);
    bytes = try encoder.asBytes();

    try expect(bytes[0] == 0x00);
    try expect(bytes[1] == 0x00);
    try expect(bytes[2] == 0x00);
    try expect(bytes[3] == 0x00);
    try expect(bytes[4] == 0x00);
    try expect(bytes[5] == 0x20);
    try expect(bytes[6] == 0x59);
    try expect(bytes[7] == 0x40);

    std.testing.allocator.free(bytes);
}

test "BinaryEncoder: should encode string" {
    var encoder = BinaryEncoder.init(std.testing.allocator);
    try encoder.appendString("hello");
    var bytes = try encoder.asBytes();
    try expect(bytes[0] == 'h');
    try expect(bytes[1] == 'e');
    try expect(bytes[2] == 'l');
    try expect(bytes[3] == 'l');
    try expect(bytes[4] == 'o');

    std.testing.allocator.free(bytes);
}
test "BinaryEncoder: should encode u8" {
    var encoder = BinaryEncoder.init(std.testing.allocator);
    try encoder.appendNumber(u8, 100);
    var bytes = try encoder.asBytes();
    try expect(bytes[0] == 100);

    std.testing.allocator.free(bytes);
}

test "BinaryEncoder: should encode u16" {
    var encoder = BinaryEncoder.init(std.testing.allocator);
    try encoder.appendNumber(u16, 100);
    var bytes = try encoder.asBytes();

    try expect(bytes[0] == 0x64);
    try expect(bytes[1] == 0x00);

    std.testing.allocator.free(bytes);
}

test "BinaryEncoder: should encode i16" {
    var encoder = BinaryEncoder.init(std.testing.allocator);
    try encoder.appendNumber(i16, -100);
    var bytes = try encoder.asBytes();

    std.debug.print("bytes[0] = {x}\n", .{bytes[1]});
    try expect(bytes[0] == 0x9c);
    try expect(bytes[1] == 0xff);

    std.testing.allocator.free(bytes);
}

test "BinarEncoder: should encode combination" {
    var encoder = BinaryEncoder.init(std.testing.allocator);
    try encoder.appendNumber(f32, 100.5);
    try encoder.appendString("hello");
    var bytes = try encoder.asBytes();
    try expect(bytes[0] == 0x00);
    try expect(bytes[1] == 0x00);
    try expect(bytes[2] == 0xc9);
    try expect(bytes[3] == 0x42);
    try expect(bytes[4] == 'h');
    try expect(bytes[5] == 'e');
    try expect(bytes[6] == 'l');
    try expect(bytes[7] == 'l');
    try expect(bytes[8] == 'o');

    std.testing.allocator.free(bytes);
}
