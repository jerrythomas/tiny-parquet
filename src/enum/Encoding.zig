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
};
