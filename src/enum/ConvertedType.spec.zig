const std = @import("std");
const ConvertedType = @import("ConvertedType.zig").ConvertedType;

test "ConvertedType: should convert integer to enum value" {
    try std.testing.expectEqual(ConvertedType.fromValue(0), ConvertedType.UTF8);
    try std.testing.expectEqual(ConvertedType.fromValue(1), ConvertedType.MAP);
    try std.testing.expectEqual(ConvertedType.fromValue(2), ConvertedType.MAP_KEY_VALUE);
    try std.testing.expectEqual(ConvertedType.fromValue(3), ConvertedType.LIST);
    try std.testing.expectEqual(ConvertedType.fromValue(4), ConvertedType.ENUM);
    try std.testing.expectEqual(ConvertedType.fromValue(5), ConvertedType.DECIMAL);
    try std.testing.expectEqual(ConvertedType.fromValue(6), ConvertedType.DATE);
    try std.testing.expectEqual(ConvertedType.fromValue(7), ConvertedType.TIME_MILLIS);
    try std.testing.expectEqual(ConvertedType.fromValue(8), ConvertedType.TIME_MICROS);
    try std.testing.expectEqual(ConvertedType.fromValue(9), ConvertedType.TIMESTAMP_MILLIS);
    try std.testing.expectEqual(ConvertedType.fromValue(10), ConvertedType.TIMESTAMP_MICROS);
    try std.testing.expectEqual(ConvertedType.fromValue(11), ConvertedType.UINT_8);
    try std.testing.expectEqual(ConvertedType.fromValue(12), ConvertedType.UINT_16);
    try std.testing.expectEqual(ConvertedType.fromValue(13), ConvertedType.UINT_32);
    try std.testing.expectEqual(ConvertedType.fromValue(14), ConvertedType.UINT_64);
    try std.testing.expectEqual(ConvertedType.fromValue(15), ConvertedType.INT_8);
    try std.testing.expectEqual(ConvertedType.fromValue(16), ConvertedType.INT_16);
    try std.testing.expectEqual(ConvertedType.fromValue(17), ConvertedType.INT_32);
    try std.testing.expectEqual(ConvertedType.fromValue(18), ConvertedType.INT_64);
    try std.testing.expectEqual(ConvertedType.fromValue(19), ConvertedType.JSON);
    try std.testing.expectEqual(ConvertedType.fromValue(20), ConvertedType.BSON);
    try std.testing.expectEqual(ConvertedType.fromValue(21), ConvertedType.INTERVAL);
}

test "ConvertedType: should convert from enum" {
    try std.testing.expect(ConvertedType.UTF8.toValue() == 0);
    try std.testing.expect(ConvertedType.MAP.toValue() == 1);
    try std.testing.expect(ConvertedType.MAP_KEY_VALUE.toValue() == 2);
    try std.testing.expect(ConvertedType.LIST.toValue() == 3);
    try std.testing.expect(ConvertedType.ENUM.toValue() == 4);
    try std.testing.expect(ConvertedType.DECIMAL.toValue() == 5);
    try std.testing.expect(ConvertedType.DATE.toValue() == 6);
    try std.testing.expect(ConvertedType.TIME_MILLIS.toValue() == 7);
    try std.testing.expect(ConvertedType.TIME_MICROS.toValue() == 8);
    try std.testing.expect(ConvertedType.TIMESTAMP_MILLIS.toValue() == 9);
    try std.testing.expect(ConvertedType.TIMESTAMP_MICROS.toValue() == 10);
    try std.testing.expect(ConvertedType.UINT_8.toValue() == 11);
    try std.testing.expect(ConvertedType.UINT_16.toValue() == 12);
    try std.testing.expect(ConvertedType.UINT_32.toValue() == 13);
    try std.testing.expect(ConvertedType.UINT_64.toValue() == 14);
    try std.testing.expect(ConvertedType.INT_8.toValue() == 15);
    try std.testing.expect(ConvertedType.INT_16.toValue() == 16);
    try std.testing.expect(ConvertedType.INT_32.toValue() == 17);
    try std.testing.expect(ConvertedType.INT_64.toValue() == 18);
    try std.testing.expect(ConvertedType.JSON.toValue() == 19);
    try std.testing.expect(ConvertedType.BSON.toValue() == 20);
    try std.testing.expect(ConvertedType.INTERVAL.toValue() == 21);
}

test "ConvertedType: should throw InvalidConvertedTypeValue" {
    const result = ConvertedType.fromValue(22);
    try std.testing.expectEqual(result, error.InvalidConvertedTypeValue);
}

pub fn main() void {
    _ = try std.testing.runAllTests();
}
