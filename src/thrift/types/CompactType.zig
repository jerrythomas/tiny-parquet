const std = @import("std");
const ThriftType = @import("ThriftType.zig").ThriftType;

pub const CompactType = enum(u8) {
    STOP = 0x00,
    TRUE = 0x01,
    FALSE = 0x02,
    BYTE = 0x03,
    I16 = 0x04,
    I32 = 0x05,
    I64 = 0x06,
    DOUBLE = 0x07,
    BINARY = 0x08,
    LIST = 0x09,
    SET = 0x0A,
    MAP = 0x0B,
    STRUCT = 0x0C,

    pub fn fromValue(value: u8) !CompactType {
        if (value > 0x0C) return error.InvalidCompactTypeValue;
        return @as(CompactType, @enumFromInt(value));
    }

    pub fn toValue(self: CompactType) u8 {
        return @intFromEnum(self);
    }

    pub fn asThriftType(self: CompactType) ThriftType {
        switch (self) {
            .STOP => return ThriftType.STOP,
            .TRUE => return ThriftType.BOOL,
            .FALSE => return ThriftType.BOOL,
            .BYTE => return ThriftType.BYTE,
            .I16 => return ThriftType.I16,
            .I32 => return ThriftType.I32,
            .I64 => return ThriftType.I64,
            .DOUBLE => return ThriftType.DOUBLE,
            .BINARY => return ThriftType.STRING,
            .LIST => return ThriftType.LIST,
            .SET => return ThriftType.SET,
            .MAP => return ThriftType.MAP,
            .STRUCT => return ThriftType.STRUCT,
        }
    }
};

test "CompactType: should convert integer to enum value" {
    try std.testing.expectEqual(CompactType.fromValue(0x00), CompactType.STOP);
    try std.testing.expectEqual(CompactType.fromValue(0x01), CompactType.TRUE);
    try std.testing.expectEqual(CompactType.fromValue(0x02), CompactType.FALSE);
    try std.testing.expectEqual(CompactType.fromValue(0x03), CompactType.BYTE);

    try std.testing.expectEqual(CompactType.fromValue(0x04), CompactType.I16);
    try std.testing.expectEqual(CompactType.fromValue(0x05), CompactType.I32);
    try std.testing.expectEqual(CompactType.fromValue(0x06), CompactType.I64);
    try std.testing.expectEqual(CompactType.fromValue(0x07), CompactType.DOUBLE);

    try std.testing.expectEqual(CompactType.fromValue(0x08), CompactType.BINARY);
    try std.testing.expectEqual(CompactType.fromValue(0x09), CompactType.LIST);
    try std.testing.expectEqual(CompactType.fromValue(0x0A), CompactType.SET);
    try std.testing.expectEqual(CompactType.fromValue(0x0B), CompactType.MAP);
    try std.testing.expectEqual(CompactType.fromValue(0x0C), CompactType.STRUCT);
}

test "CompactType: should convert from enum" {
    try std.testing.expect(CompactType.STOP.toValue() == 0x00);
    try std.testing.expect(CompactType.TRUE.toValue() == 0x01);
    try std.testing.expect(CompactType.FALSE.toValue() == 0x02);
    try std.testing.expect(CompactType.BYTE.toValue() == 0x03);

    try std.testing.expect(CompactType.I16.toValue() == 0x04);
    try std.testing.expect(CompactType.I32.toValue() == 0x05);
    try std.testing.expect(CompactType.I64.toValue() == 0x06);
    try std.testing.expect(CompactType.DOUBLE.toValue() == 0x07);

    try std.testing.expect(CompactType.BINARY.toValue() == 0x08);
    try std.testing.expect(CompactType.LIST.toValue() == 0x09);
    try std.testing.expect(CompactType.SET.toValue() == 0x0A);
    try std.testing.expect(CompactType.MAP.toValue() == 0x0B);
    try std.testing.expect(CompactType.STRUCT.toValue() == 0x0C);
}

test "CompactType: should throw InvalidCompactTypeValue" {
    var result = CompactType.fromValue(0x0D);
    try std.testing.expectEqual(result, error.InvalidCompactTypeValue);
}
