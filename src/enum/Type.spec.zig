const std = @import("std");
const Type = @import("Type.zig").Type;

test "Type: should convert integer to enum value" {
    try std.testing.expectEqual(Type.fromValue(0), Type.BOOLEAN);
    try std.testing.expectEqual(Type.fromValue(1), Type.INT32);
    try std.testing.expectEqual(Type.fromValue(2), Type.INT64);
    try std.testing.expectEqual(Type.fromValue(3), Type.INT96);
    try std.testing.expectEqual(Type.fromValue(4), Type.FLOAT);
    try std.testing.expectEqual(Type.fromValue(5), Type.DOUBLE);
    try std.testing.expectEqual(Type.fromValue(6), Type.BYTE_ARRAY);
    try std.testing.expectEqual(Type.fromValue(7), Type.FIXED_LEN_BYTE_ARRAY);
}

test "Type: should convert from enum" {
    try std.testing.expectEqual(@intFromEnum(Type.BOOLEAN), 0);
    try std.testing.expectEqual(@intFromEnum(Type.INT32), 1);
    try std.testing.expectEqual(@intFromEnum(Type.INT64), 2);
    try std.testing.expectEqual(@intFromEnum(Type.INT96), 3);
    try std.testing.expectEqual(@intFromEnum(Type.FLOAT), 4);
    try std.testing.expectEqual(@intFromEnum(Type.DOUBLE), 5);
    try std.testing.expectEqual(@intFromEnum(Type.BYTE_ARRAY), 6);
    try std.testing.expectEqual(@intFromEnum(Type.FIXED_LEN_BYTE_ARRAY), 7);
}

test "Type: should throw InvalidTypeValue" {
    const result = Type.fromValue(8);
    try std.testing.expectEqual(result, error.InvalidTypeValue);
}

pub fn main() void {
    _ = @import("std").testing.runTests();
}
