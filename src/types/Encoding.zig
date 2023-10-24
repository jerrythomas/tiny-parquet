const std = @import("std");

pub const Encoding = enum(u8) {
    PLAIN = 0,
    PLAIN_DICTIONARY = 2,
    RLE = 3,
    BIT_PACKED = 4,
    DELTA_BINARY_PACKED = 5,
    DELTA_LENGTH_BYTE_ARRAY = 6,
    DELTA_BYTE_ARRAY = 7,
    RLE_DICTIONARY = 8,
    BYTE_STREAM_SPLIT = 9,

    pub fn fromValue(value: u8) !Encoding {
        if (value > 9 or value == 1) {
            return error.InvalidEncodingValue;
        }

        return @as(Encoding, @enumFromInt(value));
    }

    pub fn toValue(self: Encoding) u8 {
        return @intFromEnum(self);
    }
};

test "Encoding: should convert integer to enum value" {
    try std.testing.expectEqual(Encoding.fromValue(0), Encoding.PLAIN);
    // try std.testing.expectEqual(Encoding.fromValue(1), Encoding.SNAPPY);
    try std.testing.expectEqual(Encoding.fromValue(2), Encoding.PLAIN_DICTIONARY);
    try std.testing.expectEqual(Encoding.fromValue(3), Encoding.RLE);
    try std.testing.expectEqual(Encoding.fromValue(4), Encoding.BIT_PACKED);
    try std.testing.expectEqual(Encoding.fromValue(5), Encoding.DELTA_BINARY_PACKED);
    try std.testing.expectEqual(Encoding.fromValue(6), Encoding.DELTA_LENGTH_BYTE_ARRAY);
    try std.testing.expectEqual(Encoding.fromValue(7), Encoding.DELTA_BYTE_ARRAY);
    try std.testing.expectEqual(Encoding.fromValue(8), Encoding.RLE_DICTIONARY);
    try std.testing.expectEqual(Encoding.fromValue(9), Encoding.BYTE_STREAM_SPLIT);
}

test "Encoding: should convert from enum" {
    try std.testing.expect(Encoding.PLAIN.toValue() == 0);
    // try std.testing.expect(Encoding.SNAPPY.toValue() == 1);
    try std.testing.expect(Encoding.PLAIN_DICTIONARY.toValue() == 2);
    try std.testing.expect(Encoding.RLE.toValue() == 3);
    try std.testing.expect(Encoding.BIT_PACKED.toValue() == 4);
    try std.testing.expect(Encoding.DELTA_BINARY_PACKED.toValue() == 5);
    try std.testing.expect(Encoding.DELTA_LENGTH_BYTE_ARRAY.toValue() == 6);
    try std.testing.expect(Encoding.DELTA_BYTE_ARRAY.toValue() == 7);
    try std.testing.expect(Encoding.RLE_DICTIONARY.toValue() == 8);
    try std.testing.expect(Encoding.BYTE_STREAM_SPLIT.toValue() == 9);
}

test "Encoding: should throw InvalidEncodingValue" {
    var result = Encoding.fromValue(10);
    try std.testing.expectEqual(result, error.InvalidEncodingValue);
    result = Encoding.fromValue(1);
    try std.testing.expectEqual(result, error.InvalidEncodingValue);
}
