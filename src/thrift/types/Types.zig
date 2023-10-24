const std = @import("std");
pub const Types = enum(u8) {
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

    pub fn fromValue(value: u8) !Types {
        switch (value) {
            5, 7, 9 => return error.InvalidTypesValue,
            else => {
                if (value > 17) return error.InvalidTypesValue;
                return @as(Types, @enumFromInt(value));
            },
        }
    }

    pub fn toValue(self: Types) u8 {
        return @intFromEnum(self);
    }
};

test "Types: should convert integer to enum value" {
    try std.testing.expectEqual(Types.fromValue(0), Types.STOP);
    try std.testing.expectEqual(Types.fromValue(1), Types.VOID);
    try std.testing.expectEqual(Types.fromValue(2), Types.BOOL);
    try std.testing.expectEqual(Types.fromValue(3), Types.BYTE);

    try std.testing.expectEqual(Types.fromValue(4), Types.DOUBLE);
    try std.testing.expectEqual(Types.fromValue(6), Types.I16);
    try std.testing.expectEqual(Types.fromValue(8), Types.I32);
    try std.testing.expectEqual(Types.fromValue(10), Types.I64);
    try std.testing.expectEqual(Types.fromValue(11), Types.STRING);

    try std.testing.expectEqual(Types.fromValue(12), Types.STRUCT);
    try std.testing.expectEqual(Types.fromValue(13), Types.MAP);
    try std.testing.expectEqual(Types.fromValue(14), Types.SET);
    try std.testing.expectEqual(Types.fromValue(15), Types.LIST);
    try std.testing.expectEqual(Types.fromValue(16), Types.UTF8);
    try std.testing.expectEqual(Types.fromValue(17), Types.UTF16);
}

test "Types: should convert from enum" {
    try std.testing.expect(Types.STOP.toValue() == 0);
    try std.testing.expect(Types.VOID.toValue() == 1);
    try std.testing.expect(Types.BOOL.toValue() == 2);
    try std.testing.expect(Types.BYTE.toValue() == 3);

    try std.testing.expect(Types.DOUBLE.toValue() == 4);
    try std.testing.expect(Types.I16.toValue() == 6);
    try std.testing.expect(Types.I32.toValue() == 8);
    try std.testing.expect(Types.I64.toValue() == 10);
    try std.testing.expect(Types.STRING.toValue() == 11);

    try std.testing.expect(Types.STRUCT.toValue() == 12);
    try std.testing.expect(Types.MAP.toValue() == 13);
    try std.testing.expect(Types.SET.toValue() == 14);
    try std.testing.expect(Types.LIST.toValue() == 15);
    try std.testing.expect(Types.UTF8.toValue() == 16);
    try std.testing.expect(Types.UTF16.toValue() == 17);
}

test "Types: should throw InvalidTypesValue" {
    const invalidValues = [_]u8{ 5, 7, 9, 18 };
    for (invalidValues) |value| {
        const result = Types.fromValue(value);
        try std.testing.expectEqual(result, error.InvalidTypesValue);
    }
}
