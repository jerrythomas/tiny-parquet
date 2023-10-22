const std = @import("std");
const DataType = @import("types").DataType;

test "DataType: should convert integer to enum value" {
    try std.testing.expectEqual(DataType.fromValue(0), DataType.BOOLEAN);
    try std.testing.expectEqual(DataType.fromValue(1), DataType.INT32);
    try std.testing.expectEqual(DataType.fromValue(2), DataType.INT64);
    try std.testing.expectEqual(DataType.fromValue(3), DataType.INT96);
    try std.testing.expectEqual(DataType.fromValue(4), DataType.FLOAT);
    try std.testing.expectEqual(DataType.fromValue(5), DataType.DOUBLE);
    try std.testing.expectEqual(DataType.fromValue(6), DataType.BYTE_ARRAY);
    try std.testing.expectEqual(DataType.fromValue(7), DataType.FIXED_LEN_BYTE_ARRAY);
}

test "DataType: should convert from enum" {
    try std.testing.expect(DataType.BOOLEAN.toValue() == 0);
    try std.testing.expect(DataType.INT32.toValue() == 1);
    try std.testing.expect(DataType.INT64.toValue() == 2);
    try std.testing.expect(DataType.INT96.toValue() == 3);
    try std.testing.expect(DataType.FLOAT.toValue() == 4);
    try std.testing.expect(DataType.DOUBLE.toValue() == 5);
    try std.testing.expect(DataType.BYTE_ARRAY.toValue() == 6);
    try std.testing.expect(DataType.FIXED_LEN_BYTE_ARRAY.toValue() == 7);
}

test "DataType: should throw InvalidDataTypeValue" {
    const result = DataType.fromValue(8);
    try std.testing.expectEqual(result, error.InvalidDataTypeValue);
}

pub fn main() void {
    _ = try std.testing.runAllTests();
}
