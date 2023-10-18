const std = @import("std");
const Encoding = @import("Encoding.zig").Encoding;

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
    try std.testing.expectEqual(@intFromEnum(Encoding.PLAIN), 0);
    // try std.testing.expectEqual(@intFromEnum(Encoding.SNAPPY), 1);
    try std.testing.expectEqual(@intFromEnum(Encoding.PLAIN_DICTIONARY), 2);
    try std.testing.expectEqual(@intFromEnum(Encoding.RLE), 3);
    try std.testing.expectEqual(@intFromEnum(Encoding.BIT_PACKED), 4);
    try std.testing.expectEqual(@intFromEnum(Encoding.DELTA_BINARY_PACKED), 5);
    try std.testing.expectEqual(@intFromEnum(Encoding.DELTA_LENGTH_BYTE_ARRAY), 6);
    try std.testing.expectEqual(@intFromEnum(Encoding.DELTA_BYTE_ARRAY), 7);
    try std.testing.expectEqual(@intFromEnum(Encoding.RLE_DICTIONARY), 8);
    try std.testing.expectEqual(@intFromEnum(Encoding.BYTE_STREAM_SPLIT), 9);
}

test "Encoding: should throw InvalidEncodingValue" {
    var result = Encoding.fromValue(10);
    try std.testing.expectEqual(result, error.InvalidEncodingValue);
    result = Encoding.fromValue(1);
    try std.testing.expectEqual(result, error.InvalidEncodingValue);
}

pub fn main() void {
    _ = try std.testing.runAllTests();
}
