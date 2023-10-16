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
};
