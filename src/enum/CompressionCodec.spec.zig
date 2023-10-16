const std = @import("std");
const CompressionCodec = @import("CompressionCodec.zig").CompressionCodec;

test "CompressionCodec: should convert integer to enum value" {
    try std.testing.expectEqual(CompressionCodec.fromValue(0), CompressionCodec.UNCOMPRESSED);
    try std.testing.expectEqual(CompressionCodec.fromValue(1), CompressionCodec.SNAPPY);
    try std.testing.expectEqual(CompressionCodec.fromValue(2), CompressionCodec.GZIP);
    try std.testing.expectEqual(CompressionCodec.fromValue(3), CompressionCodec.LZO);
    try std.testing.expectEqual(CompressionCodec.fromValue(4), CompressionCodec.BROTLI);
    try std.testing.expectEqual(CompressionCodec.fromValue(5), CompressionCodec.LZ4);
    try std.testing.expectEqual(CompressionCodec.fromValue(6), CompressionCodec.ZSTD);
    try std.testing.expectEqual(CompressionCodec.fromValue(7), CompressionCodec.LZ4_RAW);
}

test "CompressionCodec: should convert from enum" {
    try std.testing.expectEqual(@intFromEnum(CompressionCodec.UNCOMPRESSED), 0);
    try std.testing.expectEqual(@intFromEnum(CompressionCodec.SNAPPY), 1);
    try std.testing.expectEqual(@intFromEnum(CompressionCodec.GZIP), 2);
    try std.testing.expectEqual(@intFromEnum(CompressionCodec.LZO), 3);
    try std.testing.expectEqual(@intFromEnum(CompressionCodec.BROTLI), 4);
    try std.testing.expectEqual(@intFromEnum(CompressionCodec.LZ4), 5);
    try std.testing.expectEqual(@intFromEnum(CompressionCodec.ZSTD), 6);
    try std.testing.expectEqual(@intFromEnum(CompressionCodec.LZ4_RAW), 7);
}

test "CompressionCodec: should throw InvalidCompressionCodecValue" {
    const result = CompressionCodec.fromValue(8);
    try std.testing.expectEqual(result, error.InvalidCompressionCodecValue);
}

pub fn main() void {
    _ = @import("std").testing.runTests();
}
