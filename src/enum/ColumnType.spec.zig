const std = @import("std");
const ColumnType = @import("ColumnType.zig").ColumnType;

test "ColumnType: should convert integer to enum value" {
    try std.testing.expectEqual(ColumnType.fromValue(0), ColumnType.BOOLEAN);
    try std.testing.expectEqual(ColumnType.fromValue(1), ColumnType.INT32);
    try std.testing.expectEqual(ColumnType.fromValue(2), ColumnType.INT64);
    try std.testing.expectEqual(ColumnType.fromValue(3), ColumnType.INT96);
    try std.testing.expectEqual(ColumnType.fromValue(4), ColumnType.FLOAT);
    try std.testing.expectEqual(ColumnType.fromValue(5), ColumnType.DOUBLE);
    try std.testing.expectEqual(ColumnType.fromValue(6), ColumnType.BYTE_ARRAY);
    try std.testing.expectEqual(ColumnType.fromValue(7), ColumnType.FIXED_LEN_BYTE_ARRAY);
}

test "ColumnType: should convert from enum" {
    try std.testing.expectEqual(@intFromEnum(ColumnType.BOOLEAN), 0);
    try std.testing.expectEqual(@intFromEnum(ColumnType.INT32), 1);
    try std.testing.expectEqual(@intFromEnum(ColumnType.INT64), 2);
    try std.testing.expectEqual(@intFromEnum(ColumnType.INT96), 3);
    try std.testing.expectEqual(@intFromEnum(ColumnType.FLOAT), 4);
    try std.testing.expectEqual(@intFromEnum(ColumnType.DOUBLE), 5);
    try std.testing.expectEqual(@intFromEnum(ColumnType.BYTE_ARRAY), 6);
    try std.testing.expectEqual(@intFromEnum(ColumnType.FIXED_LEN_BYTE_ARRAY), 7);
}

test "ColumnType: should throw InvalidColumnTypeValue" {
    const result = ColumnType.fromValue(8);
    try std.testing.expectEqual(result, error.InvalidColumnTypeValue);
}

pub fn main() void {
    _ = @import("std").testing.runTests();
}
