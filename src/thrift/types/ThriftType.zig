const std = @import("std");
pub const ThriftType = enum(u8) {
    STOP = 0,
    VOID = 1,
    BOOL = 2,
    BYTE = 3,
    // I08 = 3,
    DOUBLE = 4,
    I16 = 6,
    I32 = 8,
    I64 = 10,
    STRING = 11,
    // UTF7 = 11,
    STRUCT = 12,
    MAP = 13,
    SET = 14,
    LIST = 15,
    UTF8 = 16,
    UTF16 = 17,

    pub fn fromValue(value: u8) !ThriftType {
        switch (value) {
            5, 7, 9 => return error.InvalidTypesValue,
            else => {
                if (value > 17) return error.InvalidTypesValue;
                return @as(ThriftType, @enumFromInt(value));
            },
        }
    }

    pub fn toValue(self: ThriftType) u8 {
        return @intFromEnum(self);
    }
};

test "ThriftTypes: should convert integer to enum value" {
    try std.testing.expectEqual(ThriftType.fromValue(0), ThriftType.STOP);
    try std.testing.expectEqual(ThriftType.fromValue(1), ThriftType.VOID);
    try std.testing.expectEqual(ThriftType.fromValue(2), ThriftType.BOOL);
    try std.testing.expectEqual(ThriftType.fromValue(3), ThriftType.BYTE);

    try std.testing.expectEqual(ThriftType.fromValue(4), ThriftType.DOUBLE);
    try std.testing.expectEqual(ThriftType.fromValue(6), ThriftType.I16);
    try std.testing.expectEqual(ThriftType.fromValue(8), ThriftType.I32);
    try std.testing.expectEqual(ThriftType.fromValue(10), ThriftType.I64);
    try std.testing.expectEqual(ThriftType.fromValue(11), ThriftType.STRING);

    try std.testing.expectEqual(ThriftType.fromValue(12), ThriftType.STRUCT);
    try std.testing.expectEqual(ThriftType.fromValue(13), ThriftType.MAP);
    try std.testing.expectEqual(ThriftType.fromValue(14), ThriftType.SET);
    try std.testing.expectEqual(ThriftType.fromValue(15), ThriftType.LIST);
    try std.testing.expectEqual(ThriftType.fromValue(16), ThriftType.UTF8);
    try std.testing.expectEqual(ThriftType.fromValue(17), ThriftType.UTF16);
}

test "ThriftTypes: should convert from enum" {
    try std.testing.expect(ThriftType.STOP.toValue() == 0);
    try std.testing.expect(ThriftType.VOID.toValue() == 1);
    try std.testing.expect(ThriftType.BOOL.toValue() == 2);
    try std.testing.expect(ThriftType.BYTE.toValue() == 3);

    try std.testing.expect(ThriftType.DOUBLE.toValue() == 4);
    try std.testing.expect(ThriftType.I16.toValue() == 6);
    try std.testing.expect(ThriftType.I32.toValue() == 8);
    try std.testing.expect(ThriftType.I64.toValue() == 10);
    try std.testing.expect(ThriftType.STRING.toValue() == 11);

    try std.testing.expect(ThriftType.STRUCT.toValue() == 12);
    try std.testing.expect(ThriftType.MAP.toValue() == 13);
    try std.testing.expect(ThriftType.SET.toValue() == 14);
    try std.testing.expect(ThriftType.LIST.toValue() == 15);
    try std.testing.expect(ThriftType.UTF8.toValue() == 16);
    try std.testing.expect(ThriftType.UTF16.toValue() == 17);
}

test "ThriftTypes: should throw InvalidTypesValue" {
    const invalidValues = [_]u8{ 5, 7, 9, 18 };
    for (invalidValues) |value| {
        const result = ThriftType.fromValue(value);
        try std.testing.expectEqual(result, error.InvalidTypesValue);
    }
}
