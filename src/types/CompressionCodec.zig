const std = @import("std");
/// Supported compression algorithms.
///
/// Codecs added in format version X.Y can be read by readers based on X.Y and later.
/// Codec support may vary between readers based on the format version and
/// libraries available at runtime.
///
/// See Compression.md for a detailed specification of these algorithms.
///
pub const CompressionCodec = enum(u8) {
    UNCOMPRESSED = 0,
    SNAPPY = 1,
    GZIP = 2,
    LZO = 3,
    BROTLI = 4, // Added in 2.4
    LZ4 = 5, // DEPRECATED (Added in 2.4)
    ZSTD = 6, // Added in 2.4
    LZ4_RAW = 7, // Added in 2.9

    pub fn fromValue(value: u8) !CompressionCodec {
        if (value >= 0 and value <= 7) {
            return @as(CompressionCodec, @enumFromInt(value));
        } else {
            return error.InvalidCompressionCodecValue;
        }
    }

    pub fn toValue(self: CompressionCodec) u8 {
        return @intFromEnum(self);
    }
};

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
