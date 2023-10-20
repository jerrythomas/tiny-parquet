const std = @import("std");
const CompressionCodec = @import("enum").CompressionCodec;

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
    try std.testing.expect(CompressionCodec.UNCOMPRESSED.toValue() == 0);
    try std.testing.expect(CompressionCodec.SNAPPY.toValue() == 1);
    try std.testing.expect(CompressionCodec.GZIP.toValue() == 2);
    try std.testing.expect(CompressionCodec.LZO.toValue() == 3);
    try std.testing.expect(CompressionCodec.BROTLI.toValue() == 4);
    try std.testing.expect(CompressionCodec.LZ4.toValue() == 5);
    try std.testing.expect(CompressionCodec.ZSTD.toValue() == 6);
    try std.testing.expect(CompressionCodec.LZ4_RAW.toValue() == 7);
}

test "CompressionCodec: should throw InvalidCompressionCodecValue" {
    const result = CompressionCodec.fromValue(8);
    try std.testing.expectEqual(result, error.InvalidCompressionCodecValue);
}

pub fn main() void {
    _ = try std.testing.runAllTests();
}
