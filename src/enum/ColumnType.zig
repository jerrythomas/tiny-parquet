/// Types supported by Parquet.  These types are intended to be used in combination
/// with the encodings to control the on disk storage format.
/// For example INT16 is not included as a type since a good encoding of INT32
/// would handle this.
pub const ColumnType = enum(u8) {
    BOOLEAN = 0,
    INT32 = 1,
    INT64 = 2,
    INT96 = 3, // deprecated, only used by legacy implementations.
    FLOAT = 4,
    DOUBLE = 5,
    BYTE_ARRAY = 6,
    FIXED_LEN_BYTE_ARRAY = 7,

    pub fn fromValue(value: u8) !ColumnType {
        if (value > 7) {
            return error.InvalidColumnTypeValue;
        }
        return @as(ColumnType, @enumFromInt(value));
    }
};
